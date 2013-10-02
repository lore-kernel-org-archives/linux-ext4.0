From: James Dingwall <james.dingwall@zynstra.com>
Subject: Re: ext[234] data corruption (Linux 3.8, 3.9 / Xen)
Date: Wed, 2 Oct 2013 17:51:54 +0100
Message-ID: <524C4F2A.4010609@zynstra.com>
References: <524314B3.3090000@zynstra.com> <5243E0C0.2090304@zynstra.com> <20130926191404.GB21811@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-am1lp0016.outbound.protection.outlook.com ([213.199.154.16]:7367
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753958Ab3JBQwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 12:52:10 -0400
In-Reply-To: <20130926191404.GB21811@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>    Hello,
>
> On Thu 26-09-13 08:22:40, James Dingwall wrote:
>>> Hi,
>>>
>>> We have observed a data corruption bug in a database created by
>>> the postmap command (BDB file) under the following conditions:
>>>
>>> Xen domU guest kernel 3.8, 3.9 (3.5, 3.10, 3.11 don't show the
>>> behaviour 3.6 and 3.7 are unknown)
>>> dom0 Xen 4.2.1 / kernel 3.8 or Xen 4.3.0 / kernel 3.11
>>> The guest has a passed through block device (phy:/ or file:/)
>>> The filesytem on the passed through device is ext2/3/4 with a 1k
>>> block size
>    Thanks for report! So have you really tried with all three filesystems?
> And don't you have EXT4_USE_FOR_EXT23 set by any chance? There were some
> changes to ext4 writeback path and extent status tree. So for ext4 I could
> understand the problem got introduced and fixed. But ext2/3 didn't see any
> significant changes for a long time...
EXT4_USE_FOR_EXT23 doesn't seem to be in use and it isn't listed in 
/proc/config.gz, perhaps a parent option that would make it available 
isn't set?

# zgrep EXT[234] /proc/config.gz
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set

>>> By examining a strace of the postmap command we produced a short
>>> piece of code (at the bottom) which demonstrates the problem.  If
>>> this is executed in a loop such as:
>>>
>>> #!/bin/bash
>>> for i in $(seq 1 5) ; do
>>>         mount /dev/xvde1 /mnt
>>>         pushd /mnt> /dev/null
>>>         echo "checksums after mount"
>>>         md5sum testcase.bin
>>>         [ "${i}" = "1" ] && ./a.out
>>>         echo "checksums before umount"
>>>         md5sum testcase.bin
>>>         popd> /dev/null
>>>         umount /mnt
>>> done
>    I'll see if I can reproduce this to investigate.
>
> <snip output of script>
>    Well, you can always use 'git bisect' to find the commit that fixed this.
In the end it seemed that the problem was fixed in a 3.10 stable release 
(I had originally tested with 3.10.10 which it may have been helpful to 
mention:) as it does happen with a kernel built from tag v3.10.  
Bisecting gives commit 7b2b160da7661bb2ade3f924b1bd3e3084e53341 (in 
xen-blkfront.c) which solves the observed issue although the commit 
message seems to indicate it is a resolution for a problem of a 
different nature.  My knowledge of kernel internals isn't enough to 
understand why this is the fix.  Since the commit applies cleanly to the 
Ubuntu 3.8 LTS tree (where we found the original problem) we'll do some 
testing and then open it as an Ubuntu bug if it looks good.

<snip test program>
