From: Jan Kara <jack@suse.cz>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Wed, 25 Sep 2013 18:12:59 +0200
Message-ID: <20130925161259.GA5404@quack.suse.cz>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab3IYSHK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 14:07:10 -0400
Content-Disposition: inline
In-Reply-To: <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-09-13 22:25:49, InvTraySts wrote:
> So long story short, I had a server running that had a processor fail
> while powered on, causing the file systems to become corrupt. I
> replaced the motherboard, processor and power supply just to be on the
> safe side. However, I am at a bit of a loss as to what to do now. I
> was working sandeen in the OFTC IRC channel, but, on his
> recommendation he suggested me to post something to the mailing list.
> 
> Lets start off with one drive at a time (I have 4 that are corrupt).
> The specific logical drive in question was in RAID1 on a Dell PERC 5/i
> card.
> If I try to mount this using:
> mount -t ext4 /dev/sda1 /media/tmp
> 
> It complains in dmesg with the following output:
> 685621.845207] EXT4-fs error (device sda1): ext4_iget:3888: inode #8:
> comm mount: bad extra_isize (18013 != 256)
> [685621.845213] EXT4-fs (sda1): no journal found
> 
> 
> However, if I run dumpe2fs -f /dev/sda1 I get the following output:
> root@server:~# dumpe2fs -f /dev/sda1
> dumpe2fs 1.42.5 (29-Jul-2012)
> Filesystem volume name:   root
> Last mounted on:          /media/ubuntu/root
> Filesystem UUID:          f959e195-[removed]
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
> dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         not clean with errors
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              4849664
> Block count:              19398144
> Reserved block count:     969907
> Free blocks:              17034219
> Free inodes:              4592929
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      1019
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> Flex block group size:    16
> Filesystem created:       Sat May 25 14:59:50 2013
> Last mount time:          Sat Aug 24 11:04:25 2013
> Last write time:          Tue Sep 24 13:55:36 2013
> Mount count:              0
> Maximum mount count:      -1
> Last checked:             Sat Aug 24 16:56:09 2013
> Check interval:           0 (<none>)
> Lifetime writes:          107 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      01a8f605-b2bc-41ee-b7b5-11d843ab622f
> Journal backup:           inode blocks
> FS Error count:           8
> First error time:         Sat Aug 24 13:44:55 2013
> First error function:     ext4_iget
> First error line #:       3889
> First error inode #:      8
> First error block #:      0
> Last error time:          Tue Sep 24 13:55:36 2013
> Last error function:      ext4_iget
> Last error line #:        3888
> Last error inode #:       8
> Last error block #:       0
> dumpe2fs: Corrupt extent header while reading journal super block
  OK, so really journal inode (inode #8) looks toast but superblock looks
OK.

> So I attempted to clone the drive to a 2TB backup drive that is empty,
> and currently I am having more problems with the cloned drive than I
> am with the original.
> 
> sandeen said something about using tune2fs to tell it to remove the
> has_journal flag, but I might need some assistance with that.
  Yes, you can do that with:
tune2fs -f -O ^has_journal /dev/sda1

  Let's see what mount will say after that.

  Another option is to run
debugfs /dev/sda1

  Then you can use ls, cd, and other debugfs commands to move within the
filesystem and investigate things. If that will work, you have a reasonable
chance of getting at least some data back.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
