From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: kernel panic using external journal and snapshots
Date: Fri, 22 Nov 2013 15:11:45 +0800
Message-ID: <20131122071145.GA5936@gmail.com>
References: <5281A8A3.80604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gordon Messmer <gordon.messmer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48585 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3KVHJC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Nov 2013 02:09:02 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so870079pdj.25
        for <linux-ext4@vger.kernel.org>; Thu, 21 Nov 2013 23:09:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5281A8A3.80604@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Gordon,

On Mon, Nov 11, 2013 at 08:03:47PM -0800, Gordon Messmer wrote:
> I'm developing backup infrastructure for Linux using snapshots.  One
> of the supported configurations is EXT4 on LVM, but I think I've
> come across a bug.
> 
> I'm currently testing on CentOS 6, with kernel 2.6.32-358.6.1.el6.x86_64
> 
> If I create a snapshot of a filesystem with an external journal, and
> mount that snapshot while the original filesystem is mounted, the
> system will usually kernel panic.  If it does not panic, then the
> kernel will later refuse to mount it because "External journal has
> more than one user."  So, the first bug seems to be that ext4
> doesn't check the external journal before mounting the new snapshot
> to ensure that the journal is not in use.  Expected behavior is that
> the kernel would refuse to mount a filesystem whose journal already
> has a "user" in order to prevent a kernel panic.
> 
> If that were the extent of the problem, I probably wouldn't bother
> reporting the issue.  However, the kernel will STILL panic if I use
> tune2fs to remove the journal, and even if I use tune2fs to create a
> new internal journal.  The second bug, then, seems to be that once
> an ext4 filesystem has an external journal, that journal will
> continue to be used after it has been removed, and even if it is
> replaced with an internal journal.
> 
> The following commands were used to test the problem.  These are
> basically the commands run by the "snapshot" application.  It sets a
> minimum snapshot size of 10% of the volume size, then reads the size
> of the volume and the size remaining in the volume group.  It
> creates a uuid for the snapshot name, then creates the new snapshot.
> I use tune2fs first to verify that there is a journal device
> recorded, then remove the journal.  Afterward, I read the value
> again and find no external journal recorded.  When the filesystem is
> mounted, the kernel will usually panic.
> 
> Is this a known bug?  I haven't yet built a newer system to test the
> effects on the current kernel version.
> 
> min_size=10
> lvsize=$(lvs --noheadings --units m --nosuffix -o lv_size
> "VolGroup/lv_var" | cut -f1 -d.)
> vgfree=$(vgs --noheadings --units m --nosuffix -o vg_free
> "/dev/VolGroup" | cut -f1 -d.)
> test "$vgfree" -gt $(( $lvsize * $min_size / 100 )) || echo Not
> enough free space on "/dev/VolGroup" for snapshot
> uuid=$(uuidgen)
> lvcreate -s -n "lv_var-snap-${uuid}" -L "$(( $lvsize * $min_size /
> 100 ))"m "VolGroup/lv_var"
> 	  Rounding up size to full physical extent 128.00 MiB
> 	  Logical volume
> 	"lv_var-snap-66c41691-21c0-4db2-8af2-09a13d87a881" created
> tune2fs -l "/dev/VolGroup/lv_var-snap-${uuid}" | grep "^Journal device:"
> 	Journal device:              0xfd04
> tune2fs -O ^has_journal "/dev/VolGroup/lv_var-snap-${uuid}"
> 	tune2fs 1.41.12 (17-May-2010)
> 	Journal removed
> tune2fs -l "/dev/VolGroup/lv_var-snap-${uuid}" | grep "^Journal device:"
> mount "/dev/VolGroup/lv_var-snap-${uuid}" /mnt
> 	* kernel panic *
> 
> 
> https://bitbucket.org/gordonmessmer/dragonsdawn-snapshot

For the first question, I haven't a LVM device on my hand.  Hence I am
not sure whether there is a bug or not.

For the second one, I do a test on my sand box against Linux-3.12-rc5,
and it works well.  So I think maybe you can try it again on a newer
kernel.

Regards,
                                                - Zheng
