From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Wed, 31 Jul 2013 14:45:40 -0500
Message-ID: <51F96964.4000608@redhat.com>
References: <51F94938.1040303@bfccomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bill McGonigle <bill@bfccomputing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab3GaTpo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 15:45:44 -0400
In-Reply-To: <51F94938.1040303@bfccomputing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/31/13 12:28 PM, Bill McGonigle wrote:
> 
>> Adding a mount option, "-o journal_path=/dev/$DEVICE" would help,
>> since then we can do i.e.
>> 
>> # mount -o journal_path=/dev/disk/by-label/$JOURNAL_LABEL /mnt
> 
> I came here with a related problem, and I wonder if it would be a
> more general solution to this one too.
> 
> I've got a machine with root on ext4 on LUKS on md, and while I was
> first planning to use flashcache or dm-cache underneath it (for SSD
> acceleration) I saw benchmarks that convinced me that an external
> journal on ext4 was the better option.
> 
> It's getting it mounted at boot time that's the trick.
> 
> I saw that tune2fs supports '-J device=UUID=foo-bar-baz', so I setup
> a LUKS volume on the SSD, formatted it, passed it in, and it sets up
> the journal fine when I'm booted from external media, but when I
> reboot under the OS (3.10 in Fedora 19 in this case) it fails to
> mount because the device number has changed.
> 
> I see the proper UUID listed in 'tune2fs -l' - the "Journal UUID" is
> right, but "Journal device" is no longer correct, so boot fails until
> I remove the journal again.

Neat eh? ;)

> I think with LUKS, I'm never guaranteed
> to get a consistent device ID between boots, so the kernel command
> line options don't help either.
> 
> So, I was thinking, that if the ext code did: 1) try stored journal
> device ID 2) on fail, look up the UUID via libblkid 3) perhaps update
> the stored device ID

well, kernelspace can't use libblkid.

> it would solve my problem.  I wonder if it would be a more robust
> solution to the problem posed here as well (having the filesystem
> contain its own references is better IMHO).  My one handy system that
> has an ext3 volume (still on Fedora 16, e2fsprogs-1.41) does not show
> a Journal UUID flag via 'tune2fs -l', but I'm unaware of whether the
> flag is unavailable/missing/unsupported there or if it could be
> added.

I think my patch will solve your problems as it is, just add the new
mount option to fstab, remake your init$WHATEVER, and off you'll go.

I'll send the ext4 version in a minute if you want to try it.

-Eric

> -Bill
> 

