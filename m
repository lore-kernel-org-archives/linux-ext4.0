From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Thu, 12 Jan 2017 12:03:28 -0500
Message-ID: <20170112170328.ez2ozqkyrkb2olcm@thunk.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
 <20170111153449.ourcta6jraxo4mzy@thunk.org>
 <2f3d73d9-3cbc-b4c1-40ff-02bc5f440b55@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Valdis.Kletnieks@vt.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk
To: "zhangyi (F)" <yi.zhang@huawei.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2f3d73d9-3cbc-b4c1-40ff-02bc5f440b55@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 12, 2017 at 04:00:16PM +0800, zhangyi (F) wrote:
> 
> At the same time, I think other file systems may have the same problem, do
> you think we should put these detections on the VFS layer? Thus other file
> systems no need to do the same things, but the disadvantage is that we can
> not call ext4_error to report ext4 inconsistency.

There are file systems which don't have inodes per-se where the
i_nlinks could be a something which is simulated by the file system.
So it's not *necessarily* an on-disk inconsistency.

We'll have to see if Al and other file system developers are
agreeable, but one thing that we could do is to do the detection in
the VFS layer (which it is actually easier to do), and if they find an
issue, they can just pass a report via a callback function found in
the struct_operations structure.  If there isn't such a function
defined, or the function returns 0, the VFS could just do nothing; if
it returns an error code, then that would get reflected back up to
userspace, plus whatever other action the file system sees fit to do.

	   		       	      	  - Ted
