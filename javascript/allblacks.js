//
// allblacks.js
// 
// @author izibazi
// @fileoverview This library require jquery.js and underscore.js.
// @description This library is too old..... I will update soon. (2015)
//
// Allblacks.Constants (alias: Allblacks.Consts)
// Allblacks.NotificationCenter (This is like Cocoa's NotifictionCenter.)
// Allblacks.Debug (alias: Allblacks.D)
// Allblacks.WindowScroller
// Allblacks.WindowResizer
// Allblccks.ModalWindow (This is bad.Too old.)
// Allblacks.ImageLoader (Class)
// Allblacks.Environment (alias: Allblacks.Env)
// Allblacks.ImageButton
// Allblacks.ImageUtil
// Allblacks.Audio
// Allblacks.Geom (This is like namespace just now.)
// Allblacks.Geom.Point (Class)
// Allblacks.Geom.Rect (Class, alias: Allblacks.Geom.Rectangle)

// Inizialized.
(function(){
	var inited_ = false;
	var root_ = this;
	var $window_ = $(window);
	var AB_ = root_.Allblacks = {};

	var READY_BEFORE_JQUERY_EVENT_ = 'READY_BEFORE_JQUERY_EVENT';
	var READY_JQUERY_EVENT_ = 'READY_JQUERY_EVENT';
	var READY_AFTER_JQUERY_EVENT_ = 'READY_AFTER_JQUERY_EVENT';

	//You should define Common Application Logic.It is user data.
	AB_.app = {};

	//jquery ready.
	$(function() {
		if(inited_) {
			return;
		}
		inited_ = true;
		WindowResizer_.init();
		WindowScroller_.init();
		//Post jquery ready event.
		NotificationCenter_.post(READY_BEFORE_JQUERY_EVENT_, [AB_]);
		NotificationCenter_.post(READY_JQUERY_EVENT_, [AB_]);
		NotificationCenter_.post(READY_AFTER_JQUERY_EVENT_, [AB_]);
		WindowResizer_.post();
		WindowScroller_.post();
	});

	AB_.ready = function(context, startCallback) {
		NotificationCenter_.add(READY_JQUERY_EVENT_, context, startCallback);
	};

	AB_.readyBefore = function(context, beforeCallback) {
		NotificationCenter_.add(READY_BEFORE_JQUERY_EVENT_, context, beforeCallback);
	};

	AB_.readyAfter = function(context, afterCallback) {
		NotificationCenter_.add(READY_AFTER_JQUERY_EVENT_, context, afterCallback);
	};

	var Constants_ = AB_.Constants = AB_.Consts = {
		MINUTE: 60 * 1000, 
		HOUR: 3600 * 1000,
		DAY: 86400 * 1000,
		WEEK: 604800 * 1000,
		MONTH: 2592000 * 1000,
		YEAR: 31536000 * 1000,
		APP_START_TIME: new Date().getTime()
	};

	/**
	 * Console Utility.
	 */
	var D_ = AB_.D = AB_.Debug = (function() {
		// Private vars.
		var enabledConsole_ = typeof console != 'undefined' && typeof console.log != 'undefined';
		var enabled_ = false;
		var disableFunc_ = function() {};

		var D = {
			enabled: function(verbose, useAlertIfNotExistsConsole) {
				if (enabled_ === verbose) {
					return;
				}
				enabled_= verbose;
				if (enabled_) {
					if(enabledConsole_) {
						this.log = function(args) {
							console.log.apply(console, arguments);
						};
						this.warn = function(args) {
							console.warn.apply(console, arguments);
						};
						this.error = function(args) {
							console.error.apply(console, arguments);
						};
						this.assert = function(condition, args) {
							console.assert.apply(console, [condition, arguments])
						};
						this.clear = function() {
							console.clear();
						}

						return;
					}

					// use alert.
					// TODO not good.
					if(useAlertIfNotExistsConsole) {
						this.log = function(args) {
							alert(args);
						};
						this.warn = function(args) {
							alert('warn : ' + args);
						};
						this.error = function(args) {
							alert('error : ' + args);
						};
						this.assert = function(condition, args) {
							alert('assert : ' + condition + ', ' + args);
						};

						return;
					}
				}

				this.disable();
			},

			disable: function() {
				//do nothing.
				enabled_ = false;
				this.log = this.warn = this.error = this.assert = this.clear = disableFunc_;
			},

			toString: function() {
				var s = 'Allblacks.Debug (';
				s += 'enabled=' + enabled_ + ', ';
				s += 'enabledConsole=' + enabledConsole_;
				s += ')';

				return s;
			}
		};

		D.disable();
		return D;
	}).call(root_);

	/**
	 * Simply Event Dispatcher.
	 * like iOS NSNotificationCenter Class.
	 */
	var NotificationCenter_ = AB_.NotificationCenter = (function() {
		//private vars
		var observers_ = {};

		var obj = {
			/**
			 * Add observer.
			 */
			add: function(name, context, callback) {
				if (!name || !callback) {
					return;
				}
				var list = observers_[name] || [];
				//if already added, return.
				for (var i in list) {
					if (list[i].context == context && list[i].callback == callback) {
						return;
					}
				}

				var observer = {context: context, callback: callback};
				list.push(observer);
				observers_[name] = list;
			},

			/**
			 * Remove observer.
			 */
			remove: function(name, context, callback) {
				//all remove observers.
				if (name === null && context === null && callback === null) {
					observers = {};
					return;
				}

				//Remove all by context.
				if (name === null && context) {
					for (var i in observers_) {
						var list = observers_[i];
						var newList = [];
						for (var j in list[j]) {
							if (list[j].context != context) {
								newList.push(list[j]);
							}
						}
						observers_[i] = newList;
					}

					return;
				}

				if (!observers_[name]) {
					return;
				}

				//Remove all by name.
				if (context === null && callback === null) {
					observers_[name] = null
					delete observers_[name];
					return;
				}

				//Remove.
				var list = observers_[name];
				var newList = [];
				for(var i in list) {
					var observer = list[i];
					if (observer.context == context) {
						if(callback == null) {
							list[i] = null;
							delete list[i];
						} else if (callback != null && observer.callback == callback) {
							list[i] = null;
							delete list[i];
						} else {
							newList[i] = list[i];
						}
					} else {
						newList[i] = list[i];
					}
				}
				observers_[name] = newList;
			},

			/**
			 * Post to observers.
			 */
			post: function(name, args) {
				var list = observers_[name];
				if (!list) {
					return;
				}

				var len = list.length;
				for(var i = 0; i < len; i++) {
					var observer = list[i];
					if (!observer) {
						continue;
					}
					var context = observer.context;
					var callback = observer.callback;
					if (callback === null) {
						continue;
					}
					callback.apply(context, args);
				}
			}
		};

		return obj;
	}).call(root_);

	/**
	 * Window Resize Management.
	 */
	var WindowResizer_ = AB_.WindowResizer = (function() {
		//private vars
		var w_ = 0;
		var h_ = 0;
		var enabled_ = true;
		var inited_ = false;
		var rect_ = null;

		var obj = {
			RESIZE: 'Allblacks.WindowResizer.RESIZE',
			init: function() {
				if (inited_) {
					return;
				}
				inited_= true;

				var scope = this;
				w_ = $window_.width();
				h_ = $window_.height();
				rect_ = new AB_.Geom.Rect(0, 0, w_, h_);

				$window_.resize(function() {
					if(!enabled_) {
						return;
					}

					w_ = $window_.width();
					h_ = $window_.height();
					rect_.width = w_;
					rect_.height= h_;

					scope.post();
				});
			},

			width: function() {
				return w_;
			},

			height: function() {
				return h_;
			},

			rect: function() {
				//read only.
				return rect_.clone();
			},

			addObserver: function(context, callback) {
				NotificationCenter_.add(this.RESIZE, context, callback);
				return this;
			},

			removeObserver: function(context, callback) {
				NotificationCenter_.remove(this.RESIZE, context, callback);
				return this;
			},

			post: function() {
				NotificationCenter_.post(this.RESIZE, [this, w_, h_]);
				return this;
			},

			enabled: function(val) {
				enabled_ = val;
				return this;
			},

			toString: function() {
				var s = 'Allblacks.WindowResizer (';
				s += 'inited=' + inited_ + ', ';
				s += 'w=' + w_ + ', ';
				s += 'h=' + h_;
				s += ')';

				return s;
			}
		};

		return obj;

	}).call(root_);

	/**
	 * Window Scroll Management.
	 */
	var WindowScroller_ = AB_.WindowScroller = (function(){
		//private vars
		var inited_ = false;
		var now_ = 0;
		var prev_ = 0;
		var to_ = false;
		var distance_ = now_ - prev_;
		var isUp_ = false;
		var isDown_ = false;
		var isChanged_ = false;
		var enabled_ = true;
		var isAnimating_ = false;
		var $target_;

		var rect_ = null;

		var postParameters_ = function() {
			return [WindowScroller_, to_, now_, prev_, isUp_, isDown_, isChanged_];
		};

		var update_ = function() {
			if(!enabled_) {
				return;
			}
			prev_ = now_;
			now_ = $window_.scrollTop();
			distance_ = now_ - prev_;
			isChanged_ = distance_ !== 0;
			isUp_ = distance_ < 0;
			isDown_ = distance_ > 0;
			WindowScroller_.post();
		}

		var obj = {
			SCROLL: 'Allblacks.WindowScroller.SCROLL',
			SCROLL_ANIMATE_START: 'Allblacks.WindowScroller.SCROLL_ANIMATE_START',
			SCROLL_ANIMATE_COMPLETE: 'Allblacks.WindowScroller.SCROLL_ANIMATE_COMPLETE',
			DEFAULT_EASE_TYPE: 'easeInOutExpo',
			init: function() {
				if (inited_) {
					return;
				}

				inited_ = true;
				var scope = this;
				$target_ = $('html, body');

				//if include jquery.mousewheel.js
				if (typeof $('html').mousewheel !== 'undefined') {
					$target_.mousewheel(function() {
						if(!enabled_) {
							return;
						}
						WindowScroller_.stop();
					});
				}

				$window_.scroll(function() {
					update_();
				});
			},

			prev: function() {
				return prev_;
			},

			to: function() {
				return to_;
			},

			now: function() {
				return now_;
			},

			distance: function() {
				return distance_;
			},

			isUp: function() {
				return isUp_;
			},

			isDown: function() {
				return isDown_;
			},

			isChanged: function() {
				return isChanged_;
			},

			scrollTo: function(to, time, easing) {
				var scope = this;
				this.stop(true, true);
				if (isNaN(time) || time < 1) {
					time = 0;
				}
				to_ = to;
				if (time === 0) {
					$target_.scrollTop(to);
					return;
				}
				isAnimating_ = true;
				NotificationCenter_.post(scope.SCROLL_ANIMATE_START, postParameters_());
				$target_.animate({'scrollTop': to_}, time, easing || this.DEFAULT_EASE_TYPE, function() {
					if(isAnimating_) {
						isAnimating_ = false;
						//$target_.css('scrollTop', to_);
						update_();
						NotificationCenter_.post(scope.SCROLL_ANIMATE_COMPLETE, postParameters_());
					}
				});
			},

			scrollToPercent: function(percent, time, easing) {
				var to = this.bottom() * percent;
				this.scrollTo(to, time, easing);
			},

			scrollToElement: function(element, time, easing) {
				var to = element.offset().top;
				this.scrollTo(to, time, easing);
			},

			toTop: function(time, easing) {
				this.scrollTo(0, time, easing);
			},

			toBottom: function(time, easing) {
				this.scrollTo(this.bottom(), time, easing);
			},

			bottom: function() {
				return $('body').height() - $window_.height();
			},

			percent: function() {
				return Math.min(1, this.now() / this.bottom());
			},

			stop: function(flag1, flag2) {
				isAnimating_ = false;
				$target_.stop(flag1, flag2);
			},

			addObserver: function(context, callback) {
				NotificationCenter_.add(this.SCROLL, context, callback);
			},

			removeObserver: function(context, callback) {
				NotificationCenter_.remove(this.SCROLL, context, callback);
			},

			post: function() {
				NotificationCenter_.post(this.SCROLL, postParameters_());
			},

			enabled: function(val) {
				enabled_ = val;
			},

			target: function() {
				return $target_;
			},

			toString: function() {
				var s = 'Allblacks.WindowScroller (';
				s += 'inited=' + inited_ + ', ';
				s += 'to=' + to_ + ', ';
				s += 'now=' + now_ + ', ';
				s += 'prev=' + prev_ + ', ';
				s += 'distance=' + distance_ + ', ';
				s += 'isAnimating=' + isAnimating_ + ', ';
				s += 'isUp=' + isUp_ + ', ';
				s += 'isDown=' + isDown_ + ', ';
				s += 'isChanged=' + isChanged_;
				s += ')';

				return s;
			}
		};

		return obj;

	}).call(root_);

	/**
	 * Image Loader Class.
	 */
	var ImageLoader_ = AB_.ImageLoader = (function() {

		/**
		 * Define ImageLoader Class.
		 */
		var ImageLoader = function(info, context, onComplete, onProgress) {
			this.info_ = info;
			this.context_ = context;
			this.onComplete_ = onComplete;
			this.onProgress_ = onProgress;
			this.index_ = 0;
			this.queue_ = [];

			this.completed_ = false;
			this.loading_ = false;
			this.closed_ = false;
			this.extra = {};
		};

		//Notify Event names.
		ImageLoader.START = 'Allblacks.ImageLoader.START';
		ImageLoader.PROGRESS = 'Allblacks.ImageLoader.PROGRESS';
		ImageLoader.COMPLETE = 'Allblacks.ImageLoader.COMPLETE';
		ImageLoader.CANCEL = 'Allblacks.ImageLoader.CANCEL';
		ImageLoader.RESET = 'Allblacks.ImageLoader.RESET';

		ImageLoader.prototype = {
			/**
			 * @public methods.
			 */
			getInfo: function(key) {
				if (!key) {
					return this._info;
				}

				if (this.info_) {
					return this.info_[key];
				}
				return null;
			},

			isCompleted: function() {
				return this.completed_;
			},

			isLoading: function() {
				return this.loading_;
			},

			isClosed: function() {
				return this.closed_;
			},

			index: function() {
				return this.index_;
			},

			getImageDataByIndex:function(index) {
				return this.queue_[index];
			},

			getImageDataByInfo: function(info) {
				for (var i in this.queue_) {
					if (this.queue_[i].info == info) {
						return this.queue_[i];
					}
				}
			},

			add: function(info, src, className, before, after) {
				var data = {
										'info': info,
										'img': new Image(),
										'className': className ? className : 'loaded',
										'src': src,
										'index': this.queue_.length,
										'before': before,
										'after': after
									 };

				this.queue_.push(data);
			},

			reset: function() {
				if (this.closed_) {
					D_.error('already closed');
					return;
				}

				this.index_ = 0;
				this.loading_ = false;
				this.completed_ = false;
				this.closed_ = false;
				this.queue_ = [];
				NotificationCenter_.post(ImageLoader.RESET, [this]);
			},

			cancel: function() {
				if (this.loading_ === false) {
					return;
				}
				if (this.closed_ === true) {
					return;
				}

				this.index_ = 0;
				this.loading_ = false;
				this.completed_ = false;
				this.closed_ = true;
				this.queue_ = [];
				this.onComplete_ = null;
				this.onProgress_ = null;
				NotificationCenter_.post(ImageLoader.CANCEL, [this]);
			},

			close: function() {
				this.cancel();
			},

			destroy: function() {
				this.cancel();
			},

			hasNext: function() {
				return this.index_ + 1 < this.queue_.length;
			},

			execute: function() {
				if (this.closed_) {
					D_.error('already closed.');
					return;
				}

				if (this.completed_) {
					D_.error('already completed.');
					return;
				}

				if (this.loading_) {
					D_.error('already loading.');
					return;
				}

				if (this.total() <= 0) {
					D_.error('empty.');
					return;
				}

				this.loading_ = true;
				NotificationCenter_.post(ImageLoader.START, [this]);
				this.load_();
			},

			total: function() {
				return this.queue_.length;
			},

			toString: function() {
				var s = 'Allblacks.ImageLoader (';
						s += 'isLoading=' + this.isLoading() + ', ';
						s += 'isCompleted=' + this.isCompleted() + ', ';
						s += 'isClosed=' + this.isClosed() + ', ';
						s += 'index=' + this.index() + ', ';
						s += 'total=' + this.total() + ')';

				return s;
			},

			/**
			 * @private method.
			 */
			load_: function() {
				var scope = this;
				var data = this.queue_[this.index_];
				if (data.before) {
					data.before(data, this);
				}

				var percent = (this.index_ + 1) / this.total();

				data.img.onload = function() {
					if(!scope.isLoading()) {
						return;
					}
					//Set attribute width, height, alt=src
					ImageUtil_.attrs(data.img, {width: data.img.width, height: data.img.height, alt: data.src, "class": data.className});

					if (data.after) {
						data.after(data, this);
					}
					if (scope.onProgress_) {
						scope.onProgress_.apply(scope.context_, [scope, data, percent]);
					}
					NotificationCenter_.post(ImageLoader.PROGRESS, [scope, data, percent]);

					scope.next_();
				};
				data.img.src = data.src;
			},

			/**
			 * @private method.
			 */
			next_: function() {

				if (!this.loading_) {
					return;
				}

				if (!this.hasNext()) {
					this.completed_ = true;
					this.loading_ = false;
					if (this.onComplete_) {
						this.onComplete_.apply(this.context_, [this, this.queue_]);
					}
					NotificationCenter_.post(ImageLoader.COMPLETE, [this, this.queue_]);
					return;
				}
				this.index_ ++;
				this.load_();
			}
		};

		return ImageLoader;

	}).call(this);

	/**
	 * Create Modal Window.
	 *
	 * Not support IE6.
	 */
	var ModalWindow_ = AB_.ModalWindow = (function() {
		//private vars.
		var $wrapper_ = null;
		var $overlayLayer_ = null;
		var $detail_ = null;
		var $closeBtn_ = null;
		var detailWidth_ = 0;
		var detailHeight_ = 0;
		var closeCallback_ = null;
		var name_ = null;

		var resizeParams_ = {'top': 0, 'left': 0};

		//private methods.
		var resize_ = function() {
			var left = (WindowResizer_.width() - detailWidth_) >> 1;
			var top = (WindowResizer_.height() - detailHeight_) >> 1;
			resizeParams_.top = top;
			resizeParams_.left = left;
			$detail_.css(resizeParams_);
		};

		var makeOverlayStyle_ = function(overlayColor, overlayOpacity) {
			var opacity = Math.round(overlayOpacity * 100);
			var overlayStyle = 'style="';
			if (overlayColor !== false) {
				overlayStyle += 'background: ' + overlayColor + '; ';
				if (AB_.Env.ieVersionsBelow(8)) {
					overlayStyle += 'filter: alpha(opacity=' + opacity + ');';
				} else if(AB_.Env.isIE8()) {
					overlayStyle += "-ms-filter: 'alpha(opacity=" + opacity + ")';";
				} else {
					overlayStyle += 'opacity: ' + overlayOpacity + '; ';
				}
			}

			overlayStyle += 'position: fixed; top: 0; left: 0; z-index: 2147483646; ';
			overlayStyle += 'width: 100%; height: 100%;';
			overlayStyle += '"';

			return overlayStyle;
		}

		var makeHtml_ = function(id, overlayStyle, detailHtml) {
			var style = 'style="width: 100%; height: 100%; z-index: 2147483646; display: none;';
			style += 'position: absolute; top: 0; left: 0;';
			style += '"';

			var html = '';
			html += '<div id="' + id + '" class="modal" ' + style + '>';
			html += '\n<div class="modal-overlay-layler" ' + overlayStyle +'>';
			html += '\n</div>';
			html += '\n<div class="modal-detail" style="z-index: 2147483647; position:fixed; width: ' + detailWidth_ +'px; height: ' + detailHeight_ + 'px;">';
			html += '\n' + (detailHtml || '');
			html += '\n</div>';
			html += '\n</div>';

			return html;
		}

		var modal = {
			WILL_APPEAR: 'Allblacks.ModalWindow.WILL_APPEAR',
			WILL_DISAPPEAR: 'Allblacks.ModalWindow.WILL_DISAPPEAR',
			DID_APPEAR: 'Allblacks.ModalWindow.DID_APPEAR',
			DID_DISAPPEAR: 'Allblacks.ModalWindow.DID_DISAPPEAR',

			/**
			 * Return Modal Window Name.
			 */
			getName: function() {
				return name_;
			},

			getWrapper: function() {
				return $wrapper_;
			},

			getOverlayLayer: function() {
				return $overlayLayer_;
			},

			getDetail: function() {
				return $detail_;
			},

			getCloseButton: function(){
				return $closeBtn_;
			},

			/**
			 * Show Modail Window.
			 */
			show: function(id, name, overlayColor, overlayOpacity, detailHtml, detailWidth, detailHeight, closeBtnClassName, closeCallback) {
				var scope = this;
				if ($wrapper_) {
					D_.warn('Already Modal Window exists.');
					return;
				}
				name_ = name;
				detailWidth_ = detailWidth;
				detailHeight_ = detailHeight;

				//append Html Element to Body.
				var overlayStyle = makeOverlayStyle_(overlayColor, overlayOpacity);
				var html = makeHtml_(id, overlayStyle, detailHtml);
				$('body').append(html);

				$wrapper_ = $('#' + id);
				$overlayLayer_ = $wrapper_.find('.modal-overlay-layler');
				$detail_ = $wrapper_.find('.modal-detail');
				$closeBtn_ = $wrapper_.find(closeBtnClassName);
				$closeBtn_.css('cursor', 'pointer');
				closeCallback_ = closeCallback;

				$closeBtn_.click(function() {
					scope.hide();
				});

				$overlayLayer_.click(function() {
					scope.hide();
				});

				NotificationCenter_.post(this.WILL_APPEAR, [this, name_]);
				WindowResizer_.addObserver(this, resize_);
				resize_();
				$wrapper_.css('display', 'block');
				NotificationCenter_.post(this.DID_APPEAR, [this, name_]);
				return this;
			},

			/**
			 * Hide Modal Window.
			 */
			hide: function(preventCallback) {
				if ($wrapper_ == null) {
					return;
				}

				NotificationCenter_.post(this.WILL_DISAPPEAR, [this, name_]);

				if (preventCallback !== true && closeCallback_) {
					var result = closeCallback_.apply(null, [this, name_]);
					if (result === false) {
						return;
					}
				}

				WindowResizer_.removeObserver(this, resize_);
				$closeBtn_.unbind('click');
				$overlayLayer_.unbind('click');
				$wrapper_.remove();
				$overlayLayer_ = null;
				$wrapper_ = null;
				$closeBtn_ = null;
				$detail_ = null;
				detailWidth_ = 0;
				detailHeight_ = 0;
				closeCallback_ = null;

				NotificationCenter_.post(this.DID_DISAPPEAR, [this, name_]);
				name_ = null;
			},

			toString: function() {
				var s = 'Allblacks.ModalWindow (';
				s += 'name=' + name_ + ', ';
				s += 'detailWidth=' + detailWidth_ + ', ';
				s += 'detailHeight=' + detailHeight_ + ', ';
				s += 'closeCallback=' + closeCallback_;
				s += ')';

				return s;
			}
		};

		return modal;
	}).call(root_);

	/**
	* Infomation of Browser, OS and etc.
	*/
	var Environment_ = AB_.Environment = AB_.Env = (function() {
		//private vars
		var userAgent_ = window.navigator.userAgent.toLowerCase(),
				opera_ = userAgent_.indexOf('opera') >= 0,
				chrome_ = userAgent_.indexOf('chrome') >= 0,
				safari_ = userAgent_.indexOf('safari') >= 0,
				gecko_ = userAgent_.indexOf('gecko') >= 0;

		//ie
		var v = 3,
				div = document.createElement('div');
		while (div.innerHTML = '<!--[if gt IE '+(++v)+']><i></i><![endif]-->',
			div.getElementsByTagName('i')[0]
		);

		var ieInfo_ = v > 4 ? v : false,
				ie_ = ieInfo_ != false,
				ie10_ = ieInfo_ === 10,
				ie9_ = ieInfo_ === 9,
				ie8_ = ieInfo_ === 8,
				ie7_ = ieInfo_ === 7,
				ie6_ = ieInfo_ === 6;

		var windows_ = userAgent_.indexOf('windows') >= 0,
				mac_ = userAgent_.indexOf('macintosh') >= 0,
				iphone_ = userAgent_.indexOf('iphone') >= 0,
				ipod_ = userAgent_.indexOf('ipod') >= 0,
				ipad_ = userAgent_.indexOf('ipad') >= 0,
				android_ = userAgent_.indexOf('android') >= 0,
				smartphone_ = iphone_ || android_;

		var tablet_ = ipad_ || (android_ && userAgent_.indexOf ('Mobile') < 0);

		var obj = {
			ieVersionsBelow: function(ver) {
				return ieInfo_ && ieInfo_ < ver;
			},

			isOpera: function() {
				return opera_ === true;
			},

			isChrome: function() {

				return chrome_ === true;
			},

			isSafari: function() {
				return safari_ === true;
			},

			isGecko: function() {
				return gecko_ === true;
			},

			isIE: function() {
				return ie_;
			},

			isIE10: function() {
				return ie10_;
			},

			isIE9: function() {
				return ie9_;
			},

			isIE8: function() {
				return ie8_;
			},

			isIE7: function() {
				return ie7_;
			},

			isIE6: function() {
				return ie6_;
			},

			isWindows: function() {
				return windows_;
			},

			isMac: function() {
				return mac_;
			},

			isiPhone: function() {
				return iphone_;
			},

			isiPod: function() {
				return ipod_;
			},

			isiPad: function() {
				return ipad_;
			},

			isTablet: function() {
				return tablet_;
			},

			isAndroid: function() {
				return android_;
			},

			isSmartphone: function() {
				return smartphone_;
			},

			isSupportedCanvas: function(canvas) {
				return canvas && canvas.getContext && canvas.getContext('2d');
			},

			toString: function() {
				var s = 'Allblacks.Environment (';
				s += 'userAgent=' + userAgent_ + ', ';
				s += 'ie=' + ie_ + ', ';
				s += 'ie10=' + ie10_ + ', ';
				s += 'ie9=' + ie9_ + ', ';
				s += 'ie8=' + ie8_ + ', ';
				s += 'ie7=' + ie7_ + ', ';
				s += 'ie6=' + ie6_ + ', ';
				s += 'isChrome=' + chrome_ + ', ';
				s += 'isOpera=' + opera_ + ', ';
				s += 'isSafari=' + safari_ + ', ';
				s += 'isGecko=' + gecko_ + ', ';
				s += 'windows=' + windows_ + ', ';
				s += 'mac=' + mac_ + ', ';
				s += 'iphone=' + iphone_ + ', ';
				s += 'ipad=' + ipad_ + ', ';
				s += 'ipod=' + ipod_ + ', ';
				s += 'android=' + android_ + ', ';
				s += 'smartphone=' + smartphone_;
				s += ')';

				return s;
			}
		};

		return obj;

	}.call(root_));

	/**
	 * Audio Utility
	 */
	var Audio = Allblacks.Audio = (function() {
		var audios = {};
		var isSupported = !Allblacks.Env.ieVersionsBelow(9);
		var $audio = null;
		var _volume = 1;
		var makeHTML = function(fileName, className, option) {
			var html = '<audio class="' + (className ? className : 'target') + '" ' + option + '>';
			html += '\
<source src="' + fileName + '.mp3" type="audio/mp3">\
<source src="' + fileName + '.m4a" type="audio/m4a">\
<source src="' + fileName + '.ogg" type="audio/ogg">\
</audio>';
			return html;
		};
		var get = function(key) {
			return audios[key];	
		}
		var play = function(key) {
			if (!isSupported) {
				return;	
			}
			var audio = get(key); 
			if (!audio) {
				return;
			}
			audio.play();
			// audios[key].volume = _volume;
			// audios[key].muted = (_volume == 0);
		};
		var volume = function(value, key) {
			_volume = value;
			if (!isSupported) {
				return;	
			}
			if (!key) {
				for(var i in audios) {
					var audio = get(i); 
					if (!audio) {
						continue;
					}
					audio.volume = value; 
				}		
			} else {
				var audio = get(key); 
				if (!audio) {
					return;
				}
				audio.volume = value;
			}
		};
		var stop = function(key) {
			if (!isSupported) {
				return;	
			}
			var audio = get(key); 
			if (!audio) {
				return;
			}
			audio.pause();
			try {
				audio.currentTime = 0;
			} catch(e) {
				
			}
		}
		var add = function(key, filename, option) {
			if (!isSupported) {
				return;	
			}
			if (get(key)) {
				consolg.error(key + ' already exists.');
				return;
			}
			var html = makeHTML(filename, key, option);	
			if ($audio === null) {
				$('body').append('<div id="audio-manager"></div>');
				$audio = $('#audio-manager')
			}
			$audio.append(html);
			audios[key] = $audio.find('.' + key).get(0);		
		}
	
		obj = {};
		obj.isSupported = isSupported; 
		obj.make = makeHTML;
		obj.play = play;
		obj.stop = stop;
		obj.add = add;
		obj.get = get;
		obj.volume = volume;
		return obj;
	}) ();

	/**
	 * Vidoe Utility
	 */
	var Video = Allblacks.Video = (function() {
		var makeHTML = function(path, className, option) {
			var html = '<video class="' + (className ? className : 'target') + '" ' + option + '>';
			html += '\
<source src="' + path + '.mp4" type="video/mp4">\
<source src="' + path + '.ogv" type="video/ogg">\
<source src="' + path + '.webm" type="video/webm">\
</video>';
// <source src="' + path + '.mov" type="video/quicktime">\
			return html;
		};
	
		obj = {};
		obj.make = makeHTML;
		return obj;
	}) ();

	/**
	* Image Button Utility.
	*
	* Mouseenter, mouseleave, activate set up.
	*/
	var ImageButton_ = Allblacks.ImageButton = (function() {
		//private vars.
		var IS_ACTIVE_KEY = '_ab_is_active';
		var OFF_SRC_KEY = '_ab_off_src';
		var ON_SRC_KEY = '_ab_on_src';
		var ACTIVE_SRC_KEY = '_ab_active_src';
		var ANCHOR_IMGS_KEY = '_ab_anchor_imgs_class_name';

		//private functions.
		var interactImg_ = function($img) {
			preload_($img);

			$img.on({
				mouseenter: function() {
					if (ImageButton_.isActive($(this))) {
						return;
					}
					$(this).attr('src', $(this).data(ON_SRC_KEY));
				},
				mouseleave: function() {
					if (ImageButton_.isActive($(this))) {
						return;
					}
					$(this).attr('src', $(this).data(OFF_SRC_KEY));
				}
			});
		};

		var preload_ = function($img) {
			new Image().src = $img.data(ON_SRC_KEY);
			//D_.log('preload : ' + $img.data(ON_SRC_KEY));
			if ($img.data(ON_SRC_KEY) != $img.data(ACTIVE_SRC_KEY)) {
				new Image().src = $img.data(ACTIVE_SRC_KEY);
				//D_.log('preload : ' + $img.data(ACTIVE_SRC_KEY));
			}
		};

		var sources_ = function($img, offSuffix, onSuffix, activeSuffix) {
			offSuffix = offSuffix ? offSuffix : '';
			onSuffix = onSuffix ? onSuffix : '_on';
			activeSuffix = activeSuffix ? activeSuffix : onSuffix;

			var off = $img.attr('src');
			if (!off) {
				return false;
			}

			var on = off;
			var active = off;

			if(offSuffix) {
				if(!off.match(offSuffix)) {
					D_.error('Not found offSuffix. : ' + offSuffix);
					return false;
				}

				on = off.replace(offSuffix, onSuffix);
				active = off.replace(offSuffix, activeSuffix);

			} else {
				var dot = off.lastIndexOf('.');
				var ext = off.substr(dot);
				on = off.substr(0, dot) + onSuffix + ext;
				active = off.substr(0, dot) + activeSuffix + ext;
			}

			$img.data(OFF_SRC_KEY, off);
			$img.data(ON_SRC_KEY, on);
			$img.data(ACTIVE_SRC_KEY, active);

			return true;
		};

		var ImageButton = {
			interactImgs: function($imgs, offSuffix, onSuffix, activeSuffix) {
				$imgs.each(function() {
					var valid = sources_($(this), offSuffix, onSuffix, activeSuffix);
					if (valid) {
						interactImg_($(this));
					}
				});
			},

			/**
			 *
			 */
			sources: function($img) {
				return {'on': $img.data(ON_SRC_KEY), 'off': $img.data(OFF_SRC_KEY), 'active': $img.data(ACTIVE_SRC_KEY)};
			},

			/**
			 *
			 */
			activateImg: function($img) {
				this.activate($img, true);
				$img.attr('src', $img.data(ACTIVE_SRC_KEY));
			},

			/**
			 *
			 */
			deactivateImg: function($img) {
				this.activate($img, false);
				$img.attr('src', $img.data(OFF_SRC_KEY));
			},

			/**
			 *
			 */
			isActive: function($target) {
				return $target.data(IS_ACTIVE_KEY);
			},

			/**
			 *
			 */
			interactAnchors: function($anchors, interactClassName, offSuffix, onSuffix, activeSuffix) {
				$anchors.each(function() {
					$(this).data(ANCHOR_IMGS_KEY, $(this).find(interactClassName));
					$(this).data(ANCHOR_IMGS_KEY).each(function(){
						var valid = sources_($(this), offSuffix, onSuffix, activeSuffix);
						if (!valid) {
							return;
						}
						preload_($(this));
					});
					$(this).on({
						mouseenter: function() {
							if (ImageButton_.isActive($(this))) {
								return;
							}
							//$(this).attr('src', $(this).data(ON_SRC_KEY));
							$(this).data(ANCHOR_IMGS_KEY).each(function() {
								$(this).attr('src', $(this).data(ON_SRC_KEY));
							});
						},
						mouseleave: function() {
							if (ImageButton_.isActive($(this))) {
								return;
							}
							$(this).data(ANCHOR_IMGS_KEY).each(function() {
								$(this).attr('src', $(this).data(OFF_SRC_KEY));
							});
						}
					});
				});
			},

			/**
			 *
			 */
			activateAnchor: function($anchor) {
				this.activate($anchor, true);
				$anchor.data(ANCHOR_IMGS_KEY).each(function() {
					$(this).attr('src', $(this).data(ACTIVE_SRC_KEY));
				});
			},

			/**
			 *
			 */
			deactivateAnchor: function($anchor) {
				this.activate($anchor, false);
				$anchor.data(ANCHOR_IMGS_KEY).each(function() {
					$(this).attr('src', $(this).data(OFF_SRC_KEY));
				});
			},

			/**
			 *
			 */
			activate: function($target, bool) {
				$target.data(IS_ACTIVE_KEY, bool);
			}
		};

		return ImageButton;
	})();

	/**
	 * Image Utility.
	 */
	var ImageUtil_ = AB_.ImageUtil = {
		/**
		 * If you use .png For IE7, IE8,
		 * you call this method.
		 * css opacity bug fix!
		 *
		 * If you change opacity of img,
		 * you should change parent element's opacity of img.
		 */
		convertPNG: function($imgs) {
			if(AB_.Env.isIE8() || AB_.Env.isIE7()) {
				$imgs.each(function() {
					if(!$(this) || !$(this).attr) {
						return false;
					}
					var src = $(this).attr('src');
					if(src && src.indexOf('.png') >= 0) {
						$(this).css('filter', 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' + src + '", sizingMethod="scale");');
					}
				 });
			 }
		},

		/**
		 * Set attributes to img elements.
		 */
		attrs: function(img, params) {
			for(var i in params) {
				img.setAttribute(i, params[i]);
			}
		}
	};

	/**
	 * Geometory namespace.
	 */
	var Geom_ = AB_.Geom = {};

	/**
	 * Define Point class.
	 */
	var Point_ = Geom_.Point = function(x, y) {
		this.x = x;
		this.y = y;
	};

	/**
	 * Define staic methods.
	 */
	Point_.distance = function(p1, p2) {
		var dx = (p1.x - p2.x);
		var dy = (p1.y - p2.y);
		return Math.sqrt( dx * dx + dy * dy );
	};

	Point_.interpolate = function(p1, p2, f) {
		var x = (p1.x - p2.x) * f + p2.x;
		var y = (p1.y - p2.y) * f + p2.y;
		return new Point_(x, y);
	}

	/**
	 * Define instance methods.
	 */
	Point_.prototype = {
		length: function() {
			return Math.sqrt(this.x * this.x + this.y * this.y);
		},
		clone: function() {
			return new Point_(this.x, this.y);
		},
		add: function(p) {
			return new Point(this.x + p.x, this.y + p.y);
		},
		copy: function(p) {
			this.x = p.x;
			this.y = p.y;
		},
		equals: function(p) {
			return this.x === p.x && this.y == p.y;
		},
		nomalize: function() {
			var len = this.length();
			this.x = this.x / len;
			this.y = this.y / len;
		},
		offset: function(dx, dy) {
			this.x += dx;
			this.y += dy;
		},
		setTo: function(x, y) {
			this.x = x;
			this.y = y;
		},
		sub: function(p) {
			return new Point_(this.x - p.x, this.y - p.y);
		},
		toString: function() {
			var s = 'Allblacks.Geom.Point (';
					s += 'x=' + this.x + ', ';
					s += 'y=' + this.y + ', ';
					s += 'length=' + this.length() + ')';
			return s;
		}
	};

	/**
	 * Define Rect(angle) class.
	 */
	var Rect_ = Geom_.Rect = Geom_.Rectangle = function(x, y, w, h) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
	};

	/**
	 * Define instance methods.
	 */
	Rect_.prototype = {
		bottom: function() {
			return this.y + this.height;
		},
		left: function() {
			return this.x;
		},
		right: function() {
			return this.x + this.width;
		},
		size: function() {
			return new Point_(this.width, this.height);
		},
		top: function() {
			return this.y;
		},
		topLeft: function() {
			return new Point(this.x, this.y);
		},
		clone: function() {
			return new Rect_(this.x, this.y, this.width, this.height);
		},
		contains: function(x, y) {
			var l, r, t, b;
			if (this.x < this.right()) {
				l = this.x;
				r = this.right();
			} else {
				l = this.right();
				r = this.x;
			}

			if (this.y < this.bottom()) {
				t = this.y;
				b = this.bottom();
			} else {
				b = this.y;
				t = this.bottom();
			}

			return (x >= l) && (x <= r)
					&& (y >= t) && (y <= b);
		},
		containsPoint: function(p) {
			return this.contains(p.x, p.y);
		},
		containsRect: function(rect) {
			return this.contains(rect.x, rect.y)
					&& this.contains(rect.x, rect.bottom())
					&& this.contains(rect.right(), rect.y)
					&& this.contains(rect.right(), rect.bottom());
		},
		equals: function(rect) {
			return this.x === rect.x
				&& this.y === rect.y
				&& this.width === rect.width
				&& this.height === rect.height;
		},
		inflate: function(dx, dy) {
			this.width += dx * 2;
			this.x -= dx;
			this.height += dy * 2;
			this.y -= dy;
		},
		inflatePoint: function(p) {
			this.inflate(p.x, p.y);
		},
		intersects: function(rect) {
			var r = this.contains(rect.x, rect.y)
					|| this.contains(rect.x, rect.bottom())
					|| this.contains(rect.right(), rect.y)
					|| this.contains(rect.right(), rect.bottom());
			if (r) {
				return r;
			}
			return rect.contains(this.x, this.y)
					|| rect.contains(this.x, this.bottom())
					|| rect.contains(this.right(), this.y)
					|| rect.contains(this.right(), this.bottom());
		},
		isEmpty: function() {
			return this.width === 0 && this.height === 0;
		},
		offset: function(dx, dy) {
			this.x += dx;
			this.y += dy;
		},
		offsetPoint: function(p) {
			this.x += p.x;
			this.y += p.y;
		},
		setEmpty: function() {
			this.width = 0;
			this.height = 0;
		},
		union: function(rect) {
			var l_1 = Math.min(this.left(), this.right());
			var l_2 = Math.min(rect.left(), rect.right());
			var l = Math.min(l_1, l_2);

			var r_1 = Math.max(this.left(), this.right());
			var r_2 = Math.max(rect.left(), rect.right());
			var r = Math.max(r_1, r_2);

			var t_1 = Math.min(this.top(), this.bottom());
			var t_2 = Math.min(rect.top(), rect.bottom());
			var t = Math.min(t_1, t_2);

			var b_1 = Math.max(this.top(), this.bottom());
			var b_2 = Math.max(rect.top(), rect.bottom());
			var b = Math.max(b_1, b_2);
			return new Rect_(l, t, (r - l), (b - t));
		},
		toString: function() {
			var s = 'Allblacks.Geom.Rect (';
					s += 'x=' + this.x + ', ';
					s += 'y=' + this.y + ', ';
					s += 'width=' + this.width + ', ';
					s += 'height=' + this.height + ')';
			return s;
		}
	};

}).call(this);

if(!Array.indexOf) {
  Array.prototype.indexOf = function(o) {
    for(var i in this) {
      if(this[i] == o) {
        return i;
      }
    }
    return -1;
  }
}
