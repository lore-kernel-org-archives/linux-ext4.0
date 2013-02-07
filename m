From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Thu, 07 Feb 2013 09:50:07 -0600
Message-ID: <5113CD2F.9010908@redhat.com>
References: <51137F76.8070705@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab3BGPuf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 10:50:35 -0500
In-Reply-To: <51137F76.8070705@ts.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/7/13 4:18 AM, Martin Wilck wrote:
> Hello,
> 
> you may have seen the following warning that is displayed when
> someone tries to install GRUB2 on in a extX partition:
> 
>   "/sbin/grub-setup: warn: Embedding is not possible. GRUB can only be
>   installed in this setup by using blocklists. However, blocklists are
>   UNRELIABLE and their use is discouraged."

To be clear, this is only the case when installing the bootloader itself to
a partition containing a filesystem, not when installing to the MBR, correct?

Which is different than saying "/boot is on ext4" - it's putting the bootloader
itself on a partition containing a filesystem, something which is a bit more
unusual, I think.

-Eric

> Recently I have been involved in discussions about this on
> https://bugzilla.redhat.com/show_bug.cgi?id=872826.
> 
> The Grub manual says "installing to a filesystem means that GRUB is
> vulnerable to its blocks being moved around by filesystem features such
> as tail packing, or even by aggressive fsck implementations".
> 
> My question to the extX experts: Under what circumstances (except
> modifying, overwriting, deleting the bootloader image "core.img" itself)
> can a block list referencing "core.img" be corrupted? In particular:
> 
>  1) could it happen during ordinary operation, filesystem code silently
>    moving blocks around?
>  2) could it happen in an e2fsck run?
>  3) could it be caused by e4defrag?
>  4) could it happen with resize2fs even if the blocks occupied by the
> file fit in the size that the FS is resized to (otherwise obviously "yes")?
>  5) Anything else?
>  6) if the file was protected with the IMMUTABLE flag, would any of 1-5
> still be able to corrupt the file?
> 
> Regards
> Martin
> 

