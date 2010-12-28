From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Uneven load on my raid disks.
Date: Tue, 28 Dec 2010 10:18:25 +0100
Message-ID: <20101228091825.GC1351@bitwizard.nl>
References: <20101228090749.GB1351@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:57361 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751588Ab0L1JS0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 04:18:26 -0500
Content-Disposition: inline
In-Reply-To: <20101228090749.GB1351@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 10:07:49AM +0100, Rogier Wolff wrote:
> dumpe2fs without -h takes a long time. I just stopped all rm processes
> and now only dumpe2fs is running. It seems to be causing about 10times
> more load on sdb than on the other drives. strace shows that it is in
> a loop where it seeks/reads. It is alternating reads of 4k and 280
> bytes.

OK. I did this wrong: there were also other things running. Whatever
dumpe2fs is doing distributes nicely over the four disks.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
