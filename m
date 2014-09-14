From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 5/5] update i_disksize coherently with block allocation
Date: Sun, 14 Sep 2014 16:38:45 +0400
Message-ID: <8761gqpeay.fsf@openvz.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org> <1408707147-22482-6-git-send-email-dmonakhov@openvz.org> <20140823220029.GC6236@thunk.org> <87ha119f03.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46027 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaINMit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2014 08:38:49 -0400
Received: by mail-lb0-f181.google.com with SMTP id z11so3054944lbi.26
        for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2014 05:38:47 -0700 (PDT)
In-Reply-To: <87ha119f03.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Aug 2014 11:59:08 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> On Sat, 23 Aug 2014 18:00:29 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> > On Fri, Aug 22, 2014 at 03:32:27PM +0400, Dmitry Monakhov wrote:
> > > Writeback call trace looks like follows:
> > > ext4_writepages
> > >  while(nr_pages)
> > >  ->journal_start
> > >  ->mpage_map_and_submit_extent -> may alloc some blocks
> > >    ->mpage_map_one_extent
> > >  ->journal_stop
> > > In case of delalloc block i_disksize may be less than i_size. So we have to
> > > update i_disksize each time we allocated and submitted some blocks beyond
> > > i_disksize. And we MUST update it in the same transaction, otherwise this
> > > result in fs-inconsistency in case of upcoming power-failure.
> > > 
> > > Another possible way to fix that issue is to insert inode to orhphan list
> > > on ext4_writepages entrance.
> > > 
> > > testcase: xfstest generic/019
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > Hi Dmitry, were you seeing generic/019 fail before this patch series?
> > I've been trying to build a kernel with CONFIG_FAIL_MAKE_REQUEST and I
> > haven't been able to get generic/019 to fail on me.  Is there
> > something else we need in order to reliably trigger the test fail?
> As usual this kind of test are not 100% reliable, I've saw failures from
> time to time. But I've assumed that it was side effect of incorrect
> error detection in e2fsck introduced d3f32c2db8f11, But this week i've
> rechecked e2fsck and found that condition was fixed and it is correct.
> In order to speedup testing I use ram dev:
> options brd rd_nr=4 rd_size=10485760 part_show=1
> TEST_DEV=/dev/ram0
> SCRATCH_DEV=/dev/ram1
> And run several rounds for this test:
> for ((i=0;i<20;i++));do ./check generic/019 || break ;done
> 
> You also can increase probability by playing with fsstress options
> --- a/tests/generic/019
> +++ b/tests/generic/019
> @@ -135,7 +135,7 @@ FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0
> -ffdatasync=0 -f setattr=1"
>  _workout()
>  {
>         out=$SCRATCH_MNT/fsstress.$$
> -       args=`_scale_fsstress_args -p 1 -n999999999 -f setattr=0
> $FSSTRESS_AVOID -d $out`
> +       args=`_scale_fsstress_args -p 8 -n999999999 -f setattr=0
> $FSSTRESS_AVOID -d $out`
>         echo ""
>         echo "Start fsstress.."
>         echo ""
> 
> And finally the cherry on top of this cake I've found that this test
> provoke orphan list corruption or dangling inodes after failure.
> fsck 1.43-WIP (09-Jul-2014)
> e2fsck 1.43-WIP (09-Jul-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Deleted inode 43792 has zero dtime.  Fix<y>? no
> Inodes that were part of a corrupted orphan linked list found.  Fix<y>?
> no
> Inode 493817 was part of the orphaned inode list.  IGNORED.
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -148712 -148714
> Fix<y>? no
> Inode bitmap differences:  -43792 -493817
> Fix<y>? no
> 
> /dev/ram1: ********** WARNING: Filesystem still has errors **********
> 
> /dev/ram1: 201244/655360 files (0.0% non-contiguous), 409632/10485760
> blocks
> [root@ts105 xfstests-dev.git2]# INO=493817
> [root@ts105 xfstests-dev.git2]# debugfs /dev/ram1 -R "ex <$INO>" ; \
>             debugfs /dev/ram1 -R "stat <$INO>" ; debugfs /dev/ram1 -R "ncheck $INO"
> debugfs 1.43-WIP (09-Jul-2014)
> Level Entries       Logical            Physical Length Flags
>  0/ 0   1/  1     0 -     0   148712 -   148712      1 
> debugfs 1.43-WIP (09-Jul-2014)
> Inode: 493817   Type: symlink    Mode:  0777   Flags: 0x80000
> Generation: 4038911591    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 638
> File ACL: 0    Directory ACL: 0
> Links: 0   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53fae8e8:ea861dc0 -- Mon Aug 25 11:42:32 2014
>  atime: 0x53fae8e8:ea861dc0 -- Mon Aug 25 11:42:32 2014
>  mtime: 0x53fae8e8:ea861dc0 -- Mon Aug 25 11:42:32 2014
> crtime: 0x53fae8e8:ea861dc0 -- Mon Aug 25 11:42:32 2014
> dtime: 0x0000ab10 -- Thu Jan  1 15:09:52 1970
> Size of extra inode fields: 28
> EXTENTS:
> (0):148712
> debugfs 1.43-WIP (09-Jul-2014)
> Inode   Pathname
> 
> I saw this effect with different file types (synmlink,chdev,regfile)
> From my findings we lost newly created inode during creation.
> Actually code is very simple, but at this moment I can not find why and
> where this happen.
I've had plenty of time to brain storm this issue :).
In fact it is very simple test-environment related issue.
Once we force make_request failure for all new IO requests
ext4_error will tag on-disk SB state with EXT4_ERROR_FS. In normal
situation this update should not reach permanent-storage, but in our
case updated EXT4_SB(sb)->s_sbh may be under writeback so ERROR_FS flag
will be visible on next mount and orphan_list cleanup will be skipped
due to ERROR_FS. Latest action is 100% correct.
It looks we have to fix the test by using another failure technique.
At this moment I think that faulty bcache may works for us. 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
