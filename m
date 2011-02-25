From: Hari Subramanian <hari@vmware.com>
Subject: RE: e2fsprogs/ext4 version compatibility
Date: Thu, 24 Feb 2011 16:17:22 -0800
Message-ID: <10FC03A59E498D4A90A45E4A105AD3ED02DCB03B90@EXCH-MBX-2.vmware.com>
References: <10FC03A59E498D4A90A45E4A105AD3ED02DCB0363A@EXCH-MBX-2.vmware.com>
 <20110224093946.GA11399@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:22253 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab1BYARX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 19:17:23 -0500
In-Reply-To: <20110224093946.GA11399@bitwizard.nl>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Rogier,

My setup certainly has ECC RAM although I'm running this on a VM. So, that adds another software layer that potentially has bugs. In any case, I'm totally OK with running fsck but would like not have to manually intervene to fix problems. Any suggestions in this specific case to work around the 'required manual intervention'?

Thanks
~ Hari

-----Original Message-----
From: Rogier Wolff [mailto:R.E.Wolff@BitWizard.nl] 
Sent: Thursday, February 24, 2011 4:40 AM
To: Hari Subramanian
Cc: linux-ext4@vger.kernel.org
Subject: Re: e2fsprogs/ext4 version compatibility

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
