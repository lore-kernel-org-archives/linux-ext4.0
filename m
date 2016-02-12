From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: clarify error messages for mounting fs w/o journal
 /w journal options
Date: Fri, 12 Feb 2016 12:03:08 -0500
Message-ID: <20160212170308.GC7928@thunk.org>
References: <1455283909-23354-1-git-send-email-george@george-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Georg Altmann <george@george-net.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455283909-23354-1-git-send-email-george@george-net.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 12, 2016 at 02:31:49PM +0100, Georg Altmann wrote:
> Previous message was hard to understand: When mounting a ext4 fs without a
> journal, but a mount option that controls journaling is used, clearly state
> that the fs cannot be mounted with this option because it has no journal.

Well, technically it's possible for the file system to have a journal,
but for journalling not to be enabled.  For example:

root@kvm-xfstests:~# dmesg -n 7
root@kvm-xfstests:~# mke2fs -t ext4 -Fq /dev/vdc
/dev/vdc contains a ext4 file system
	created on Fri Feb 12 11:59:10 2016
root@kvm-xfstests:~# dumpe2fs /dev/vdc | grep features
dumpe2fs 1.43-WIP (18-May-2015)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Journal features:         (none)
root@kvm-xfstests:~# mount -o noload,commit=1 /dev/vdc /vdc 2> /dev/null
[  313.867505] EXT4-fs (vdc): can't mount with commit=1, fs mounted w/o journal

So saying "fs has no journal" isn't necessarily going to be correct.
Maybe "Can't mount with data=xxx, journalling not enabled" would be
less confusing to users?

Cheers,

						- Ted
