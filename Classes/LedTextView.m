//
//  LedTextView.m
//  TaskTracker
//
//  Created by Michael Anteboth on 17.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LedTextView.h"


@implementation LedTextView

@synthesize text;
@synthesize textColor;
@synthesize fontSize;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		//make the background dissapear
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		
		// Get the path to our custom font and create a data provider.
		NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"DS-DIGI" ofType:@"TTF"]; 
		CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
		
		// Create the font with the data provider, then release the data provider.
		customFont = CGFontCreateWithDataProvider(fontDataProvider);
		CGDataProviderRelease(fontDataProvider); 
		
		// Create the matrix to flip any text drawn to a readable orientation.
		textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	// Get the context.
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Set the customFont to be the font used to draw.
	CGContextSetFont(context, customFont);
	
	// Set how the context draws the font, what color, how big.
	CGContextSetTextDrawingMode(context, kCGTextFill);	

	CGContextSetFillColorWithColor(context, self.textColor.CGColor); //set font color
	CGContextSetFontSize(context, fontSize); //set the font size

	//transform text to readable orientation
	CGContextSetTextMatrix(context, textTransform);
	
	// Create an array of Glyph's the size of text that will be drawn.
	CGGlyph textToPrint[[self.text length]];
	int textLength = [self.text length];
	
	// Loop through the entire length of the text.
	for (int i = 0; i < textLength; ++i) {
		// Store each letter in a Glyph and subtract the MagicNumber to get appropriate value.
		int c = [self.text characterAtIndex:i];		
		textToPrint[i] = c - 29;
		/*
		//Kleinbuchstaben -30 
		//Großbuchstaben und Zahlen -29 (ALSO ASCII kleine als 97)
		//wahrscheinlich fehlt das ß oder so
		int c = [self.text characterAtIndex:i];
		if (c < 97) textToPrint[i] = c - 29;
		else		textToPrint[i] = c - 30;		
		 */
	}
	

	int x = 0 ;
	int y = self.frame.origin.y;
	NSLog(@"x:%i y:%i", x, y);	
		
	//finally draw the text
	CGContextShowGlyphsAtPoint(context,x, y, textToPrint, textLength);

}


- (void)dealloc {
	[text release];
	[textColor release];	
    [super dealloc];
}


@end
