From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 30 Jan 2008 17:48:21 -0500
Message-ID: <20080130224820.GA20529@mit.edu>
References: <20080122231707.GA21968@mit.edu> <47A0F98C.1080304@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47607 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753132AbYA3Wsa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2008 17:48:30 -0500
Content-Disposition: inline
In-Reply-To: <47A0F98C.1080304@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2008 at 11:26:20PM +0100, supersud501 wrote:
>
> how can i set this "flag" on my filesystem? i've never set any flags before 
> so i just removed the code from ext4-module to mount my filesystems, but 
> setting the flag once would make it easier i think :)

If you have e2fsprogs 1.40.5, you set at mke2fs time via "mke2fs -E
test_fs ...".  If you haven't mounted the filesystem using ext4 yet,
you can also convert an existing filesystem using "tune2fs -E test_fs
/dev/hdXXX".  At least with e2fsprogs 1.40.5, it won't work with a
filesystem with extents enabled because tune2fs will refuse to touch
such a filesystem.  (And you don't want to use e2fsprogs 1.40.5 with
ext4 anyway, since e2fsck in 1.40.5 doesn't understand extents yet.)

You can manually set the flag using debugfs:

    # debugfs -w /dev/hdXX
    debugfs: set_super_value s_flags 4
    debugfs: quit

(Or, if you're lazy, you can also type the shorthand "ssv flags 4" to
debugfs.)

With e2fsprogs 1.40.5, if the test_fs flag is set, then blkid will
return a filesystem type ext4dev, such that if your mount is
configured to use blkid (instead of vol_id), it will automatically use
ext4dev to mount a filesystem that has (a) a journal (since ext4
currently requires a journal), and (b) the test_fs flag set.

This makes it easier for people who are testing ext4, since they will
just be able to do something like:

      # mke2fs -j -E test_fs /dev/mapper/lvmset-test
      # mount /dev/mapper/lvmset-test

.. and /dev/mapper/lvmset-test will automatically be mounted using
ext4.

							 - Ted
