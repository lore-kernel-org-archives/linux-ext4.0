From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Thu, 12 Jan 2017 16:00:16 +0800
Message-ID: <2f3d73d9-3cbc-b4c1-40ff-02bc5f440b55@huawei.com>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
 <20170111153449.ourcta6jraxo4mzy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        <Valdis.Kletnieks@vt.edu>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <viro@zeniv.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:63775 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdALIG4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2017 03:06:56 -0500
In-Reply-To: <20170111153449.ourcta6jraxo4mzy@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


on 2017/1/11 23:34, Theodore Ts'o wrote:
> On Wed, Jan 11, 2017 at 05:07:29PM +0800, zhangyi (F) wrote:
>>
>> (1) The file we want to unlink have many hard links, but only one dcache entry in memory.
>> (2) open this file, but it's inode->i_nlink read from disk was 1 (too low).
>> (3) some one call rename and drop it's i_nlink to zero.
>> (4) it's inode is still in use and do not destroy (not closed), at the same time,
>>     some others open it's hard link and create a dcache entry.
>> (5) call rename again and it's i_nlink will still underflow and cause memory corruption.
> 
> Do you have reproducers that make it easy to reproduce situations like
> this?  (It shouldn't be hard to write, but if you have them already
> will save me some effort.  :-)
> 
> If we ever get passed an inode to ext4_file_open() where i_nlink is
> zero, we can declare the file system is corrupt by calling
> ext4_error() to report the problem.
> 
> Similarly, whenever we are passed a dentry pointing to an inode for
> link, unlink, rename, and other methods in the inode_operations
> structure, by definition the file system is corrupt, and again we
> should report this using ext4_error().
> 
> So I don't think we should think of this as adding "underflow
> protection"; instead we should think of it as adding more aggressive
> detection of file system inconsistencies.  If there is dentry which is
> valid, and pointing at an inode where n_links is zero, something has
> gone seriously wrong.  So we should call ext4_error() to report the
> file system inconsistency, and then return EFSCORRUPTED (aka EUCLEAN).
> 
> Since we would be doing this in a number of places, we should probably
> add an inline function:
> 
> static inline int ext4_validate_dentry(struct dentry *dentry);
> 
> which returns 0 if the dentry is valid, and calls ext4_error_inode()
> and returns -EFSCORRUPTED if the dentry points to an inode with a zero
> i_nlink.
> 

Thanks for your advice, it can detect file system inconsistency and reprot
error more effective. :-)

At the same time, I think other file systems may have the same problem, do
you think we should put these detections on the VFS layer? Thus other file
systems no need to do the same things, but the disadvantage is that we can
not call ext4_error to report ext4 inconsistency.

yi zhang

