From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro filesystem
Date: Tue, 24 Jul 2012 17:18:42 -0500
Message-ID: <500F1F42.5010209@redhat.com>
References: <500F1C28.8010800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2GXWSp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2012 18:18:45 -0400
In-Reply-To: <500F1C28.8010800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/24/12 5:05 PM, Eric Sandeen wrote:
> This sequence:
> 
> # truncate --size=65536 fsfile
> # losetup --offset 65536 /dev/loop0 fsfile 
> # mkfs.ext4 /dev/loop0 
> # losetup -d /dev/loop0
> # mount -o loop,ro,offset=65536 fsfile  mnt/
> # umount mnt
> # dmesg | tail
> 
> results in an IO error when unmounting the RO filesystem:
> 
> [  312.386074] SELinux: initialized (dev loop1, type ext4), uses xattr
> [  318.020828] Buffer I/O error on device loop1, logical block 196608
> [  318.027024] lost page write due to I/O error on loop1
> [  318.032088] JBD2: Error -5 detected when updating journal superblock for loop1-8.
> 
> This behavior changed with:
> 
> commit 24bcc89c7e7c64982e6192b4952a0a92379fc341
> Author: Jan Kara <jack@suse.cz>
> Date:   Tue Mar 13 15:41:04 2012 -0400
> 
>     jbd2: split updating of journal superblock and marking journal empty
> 
> which lost some of the magic in jbd2_journal_update_superblock() which
> used to test for a journal with no outstanding transactions.
> 
> I'm not sure if the following is quite the right approach, but it fixes
> it for me.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. no idea why this only happens if I use a loop device with an offset!

PEBKAC.  no-offset ro loop mount does the same.

-Eric

