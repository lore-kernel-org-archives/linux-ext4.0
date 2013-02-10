From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Sat, 9 Feb 2013 17:17:58 -0700
Message-ID: <B6CCAB6A-D340-47F8-9231-1280151552DC@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:22004 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760903Ab3BJBt3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 20:49:29 -0500
Received: from c-24-9-205-42.hsd1.co.comcast.net ([24.9.205.42]:50658 helo=mingisapsycho.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1U4KcK-003Gii-6e
	for linux-ext4@vger.kernel.org; Sat, 09 Feb 2013 17:18:00 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2013-02-07 15:50:07 GMT Eric Sandeen wrote:

> To be clear, this is only the case when installing the bootloader its=
elf to a partition containing a filesystem, not when installing to the =
MBR, correct?

Correct.

> Which is different than saying "/boot is on ext4" - it's putting the =
bootloader itself on a partition containing a filesystem, something whi=
ch is a bit more unusual, I think.

Some users apparently want distribution specific boot loaders as second=
ary, chain loaded from a primary boot loader that goes in the MBR gap.



On 2013-02-07 20:53:35 GMT Theodore Ts'o wrote:

> This only happens if grub2 can't install itself in the space between =
the MBR and the beginning of the first partition.

The message also happens when the user explicitly requests grub-install=
 to "install to a partition" instead of to the MBR gap, on ext.

grub-install /dev/sda1

instead of

grub-install /dev/sda

There are different behaviors depending on file system: Not allowed at =
all on XFS (with or without --force); only possible with --force on ext=
; only possible without --force on btrfs.


> I think the grub2 developers are being far too paranoid.


Possibly. On the one hand syslinux/extlinus works in a similar way to G=
RUB's --force option creating a blocklist, although I'm not familiar en=
ough with extlinux to know if there's a significant difference.

On the other hand=85

> There are some folks who are proposing that we use a bootloader inode=
:
> for grub's benefit.=20

Who are requesting this? If not GRUB's devs, it would seem there are ot=
her developers who are also paranoid.

> But it's not something that has been terribly high priority, since it=
's basically more of a security blanket for the grub2 developers more t=
han anything else=85.

It may be a security blanket for grub2 developers. However, it appears =
to me users want a security blanket also.=20

Users can do what they want now, with existing tools. The bug report de=
tails the two simple commands to enable this, but some users find that =
inadequate. What they really want is a GUI switch in their OS installer=
 to do this for them, and would be managed by fulfilling RH BZ 886502 (=
related bug to the OP's cited bug).

Despite my bias against two bootloaders (I think it's ridiculous, but t=
hen I prefer 1/2 a boot loader), the question I have is if a blocklist =
is really needed to find and load the 2nd boot loader? Because needing =
a blocklist in the VBR implies the first boot loader doesn't understand=
 ext(4). If true, before engineering file system changes, users need to=
 upgrade their ancient primary boot loader.

GRUB legacy 5+ years ago (and extlinux) can "chain" load to GRUB 2 by d=
irectly reading ext, and locate /boot/grub2/i386-pc/core.img; even if i=
t is fragmented, even if aggressive fsck, or online defragmenting is pe=
rformed. The only thing the blocklist does is point to core.img, the th=
ing that's normally in the MBR gap (or BIOS Boot partition on GPT).

And GRUB2 as a primary bootloader goes a step easier which is it can fi=
nd, load, display and execute distribution specific grub configuration =
files, both current and legacy formats. It's not even necessary to chai=
n load from GRUB2 to GRUB1 or 2.

So I don't actually understand what the request really is for, it seems=
 there are multiple other ways of arriving at the goal, and the request=
 for blocklist safety and boot loader inodes is uncompelling.=20

Maybe increasing ext's VBR is useful since GRUB and extlinux already ha=
ve code to leverage that method of embedding for btrfs, which has a 64K=
B pad at the start (vs ext's 1KB). But even here I'm skeptical of the n=
eed.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
