From: <doiggl@velocitynet.com.au>
Subject: Can the patch set [1] be put up on openSUSE Build Service as well please ?
Date: Sat, 15 Apr 2017 13:22:51 +1000
Message-ID: <65be8803bd32e856e3da59fcf5eee77a@mail.velocitynet.com.au>
References: <20170412072611.29017-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <reiserfs-devel@vger.kernel.org>,
        <jfs-discussion@lists.sourceforge.net>
To: Jan Kara <jack@suse.cz>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,
Can the patch set [1] be put up on openSUSE Build Service as well please ?
 
- check it builds.

example:
kernel-vanilla
https://build.opensuse.org/package/show/Kernel:vanilla/kernel-vanilla#
https://build.opensuse.org/package/show/Kernel:vanilla/kernel-source

Thanks
--Glenn

From:
http://www.spinics.net/lists/reiserfs-devel/

[PATCH 0/11] quota: Stop setting IMMUTABLE and NOATIME flags directly
http://www.spinics.net/lists/reiserfs-devel/msg05442.html

[1]
[PATCH 0/11] quota: Stop setting IMMUTABLE and NOATIME flags directly, Jan
Kara

    [PATCH 04/11] jfs: Set flags on quota files directly, Jan Kara
    [PATCH 08/11] jfs: Remove jfs_get_inode_flags(), Jan Kara
    [PATCH 07/11] ext2: Remove ext2_get_inode_flags(), Jan Kara
        Re: [PATCH 07/11] ext2: Remove ext2_get_inode_flags(), Andreas
Dilger
    [PATCH 06/11] ext4: Remove ext4_get_inode_flags(), Jan Kara
        Re: [PATCH 06/11] ext4: Remove ext4_get_inode_flags(), Andreas
Dilger
    [PATCH 05/11] quota: Stop setting IMMUTABLE and NOATIME flags on quota
files, Jan Kara
        Re: [PATCH 05/11] quota: Stop setting IMMUTABLE and NOATIME flags
on quota files, Andreas Dilger
    [PATCH 11/11] quota: Remove dquot_quotactl_ops, Jan Kara
    [PATCH 09/11] reiserfs: Remove useless setting of i_flags, Jan Kara
    [PATCH 10/11] reiserfs: Remove i_attrs_to_sd_attrs(), Jan Kara
    [PATCH 01/11] ext4: Set flags on quota files directly, Jan Kara
        Re: [PATCH 01/11] ext4: Set flags on quota files directly, Andreas
Dilger
            Re: [PATCH 01/11] ext4: Set flags on quota files directly, Jan
Kara
    [PATCH 03/11] ext2: Set flags on quota files directly, Jan Kara
    [PATCH 02/11] reiserfs: Set flags on quota files directly, Jan Kara

[PATCH 1/2] reiserfs: Make cancel_old_flush() reliable, Jan Kara

    [PATCH 2/2] reiserfs: Protect dquot_writeback_dquots() by s_umount
semaphore, Jan Kara

https://build.opensuse.org/package/show/Kernel:vanilla/kernel-source
