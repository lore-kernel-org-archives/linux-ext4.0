From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] generic: add testcase to test fallocate & f{data,}sync
Date: Wed, 15 Nov 2017 19:42:08 +0800
Message-ID: <20171115114208.GT17339@eguan.usersys.redhat.com>
References: <20171115085833.55207-1-yuchao0@huawei.com>
 <20171115113728.GS17339@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, jaegeuk@kernel.org, chao@kernel.org,
        yuchao0@huawei.com
To: linux-ext4@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171115113728.GS17339@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 15, 2017 at 07:37:28PM +0800, Eryu Guan wrote:
> [adding ext4 list]
> 
> On Wed, Nov 15, 2017 at 04:58:33PM +0800, Chao Yu wrote:
> > f2fs can skip isize updating in fsync(), since during mount, f2fs tries
> > to recovery isize according to valid block address or preallocated flag
> > in last fsynced dnode block.
> > 
> > However, fallocate() breaks our rule with setting FALLOC_FL_KEEP_SIZE
> > flag, since it can preallocated block cross EOF, once the file is fsynced,
> > in POR, we will recover isize incorrectly based on these fallocated
> > blocks.
> > 
> > This patch adds a new testcase to test fallocate, in order to verify
> > whether filesystem will do correct recovery on isize.
> > 
> > Signed-off-by: Chao Yu <yuchao0@huawei.com>
> 
> This test fails on ext4 as
> 
>  ==== falloc -k 1024 test with fdatasync ====
> +Before:  "b: 8216 s: 4202496"
> +After :  "b: 8208 s: 4202496"
>  ==== falloc -k 4096 test with fdatasync ====
> +Before:  "b: 8216 s: 4202496"
> +After :  "b: 8208 s: 4202496"
>  ==== falloc -k 104857600 test with fdatasync ====
> +Before:  "b: 213008 s: 4202496"
> +After :  "b: 8208 s: 4202496"
> 
> So the block counts are changed after fdatasync & fs shutdown in the
> fallocate(2) KEEP_SIZE case. Looks like a real ext4 bug, fdatasync
> failed to flush the preallocated blocks beyond EOF to disk, but I want
> to confirm first with ext4 people. If it turns out to be a case issue,
> we'd like to update test case accordingly before merging it.

I think I've found the problem, ext4 fallocate(2) path is missing a
ext4_update_inode_fsync_trans(handle, inode, 1) call, as what commit
("67a7d5f561f4 ext4: fix fdatasync(2) after extent manipulation
operations") did.

I'll send an ext4 patch soon.

Thanks,
Eryu
