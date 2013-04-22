From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird resize2fs failures when mounting ext3 as ext4
Date: Sun, 21 Apr 2013 20:38:14 -0500
Message-ID: <51749486.20606@redhat.com>
References: <51229FF7.7090003@redhat.com> <20130421233057.GA5625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3DVBiR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 21:38:17 -0400
In-Reply-To: <20130421233057.GA5625@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/21/13 6:30 PM, Theodore Ts'o wrote:
> On Mon, Feb 18, 2013 at 03:41:11PM -0600, Eric Sandeen wrote:
>> Can't remember how I stumbled on this testcase, but mounting
>> an ext3 filesystem with "-t ext4" and then resizing leads to trouble.
> 
> Is there a bugzilla entry for this?  I found the problem and a fix;
> patch follows in a moment.

Sorry, I took a look and I think I failed to file a bug.

> Also, here's a simplified repro that doesn't require LVM.  The bug was
> introduced in commit fb0a387dcdc, so it goes back to 2.6.32.

Argh.  Karma!  Sorry about that, and thanks for taking a look.

-Eric

> It only
> affects block allocations for files that aren't extent mapped, and is
> caused by the fact that the online resizer wasn't updating
> s_blockfile_groups (which was introduced in commit fb0a387dcdc).
> 
> 						- Ted
> 
> #!/bin/bash
> 
> COUNT=15
> SIZE_1=15G
> SIZE_2=16G
> DEVICE=/dev/vdc
> XFS_IO=/root/xfstests/bin/xfs_io
> 
> mkdir -p mnt
> umount mnt &>/dev/null
> mkfs.ext3  $DEVICE $SIZE_1
> mount -t ext4 -o nodelalloc $DEVICE mnt/
> 
> for I in `seq 1 $COUNT`; do mkdir mnt/dir$I; dd if=/dev/zero of=mnt/dir$I/file$I bs=1M count=1024; done
> echo "before growing:"
> df mnt/
> 
> umount mnt
> mount -t ext4 -o nodelalloc $DEVICE mnt/
> 
> echo "growing:"
> #export RESIZE2FS_KERNEL_VERSION=3.2.0
> strace -o /tmp/resize2fs.strace resize2fs $DEVICE $SIZE_2
> 
> echo "done growing:"
> df mnt/
> 
> # This gets ENOSPC for all of them
> echo "try extending files:"
> for I in `seq 1 $COUNT`; do $XFS_IO -f -F -c "pwrite -b 4m 1G 50m" mnt/dir$I/file$I; done 
> df mnt/
> 
> umount mnt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

