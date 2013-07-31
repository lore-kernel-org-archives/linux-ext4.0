From: Bill McGonigle <bill@bfccomputing.com>
Subject: Re: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Wed, 31 Jul 2013 13:28:24 -0400
Message-ID: <51F94938.1040303@bfccomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from borlaug.bfccomputing.com ([173.9.115.12]:54788 "EHLO
	borlaug.bfccomputing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3GaRjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jul 2013 13:39:23 -0400
Received: from zpm.bfccomputing.com (unknown [10.5.1.146])
	by borlaug.bfccomputing.com (Postfix) with ESMTPSA id 9831947A8EE
	for <linux-ext4@vger.kernel.org>; Wed, 31 Jul 2013 13:28:25 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Adding a mount option, "-o journal_path=/dev/$DEVICE" would
> help, since then we can do i.e.
>
> # mount -o journal_path=/dev/disk/by-label/$JOURNAL_LABEL /mnt

I came here with a related problem, and I wonder if it would be a more 
general solution to this one too.

I've got a machine with root on ext4 on LUKS on md, and while I was 
first planning to use flashcache or dm-cache underneath it (for SSD 
acceleration) I saw benchmarks that convinced me that an external 
journal on ext4 was the better option.

It's getting it mounted at boot time that's the trick.

I saw that tune2fs supports '-J device=UUID=foo-bar-baz', so I setup a 
LUKS volume on the SSD, formatted it, passed it in, and it sets up the 
journal fine when I'm booted from external media, but when I reboot 
under the OS (3.10 in Fedora 19 in this case) it fails to mount because 
the device number has changed.

I see the proper UUID listed in 'tune2fs -l' - the "Journal UUID" is 
right, but "Journal device" is no longer correct, so boot fails until I 
remove the journal again.  I think with LUKS, I'm never guaranteed to 
get a consistent device ID between boots, so the kernel command line 
options don't help either.

So, I was thinking, that if the ext code did:
   1) try stored journal device ID
   2) on fail, look up the UUID via libblkid
   3) perhaps update the stored device ID

it would solve my problem.  I wonder if it would be a more robust 
solution to the problem posed here as well (having the filesystem 
contain its own references is better IMHO).  My one handy system that 
has an ext3 volume (still on Fedora 16, e2fsprogs-1.41) does not show a 
Journal UUID flag via 'tune2fs -l', but I'm unaware of whether the flag 
is unavailable/missing/unsupported there or if it could be added.

-Bill

-- 
Bill McGonigle, Owner
BFC Computing, LLC
http://bfccomputing.com/
Telephone: +1.855.SW.LIBRE
Email, IM, VOIP: bill@bfccomputing.com
VCard: http://bfccomputing.com/vcard/bill.vcf
Social networks: bill_mcgonigle/bill.mcgonigle
