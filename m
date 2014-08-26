From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix same-dir rename when inline data directory
 overflows
Date: Mon, 25 Aug 2014 22:49:20 -0400
Message-ID: <20140826024920.GH11317@thunk.org>
References: <20140825194031.GE22645@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbaHZCtX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 22:49:23 -0400
Content-Disposition: inline
In-Reply-To: <20140825194031.GE22645@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 25, 2014 at 12:40:31PM -0700, Darrick J. Wong wrote:
> When performing a same-directory rename, it's possible that adding or
> setting the new directory entry will cause the directory to overflow
> the inline data area, which causes the directory to be converted to an
> extent-based directory.  Under this circumstance it is necessary to
> re-read the directory when deleting the old dirent because the "old
> directory" context still points to i_block in the inode table, which
> is now an extent tree root!  The delete fails with an FS error, and
> the subsequent fsck complains about incorrect link counts and
> hardlinked directories.
> 
> Test case (originally found with flat_dir_test in the metadata_csum
> test program):
> 
> # mkfs.ext4 -O inline_data /dev/sda
> # mount /dev/sda /mnt
> # mkdir /mnt/x
> # touch /mnt/x/changelog.gz /mnt/x/copyright /mnt/x/README.Debian
> # sync
> # for i in /mnt/x/*; do mv $i $i.longer; done
> # ls -la /mnt/x/
> total 0
> -rw-r--r-- 1 root root 0 Aug 25 12:03 changelog.gz.longer
> -rw-r--r-- 1 root root 0 Aug 25 12:03 copyright
> -rw-r--r-- 1 root root 0 Aug 25 12:03 copyright.longer
> -rw-r--r-- 1 root root 0 Aug 25 12:03 README.Debian.longer
> 
> (Hey!  Why are there four files now??)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
