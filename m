From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Mon, 27 Oct 2008 09:54:23 -0700
Message-ID: <20081027165423.GB25797@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:6690 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYJ0QyY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 12:54:24 -0400
Content-Disposition: inline
In-Reply-To: <20081024183733.GA25797@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some additional info -- and attempting to cast a wider
net on the CC:

I do not see the long symlink corruption with mount -o data=writeback
and we've now seen a couple cases where the symlink corruption
does not require a umount...

Arthur

On Fri, Oct 24, 2008 at 11:37:34AM -0700, Arthur Jones wrote:
> Hi All,  I'm seeing slow symlink corruption on ext3 on linux-2.6.27,
> yesterday's linux-2.6 git tree and 2.6.9 RHEL4.7.  I.e. every kernel
> I've tried I see this effect.  To reproduce this, I need:
> 
> * 250MB + tar file in memory (tmpfs or in the buffer cache)
> * long symlinks in the tar file (over 60 characters)
> * umount immediately after untarring
> 
> What I see is that the symlinks are corrupted, e.g.:
> 
> # ls -l etc/vmware-vix-disklib
> etc/vmware-vix-disklib -> ??f
> 
> fsck shows:
> 
> Symlink /etc/vmware-vix-disklib (inode #16454) is invalid.
> 
> Debugfs shows:
> 
> debugfs:  stat <16454>
> Inode: 16454   Type: symlink    Mode:  0777   Flags: 0x0   Generation: 1431972005
> User:     0   Group:     0   Size: 65
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
> atime: 0x4900ac84 -- Thu Oct 23 09:55:32 2008
> mtime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
> BLOCKS:
> (0):56034
> TOTAL: 1
> 
> I'm still tracking down exactly what's going on.  Anyone seen
> anything like this before?  ext2 does not show this effect (I've
> not tried ext4).  It happens when the backing block device is
> a SATA drive or flash.
> 
> Thanks,
> 
> Arthur
