From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Time for "mkdir" on ext3.
Date: Thu, 10 Mar 2011 08:11:19 +0100
Message-ID: <20110310071119.GF31710@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:43709 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750893Ab1CJHLW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2011 02:11:22 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I have an ext3 filesystem. When I "cp -lr" a big tree there, it turns
out that the "mkdir" calls take the bulk of the time. IIRC there are
325000 directories (and 4 million files). Each mkdir call takes about
50ms (*), so that accounts for about 4.5 hours of the running time.

Would ext4 perform significantly better?

	Roger.

(*) I forgot about this Email while it was still in my editor. Now a
day layter the mkdir calls all take around 17ms, and things run about
3x faster. On the other hand it's been running for over 5 hours. And
yesterday I've seen a streak of >100ms mkdir calls... So apparently
it depends on "something".... 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
