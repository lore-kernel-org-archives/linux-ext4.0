From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: e2fsprogs/ext4 version compatibility
Date: Thu, 24 Feb 2011 10:39:46 +0100
Message-ID: <20110224093946.GA11399@bitwizard.nl>
References: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Hari Subramanian <hari@vmware.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:54474 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756059Ab1BXJjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 04:39:48 -0500
Content-Disposition: inline
In-Reply-To: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 01:09:20PM -0800, Hari Subramanian wrote:

> The reason I'm asking the question is my machine recently rebooted
> after a crash but fsck failed with an error code of 4 and the
> following message:
 
> "Inodes that were part of a corrupted orphan linked list found"
> "UNEXPECTED INCONSISTENCY: RUN fsck MANUALLY"

These sorts of filesystem errors occasionally occur. :-( 

Do you have ECC RAM? A cosmic particle may have flipped a bit in your
RAM. There is not much you can do about it, except buy ECC RAM next
time. Much more likely, but less likely to be believed by users is:
your system simply flipped a bit. Somewhere in your system there is a
path that once in a million times is not fast enough to catch the
proper data, and will latch the wrong data. Result? A flipped bit.

Anyway, these errors accumulate. That's why running e2fsck is still
good to be doing every once in a while even on a logging filesystem
like ext3 or ext4 that should be resistant to suddenly turning off
the power (or crashing).

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
