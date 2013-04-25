//
//  GeneralDef.h
//  Centny
//
//  Created by Centny on 9/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#ifndef Centny_GeneralDef_h
#define Centny_GeneralDef_h
	//
#define FRAM_X(X)						(X.frame.origin.width)
#define FRAM_Y(X)						(X.frame.origin.height)
#define FRAM_W(X)						(X.frame.size.width)
#define FRAM_H(X)						(X.frame.size.height)
#define RECT_YH(X)						(X.origin.y + X.size.height)				// the rectangle y+height.
#define RECT_XW(X)						(X.origin.x + X.size.width)					// the rectangel x+width.
#define FRAM_YH(X)						(X.frame.origin.y + X.frame.size.height)	// the frame y+height.
#define FRAM_XW(X)						(X.frame.origin.x + X.frame.size.width)		// the frame x+width.
	// the center rectangle.
#define CENTER_RECT_H(view, y, w, h)	CGRectMake((FRAM_W(view) - (w)) / 2, y, w, h)
#define CENTER_RECT_V(x, view, w, h)	CGRectMake(x, (FRAM_H(view) - (h)) / 2, w, h)
#define CENTER_RECT(view, w, h)			CGRectMake((FRAM_W(view) - (w)) / 2, (FRAM_H(view) - (h)) / 2, w, h)
#define RECT_MAKE(x, y, size)			CGRectMake(x, y, size.width, size.height)
	//
#define SIZE_LOG(X)						NSDLog(@"Size(%f,%f)", X.width, X.height)
#define POINT_LOG(X)					NSDLog(@"Point(%f,%f)", X.x, X.y)
#define RECT_LOG(X)						NSDLog(@"Rect(%f,%f,%f,%f)", X.origin.x, X.origin.y, X.size.width, X.size.height)
#define FRAME_LOG(X)					NSDLog(@"Frame(%f,%f,%f,%f)", X.frame.origin.x, X.frame.origin.y, X.frame.size.width, X.frame.size.height)
	//
#define IF_REL(X)	 \
	if (X) {		 \
		[X release]; \
	}				 \
	X = nil
#define IF_REL_X(X, E)			 \
	if (X) {					 \
		[X release]; X = nil; E; \
	}

#define IF_REL_ELSE(X, IX, EX)	  \
	if (X) {					  \
		[X release]; X = nil; IX; \
	} else {EX; }

#define IF_E(X, IX)	\
	if (X) {		\
		IX;			\
	}

#define IF_RETURN(X) \
	if (X) {		 \
		return;		 \
	}

#define NORMAL_REL IF_REL
	//
	// create NSData by file.
#define FILE_DATA(name, type)				[NSData dataWithContentsOfFile :[[NSBundle mainBundle] pathForResource:name ofType:type]]
#define FILE_PATH(name, type)				[[NSBundle mainBundle] pathForResource : name ofType : type]
#define FILE_STRING(name, type)				[NSString stringWithContentsOfURL :[[NSBundle mainBundle] URLForResource:name withExtension:type] encoding : NSUTF8StringEncoding error : nil]
#define FILE_STRING_E(name, type, error)	[NSString stringWithContentsOfURL :[[NSBundle mainBundle] URLForResource:name withExtension:type] encoding : NSUTF8StringEncoding error : &error]
	// create NSURLRequest by NSString.
#define URL_REQUEST(x)						[NSURLRequest requestWithURL :[NSURL URLWithString:(x)]]
#define URL_MTREQUEST(x)					[NSMutableURLRequest requestWithURL :[NSURL URLWithString:x]]
	//
#define NetworkActivityIndicatorVisible(x)	[UIApplication sharedApplication].networkActivityIndicatorVisible = x
#endif	/* ifndef Centny_GeneralDef_h */
