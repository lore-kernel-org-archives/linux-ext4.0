From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: 20 Jan 2017 12:57:23 -0500
Message-ID: <20170120175723.17324.qmail@ns.sciencehorizons.net>
References: <20170120144026.bvg2mpe3uvb5yspi@thunk.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: linux@sciencehorizons.net, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:64837 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751744AbdATR5a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2017 12:57:30 -0500
In-Reply-To: <20170120144026.bvg2mpe3uvb5yspi@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Those bugs look like they are very separate in that they have nothing
> to do with locking, but rather in e2fsck and the kernel not properly
> dealing with certain types of inconsistencies on disk.  On my list to
> deal with.  As a workaround, you can just clri the offending corrupted
> inode from lost+found and then run e2fsck.

Yes, that's fairly obvious, but I've avoided that for a few reasons:
1) I was holding on to the broken inodes in case you needed more information
   that I didn't include in the initial report,
2) I also thought they might be wanted to test an eventual fix, and
3) I was probably going to get a bit fancier to preserve the file names.

My latest report is a bit confusing because debugfs() reads the
directories without complaint, so I'm not sure it's a valid on-disk
situation that the kernel is improperly rejecting, or an invaid situation
that libext2fs is improperly accepting.

Since I don't currently understand the on-disk format of inline data,
(I need to RTFS), I can't figure that out or see if there's a way
to do a repair in situ.

Oh!  Found it at
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Inline_Data

So I'm guessing the problem is that the required empty system.data
attribute is missing (due to the preceding extra_isize changing mess),
and if I just created it, everything would magically come back to life.

Something like ea_set <inode> system.data ""
