From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: References to unmapped sectors
Date: Sat, 07 Feb 2009 14:41:44 +0100
Message-ID: <87mycyictj.fsf@frosties.localdomain>
References: <87f94c370902051458t714822cbj84011446c24ec3dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:45090 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZBGNlq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 08:41:46 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 4370FFA19599
	for <linux-ext4@vger.kernel.org>; Sat,  7 Feb 2009 14:41:45 +0100 (CET)
Received: from [78.43.226.218] (helo=frosties.localdomain)
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1LVnRJ-0003fy-00
	for linux-ext4@vger.kernel.org; Sat, 07 Feb 2009 14:41:45 +0100
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1LVnRI-0001Fb-OQ
	for linux-ext4@vger.kernel.org; Sat, 07 Feb 2009 14:41:44 +0100
In-Reply-To: <87f94c370902051458t714822cbj84011446c24ec3dc@mail.gmail.com>
	(Greg Freemyer's message of "Thu, 5 Feb 2009 17:58:03 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer <greg.freemyer@gmail.com> writes:

> I just have a very fundamental issue with a storage spec that allows
> random garbage to be returned in response to a read request with no
> signaling mechanism included to notify the kernel that it is reading
> trash.  Ric has told me that in the real world, storage vendors are
> likely to return a well defined pattern (nulls, etc.) in response to
> reads of these unmapped sectors.  If true, why not have the spec say
> so.

More flexibility for implementations. It means implementations do not
have to check for the validity of read requests. This can sometimes
speed up things, save (non volatile) memory, save disk syncs, save
global locks for mapping updates, ...

Imagine if the C standard would require that accessing a invalid
pointer would abort the program. Suddenly every pointer access would
have to be validated in case the pointer is invalid but accidentally
points to some (for the cpu) valid address.

> Or have some way to communicate to the kernel which sectors are
> reliable (mapped) vs. unreliable (unmapped).
>
> On the one hand the whole purpose of the SCSI DIF/DIX extension is to
> ensure that the data being read from a scsi device is the exact data
> that was written, but the thin-provisioning specs go in the opposite
> direction and allow complete garbage to be returned with no signaling
> mechanism to allow the kernel to even conceivably find out.
>
> Instead of focusing on the negative, I'll reword my issue to discuss
> how unmapped sector knowledge (if available) could be used to
> _improve_ the current functionality of a filesystem:
>
> ==> Positive spin on how knowledge of which sectors are unmapped could
> improve filesystem reliability

Isn't it more advantageous for wear leveling? The more unused blocks a
device has the better it can level wear and thereby extend the
lifetime of the device.

> The original email discussed pointers that in someway became corrupted
> to point at blocks which NEVER contained valid data.  Since the data
> is outside of the overall range of data blocks, it can be identified
> and both the kernel and userspace can be prevented from relying on
> what would obviously be trash.
>
> Whatever mechanism caused the bmap pointers to point outside the
> overall range of the filesystem, I assume could just as easily cause
> the those pointers to point at unmapped sectors.
>
> If the SCSI / ATA specs were enhanced to somehow notify the kernel
> when a read of these unmapped sectors occurred, then both the  kernel
> and userspace could be protected from relying on this potential trash
> as well.

At least there should be a scsi reply for this. The use of which could
still be optional. So either an error or any data could be
valid. Obviously requiring a proper error would be better for the
user.

> FYI: I've tried to find a way to send my comments to the T10
> committee, but I have not found a way to do that since the spec is not
> in a "public comment" period at present.
>
> Greg

MfG
        Goswin
