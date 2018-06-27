From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: e2fsprogs: fix inode bitmap num not
 integer,incompatible for ancient android devices
Date: Wed, 27 Jun 2018 10:09:37 -0400
Message-ID: <20180627140937.GA3348@thunk.org>
References: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        sorp.liqingchao@huawei.com, harry.shen@huawei.com,
        miaoxie@huawei.com
To: GaoMing <gaoming20@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 26, 2018 at 07:54:06PM +0800, GaoMing wrote:
> for example, 1708 inodes every group,3 block groups, bitmap bytes are 1708/8=213.5 when the inode bitmap has some errors, e2fsprogs cannot fix it
>
> Signed-off-by: GaoMing <gaoming20@huawei.com>

File systems like this should not exist.  Can you please please please
make sure that any use of make_ext2fs are ripped out by the roots?

What I *should* do is have e2fsck reject these file systems as
completely invalid in pass 0, when we check for superblock sanity.  I
haven't because there are some older Android systems that use
make_ext2fs.  But at this point, what I am **seriously** doing is to
make e2fsck reject these file systems by default, unless a setting in
e2fsck.conf is set to allow them as an exception.

My concern about applying this patch is that it will be taken as
acceptance of e2fsprogs to fully support these sorts of invalid file
systems.  In particular, there is no guarantee that various tune2fs
options, resize2fs, etc., will work correctly even with your patch.

	 	    	       	    	      - Ted
