From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: mballoc.c: fix ac_g_ex and ac_f_ex misuse bug in
 EXT4_MB_HINT_TRY_GOAL path
Date: Tue, 7 Jun 2016 23:15:49 -0700
Message-ID: <20160608061549.GA5724@birch.djwong.org>
References: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
 <D4F0CA1E-2075-4EBE-A945-A56F6B7D6808@dilger.ca>
 <5757B655.6080803@chinanetcenter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Lin Feng <linf@chinanetcenter.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5757B655.6080803@chinanetcenter.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 08, 2016 at 02:08:21PM +0800, Lin Feng wrote:
> Hi Andreas,
> 
> Thanks for your reply and review.
> 
> On 06/08/2016 05:01 AM, Andreas Dilger wrote:
> >On Jun 2, 2016, at 6:01 AM, Lin Feng <linf@chinanetcenter.com> wrote:
> >>
> >>Descriptions:
> >>ext4 block allocation core stack:
> >>ext4_mb_new_blocks
> >>  ext4_mb_normalize_request
> >>  ext4_mb_regular_allocator
> >>    ext4_mb_find_by_goal
> >>      mb_find_extent(e4b, ac->ac_g_ex.fe_start, ac->ac_g_ex.fe_len, &ex);
> >>
> >>The start block searching hint for merging(use EXT4_MB_HINT_TRY_GOAL flag)
> >>set in ext4_mb_normalize_request is stored in ac_f_ex, while in
> >>EXT4_MB_HINT_TRY_GOAL path which falls in ext4_mb_find_by_goal always use
> >>ac_g_ex as a hint and the hint set in ext4_mb_normalize_request is never
> >>use.
> >>
> >>We could hit this bug by writing a sparse file from backward mode and the
> >>file may get fragments even if the physical blocks in the hole is free,
> >>which is expected to be merged into a single extent.
> >
> >This looks reasonable.  Do you have any kind of test case that shows the
> >effect of the change (e.g. fragmentation counts per file before/after)?
> 
> I found this bug by fiddling the block allocation policy for ext4.
> 
> In order to see the effect of this patch, we could do the following:
> 
> On a fresh created ext4 fs, make a new topdir called b to hash the test to
> some blockgroup relatively empty, trying to not to be effected by original
> physical fragments. Then write a new file in backward mode.
> 
> steps:
> 1. mkdir b && cd b
> 
> 2. before this patch:
> [root@CentOS6 b]# rm dat -f && sync && sleep 2 && dd if=/dev/zero of=dat
> bs=4k count=256 seek=511 conv=notrunc && sync && sleep 2 && dd if=/dev/zero
> of=dat bs=4k count=254 seek=257 conv=notrunc && sync && filefrag -vv dat
> 256+0 records in
> 256+0 records out
> 1048576 bytes (1.0 MB) copied, 0.000825721 s, 1.3 GB/s
> 254+0 records in
> 254+0 records out
> 1040384 bytes (1.0 MB) copied, 0.000766912 s, 1.4 GB/s
> Filesystem type is: ef53
> File size of dat is 3141632 (767 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0     257     9512             254
>    1     511   557056     9766    256 eof
> dat: 2 extents found

Sure would be nice to have an xfstests for this...

--D

> 
> 3. after this patch:
> [root@CentOS6 b]# rm dat -f && sync && sleep 2 && dd if=/dev/zero of=dat
> bs=4k count=256 seek=511 conv=notrunc && sync && sleep 2 && dd if=/dev/zero
> of=dat bs=4k count=254 seek=257 conv=notrunc && sync && filefrag -vv dat
> 256+0 records in
> 256+0 records out
> 1048576 bytes (1.0 MB) copied, 0.000856416 s, 1.2 GB/s
> 254+0 records in
> 254+0 records out
> 1040384 bytes (1.0 MB) copied, 0.000669862 s, 1.6 GB/s
> Filesystem type is: ef53
> File size of dat is 3141632 (767 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0     257   556802             510 eof
> dat: 1 extent found
> 
> thanks,
> linfeng
> >
> >Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> >
> >>Signed-off-by: Lin Feng <linf@chinanetcenter.com>
> >>---
> >>fs/ext4/mballoc.c | 8 ++++----
> >>1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >>diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> >>index c1ab3ec..e31fc63 100644
> >>--- a/fs/ext4/mballoc.c
> >>+++ b/fs/ext4/mballoc.c
> >>@@ -3198,15 +3198,15 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> >>	if (ar->pright && (ar->lright == (start + size))) {
> >>		/* merge to the right */
> >>		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
> >>-						&ac->ac_f_ex.fe_group,
> >>-						&ac->ac_f_ex.fe_start);
> >>+						&ac->ac_g_ex.fe_group,
> >>+						&ac->ac_g_ex.fe_start);
> >>		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
> >>	}
> >>	if (ar->pleft && (ar->lleft + 1 == start)) {
> >>		/* merge to the left */
> >>		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
> >>-						&ac->ac_f_ex.fe_group,
> >>-						&ac->ac_f_ex.fe_start);
> >>+						&ac->ac_g_ex.fe_group,
> >>+						&ac->ac_g_ex.fe_start);
> >>		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
> >>	}
> >>
> >>--
> >>1.9.3
> >>
> >>
> >
> >
> >Cheers, Andreas
> >
> >
> >
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
