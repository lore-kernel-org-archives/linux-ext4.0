From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Fri, 13 Jan 2017 09:26:56 -0500
Message-ID: <20170113142656.xmrtuimxfwgxt522@thunk.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
 <20170111153449.ourcta6jraxo4mzy@thunk.org>
 <2f3d73d9-3cbc-b4c1-40ff-02bc5f440b55@huawei.com>
 <20170112170328.ez2ozqkyrkb2olcm@thunk.org>
 <20170113034219.GG1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "zhangyi (F)" <yi.zhang@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Valdis.Kletnieks@vt.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, jack@suse.cz
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170113034219.GG1555@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 13, 2017 at 03:42:19AM +0000, Al Viro wrote:
> On Thu, Jan 12, 2017 at 12:03:28PM -0500, Theodore Ts'o wrote:
> > On Thu, Jan 12, 2017 at 04:00:16PM +0800, zhangyi (F) wrote:
> > > 
> > > At the same time, I think other file systems may have the same problem, do
> > > you think we should put these detections on the VFS layer? Thus other file
> > > systems no need to do the same things, but the disadvantage is that we can
> > > not call ext4_error to report ext4 inconsistency.
> > 
> > There are file systems which don't have inodes per-se where the
> > i_nlinks could be a something which is simulated by the file system.
> > So it's not *necessarily* an on-disk inconsistency.
> > 
> > We'll have to see if Al and other file system developers are
> > agreeable, but one thing that we could do is to do the detection in
> > the VFS layer (which it is actually easier to do), and if they find an
> > issue, they can just pass a report via a callback function found in
> > the struct_operations structure.  If there isn't such a function
> > defined, or the function returns 0, the VFS could just do nothing; if
> > it returns an error code, then that would get reflected back up to
> > userspace, plus whatever other action the file system sees fit to do.
> 
> 	Detection of what?  Zero ->i_nlink on inode of dentry that passes e.g.
> may_delete()?

Or other impossible cases where there is a valid dentry pointing at an
inode with zero i_nlink.  I am fairly sure this should **never**
happen in the case of unlink(2), rmdir(2), or by the time we call
file_ops->open(), and if it does, it indicates that the underlying
on-disk file system (at least for ext4) is corrupt.

Am I missing a case?  And do you have an opinion about whether we
should be trying to do this check at the VFS layer versus inside ext4?

Thanks,

					- Ted
