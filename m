From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck.ext4 taking months
Date: Wed, 30 Mar 2011 10:34:03 +0200
Message-ID: <20110330083402.GC30384@bitwizard.nl>
References: <4D8F1F75.8010201@psi5.com> <20110328154730.GD21075@thunk.org> <4D9256E2.4040603@psi5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Christian Brandt <brandtc@psi5.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:34674 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754574Ab1C3IeI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2011 04:34:08 -0400
Content-Disposition: inline
In-Reply-To: <4D9256E2.4040603@psi5.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 30, 2011 at 12:02:10AM +0200, Christian Brandt wrote:
>  Can stopping fsck.ext4 now damage things even more?

In contrast to fsck.reiser: not likely.

I dropped reiser when it did this to me and it cost me 6 hours of my
night sleep.

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
