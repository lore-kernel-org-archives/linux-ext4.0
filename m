From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 11:39:29 +0100
Message-ID: <20110225103929.GD15464@bitwizard.nl>
References: <E1PsnrK-0005r5-JH@tytso-glaptop> <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca> <20110225091559.GC15464@bitwizard.nl> <BBAF46A2-4F43-47E5-B98C-A33837EEF67E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:40045 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932324Ab1BYKjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 05:39:31 -0500
Content-Disposition: inline
In-Reply-To: <BBAF46A2-4F43-47E5-B98C-A33837EEF67E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, Feb 25, 2011 at 03:01:08AM -0700, Andreas Dilger wrote:

.... I was babbling.... 

> That is the time to load bitmaps in a non-flex_bg filesystem, which is
> the default for ext3-formatted filesystems.

OK! Already done!

Then I don't really understand what the problem is, so better ignore
me. :-)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
