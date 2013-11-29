From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Fri, 29 Nov 2013 09:00:25 +0100
Message-ID: <20131129080025.GC23954@quack.suse.cz>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20111209105616.5A4F.61FB500B@jp.fujitsu.com>
 <20111215214105.B2DD.61FB500B@jp.fujitsu.com>
 <CAGBYx2ZaccBFkLeTT9=V2k1Et4SAu60+JJQMTqTr4ZZy_vDPyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3K2IAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Nov 2013 03:00:30 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2ZaccBFkLeTT9=V2k1Et4SAu60+JJQMTqTr4ZZy_vDPyw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 29-11-13 12:58:29, Yongqiang Yang wrote:
> How is fthe bug fixed at last? I can not find the accepted patch.
  It was fixed by rewriting handling of freezing in VFS. That was rather
large patch series but the gut of the change is commit
5accdf82ba25cacefd6c1867f1704beb4d244cdd.

								Honza

> On Thu, Dec 15, 2011 at 8:41 PM, Masayoshi MIZUMA
> <m.mizuma@jp.fujitsu.com> wrote:
> >
> > (2011/12/09 10:56), Masayoshi MIZUMA wrote:
> >
> >>
> >> (2011/02/07 20:53), Masayoshi MIZUMA wrote:
> >>
> >> > Hi,
> >> >
> >> > When I checked the freeze feature for ext4 filesystem using fsfreeze command
> >> > at 2.6.38-rc3, I got the following messeges:
> >>
> >> Hi,
> >>
> >> I checked freeze function with using below test program at 3.2.0-rc4,
> >> then, I got following messeages and the test program hanged up.
> >> I think this bug is still in  3.2.0-rc4...
> >
> > I think the problem is as follows.
> > When a race between ext4_page_mkwrite() and freeze_super() occurs,
> > ext4_page_mkwrite() can add a inode to a list (bdi_writeback.b_dirty)
> > which is needed to do writeback nevertheless sb->s_frozen is SB_FREEZE_WRITE
> > or SB_FREEZE_TRANS.
> >
> >       process A               |     process B
> > ------------------------------+-----------------------------------------------
> > ext4_page_mkwrite()           |
> > => vfs_check_frozen()         |
> >                               | freeze_super()
> >                               | sb->s_frozen = SB_FREEZE_WRITE
> > =>__block_page_mkwrite()      | => sync_filesystem()
> >   :                           |    # write inodes which are in the list.
> >   :                           | sb->s_frozen = SB_FREEZE_TRANS
> >   :                           |
> >   =>__mark_inode_dirty        |
> >     # add inode to the list.  |
> > ------------------------------+-----------------------------------------------
> >
> > As the result, if "flush" kthread does writeback the inode which was
> > added by ext4_page_mkwrite() and thaw_super() runs concurrently, the
> > deadlock will happen.
> >
> > Thanks,
> > Masayoshi Mizuma
> >
> >>
> >> The test program:
> >> -----------------------------------------------------------
> >> #!/bin/bash
> >>
> >> DEV_1=/dev/sda5
> >> MNT_1=/tmp/sda5
> >> LOOP=500
> >>
> >> if [[ ! -d $MNT_1 ]]
> >> then
> >>         mkdir -p $MNT_1
> >> fi
> >>
> >> mkfs -t ext4 $DEV_1
> >> mount $DEV_1 $MNT_1
> >>
> >> ./fsstress -d $MNT_1/tmp -n 10000 -p 100 > /dev/null 2>&1 &
> >> PID=$!
> >>
> >> for ((i=0; i<LOOP; i++))
> >> do
> >>         echo LOOP: $i
> >>         fsfreeze -f $MNT_1
> >>         fsfreeze -u $MNT_1
> >> done
> >>
> >> kill $PID
> >> -----------------------------------------------------------
> >>
> >> The messages I got when I ran the test program is below.
> >> -------------------------------------------------------------
> >> INFO: task flush-8:0:720 blocked for more than 120 seconds.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> flush-8:0       D 0000000100521461     0   720      2 0x00000000
> >>  ffff8800b4c41a40 0000000000000046 0000000000000000 0000000000000000
> >>  0000000000013440 ffff8800b4c41fd8 ffff8800b4c40010 0000000000013440
> >>  ffff8800b4c41fd8 0000000000013440 ffffffff81a0d020 ffff8800b464d4e0
> >> Call Trace:
> >>  [<ffffffff81086b4e>] ? prepare_to_wait+0x5e/0x90
> >>  [<ffffffff814ee3ff>] schedule+0x3f/0x60
> >>  [<ffffffffa041e485>] ext4_journal_start_sb+0x145/0x1b0 [ext4]
> >>  [<ffffffff81086820>] ? wake_up_bit+0x40/0x40
> >>  [<ffffffffa0401bc5>] ? ext4_meta_trans_blocks+0xb5/0xc0 [ext4]
> >>  [<ffffffffa0406c9d>] ext4_da_writepages+0x29d/0x620 [ext4]
> >>  [<ffffffff81227a18>] ? blk_finish_plug+0x18/0x50
> >>  [<ffffffff81112bb1>] do_writepages+0x21/0x40
> >>  [<ffffffff8118e380>] writeback_single_inode+0x180/0x3b0
> >>  [<ffffffff8118e971>] writeback_sb_inodes+0x1a1/0x260
> >>  [<ffffffff8118ec6e>] wb_writeback+0xde/0x2b0
> >>  [<ffffffff810739c6>] ? try_to_del_timer_sync+0x86/0xe0
> >>  [<ffffffff8118eee6>] wb_do_writeback+0xa6/0x260
> >>  [<ffffffff81072ef0>] ? lock_timer_base+0x70/0x70
> >>  [<ffffffff8118f14a>] bdi_writeback_thread+0xaa/0x270
> >>  [<ffffffff8118f0a0>] ? wb_do_writeback+0x260/0x260
> >>  [<ffffffff8118f0a0>] ? wb_do_writeback+0x260/0x260
> >>  [<ffffffff810861a6>] kthread+0x96/0xa0
> >>  [<ffffffff814fa5b4>] kernel_thread_helper+0x4/0x10
> >>  [<ffffffff81086110>] ? kthread_worker_fn+0x1a0/0x1a0
> >>  [<ffffffff814fa5b0>] ? gs_change+0x13/0x13
> >>
> >> INFO: task fsstress:4376 blocked for more than 120 seconds.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> fsstress        D ffff88009b52dda8     0  4376   4364 0x00000080
> >>  ffff88009b52dcb8 0000000000000082 ffffffff810d7e09 ffff88009b52dcc0
> >>  0000000000013440 ffff88009b52dfd8 ffff88009b52c010 0000000000013440
> >>  ffff88009b52dfd8 0000000000013440 ffff88009b4d54e0 ffff8800a1481560
> >> Call Trace:
> >>  [<ffffffff810d7e09>] ? trace_clock_local+0x9/0x10
> >>  [<ffffffff814ee3ff>] schedule+0x3f/0x60
> >>  [<ffffffff814ee89d>] schedule_timeout+0x1fd/0x2e0
> >>  [<ffffffff810e5e43>] ? trace_nowake_buffer_unlock_commit+0x43/0x60
> >>  [<ffffffff810127e4>] ? __switch_to+0x194/0x320
> >>  [<ffffffff8104d623>] ? ftrace_raw_event_sched_switch+0x103/0x110
> >>  [<ffffffff814ee26d>] wait_for_common+0x11d/0x190
> >>  [<ffffffff8105a970>] ? try_to_wake_up+0x2b0/0x2b0
> >>  [<ffffffff814ee3bd>] wait_for_completion+0x1d/0x20
> >>  [<ffffffff8118daef>] writeback_inodes_sb_nr+0x7f/0xa0
> >>  [<ffffffff8118dbdf>] writeback_inodes_sb+0x5f/0x80
> >>  [<ffffffff811938d0>] ? __sync_filesystem+0x90/0x90
> >>  [<ffffffff8119388e>] __sync_filesystem+0x4e/0x90
> >>  [<ffffffff811938ef>] sync_one_sb+0x1f/0x30
> >>  [<ffffffff811695da>] iterate_supers+0x7a/0xd0
> >>  [<ffffffff81193934>] sys_sync+0x34/0x70
> >>  [<ffffffff814f8442>] system_call_fastpath+0x16/0x1b
> >> -------------------------------------------------------------
> >>
> >> The test program for xfstests is below.
> >> -------------------------------------------------------------
> >> #! /bin/bash
> >> # FSQA Test No. 277
> >> #
> >> # Run fsstress and  freeze/unfreeze in parallel
> >> #
> >> #-----------------------------------------------------------------------
> >> # Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
> >> #
> >> # This program is free software; you can redistribute it and/or
> >> # modify it under the terms of the GNU General Public License as
> >> # published by the Free Software Foundation.
> >> #
> >> # This program is distributed in the hope that it would be useful,
> >> # but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> # GNU General Public License for more details.
> >> #
> >> # You should have received a copy of the GNU General Public License
> >> # along with this program; if not, write the Free Software Foundation,
> >> # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> #
> >> #-----------------------------------------------------------------------
> >> #
> >> # creator
> >> owner=m.mizuma@jp.fujitsu.com
> >>
> >> seq=`basename $0`
> >> echo "QA output created by $seq"
> >>
> >> here=`pwd`
> >> tmp=/tmp/$$
> >> status=0        # success is the default!
> >> trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> >>
> >> # get standard environment, filters and checks
> >> . ./common.rc
> >> . ./common.filter
> >>
> >> _workout()
> >> {
> >>       echo ""
> >>       echo "Run fsstress"
> >>       echo ""
> >>       num_iterations=500
> >>       out=$SCRATCH_MNT/fsstress.$$
> >>       args="-p100 -n10000 -d $out"
> >>       echo "fsstress $args" >> $here/$seq.full
> >>       $FSSTRESS_PROG $args > /dev/null 2>&1 &
> >>       pid=$!
> >>       echo "Run xfs_freeze in parallel"
> >>       for ((i=0; i < num_iterations; i++))
> >>       do
> >>               xfs_freeze -f $SCRATCH_MNT | tee -a $seq.full
> >>               xfs_freeze -u $SCRATCH_MNT | tee -a $seq.full
> >>       done
> >>       kill $pid 2> /dev/null
> >>       wait $pid
> >> }
> >>
> >> # real QA test starts here
> >> _supported_fs generic
> >> _supported_os Linux
> >> _need_to_be_root
> >> _require_scratch
> >>
> >> _scratch_mkfs >> $seq.full 2>&1
> >> _scratch_mount
> >>
> >> if ! _workout; then
> >>       umount $SCRATCH_DEV 2>/dev/null
> >>       exit
> >> fi
> >>
> >> if ! _scratch_unmount; then
> >>       echo "failed to umount"
> >>       status=1
> >>       exit
> >> fi
> >> _check_scratch_fs
> >> status=$?
> >> exit
> >> -------------------------------------------------------------
> >>
> >> Thanks,
> >> Masayoshi Mizuma
> >>
> >> >
> >> > ---------------------------------------------------------------------
> >> > Feb  7 15:05:09 RX300S6 kernel: INFO: task fsfreeze:2104 blocked for more than 120 seconds.
> >> > Feb  7 15:05:09 RX300S6 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> > Feb  7 15:05:09 RX300S6 kernel: fsfreeze        D ffff880076d5f040     0  2104   2018 0x00000000
> >> > Feb  7 15:05:09 RX300S6 kernel: ffff88005a9f3d98 0000000000000086 ffff88005a9f3d38 ffffffff00000000
> >> > Feb  7 15:05:09 RX300S6 kernel: 0000000000014d40 ffff880076d5eab0 ffff880076d5f040 ffff88005a9f3fd8
> >> > Feb  7 15:05:09 RX300S6 kernel: ffff880076d5f048 0000000000014d40 ffff88005a9f2010 0000000000014d40
> >> > Feb  7 15:05:09 RX300S6 kernel: Call Trace:
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814aa5f5>] rwsem_down_failed_common+0xb5/0x140
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814aa693>] rwsem_down_write_failed+0x13/0x20
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff8122f1a3>] call_rwsem_down_write_failed+0x13/0x20
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814a9c12>] ? down_write+0x32/0x40
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81155b48>] thaw_super+0x28/0xd0
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81164338>] do_vfs_ioctl+0x368/0x560
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81157c73>] ? sys_newfstat+0x33/0x40
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff811645d1>] sys_ioctl+0xa1/0xb0
> >> > Feb  7 15:05:09 RX300S6 kernel: [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
> >> > ...
> >> > Feb  7 15:07:09 RX300S6 kernel: INFO: task flush-8:0:1409 blocked for more than 120 seconds.
> >> > Feb  7 15:07:09 RX300S6 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> > Feb  7 15:07:09 RX300S6 kernel: flush-8:0       D ffff880037777a30     0  1409      2 0x00000000
> >> > Feb  7 15:07:09 RX300S6 kernel: ffff880037c95a80 0000000000000046 ffff88007c8037a0 0000000000000000
> >> > Feb  7 15:07:09 RX300S6 kernel: 0000000000014d40 ffff8800377774a0 ffff880037777a30 ffff880037c95fd8
> >> > Feb  7 15:07:09 RX300S6 kernel: ffff880037777a38 0000000000014d40 ffff880037c94010 0000000000014d40
> >> > Feb  7 15:07:09 RX300S6 kernel: Call Trace:
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffffa00abb85>] ext4_journal_start_sb+0x75/0x130 [ext4]
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81082fc0>] ? autoremove_wake_function+0x0/0x40
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffffa0097f0a>] ext4_da_writepages+0x27a/0x640 [ext4]
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81102c91>] do_writepages+0x21/0x40
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff811776b8>] writeback_single_inode+0x98/0x240
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81177cfe>] writeback_sb_inodes+0xce/0x170
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178709>] writeback_inodes_wb+0x99/0x160
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178a8b>] wb_writeback+0x2bb/0x430
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e2c>] wb_do_writeback+0x22c/0x280
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178f32>] bdi_writeback_thread+0xb2/0x260
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e80>] ? bdi_writeback_thread+0x0/0x260
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e80>] ? bdi_writeback_thread+0x0/0x260
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81082936>] kthread+0x96/0xa0
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff8100cdc4>] kernel_thread_helper+0x4/0x10
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff810828a0>] ? kthread+0x0/0xa0
> >> > Feb  7 15:07:09 RX300S6 kernel: [<ffffffff8100cdc0>] ? kernel_thread_helper+0x0/0x10
> >> > ---------------------------------------------------------------------
> >> >
> >> > I think the following deadlock problem happened:
> >> >
> >> >               [flush-8:0:1409]              |          [fsfreeze:2104]
> >> > --------------------------------------------+--------------------------------
> >> > writeback_inodes_wb                         |
> >> >  pin_sb_for_writeback                       |
> >> >    down_read_trylock(&sb->s_umount)         |
> >> >  writeback_sb_inodes                        |thaw_super
> >> >    writeback_single_inode                   | down_write(&sb->s_umount)
> >> >      do_writepages                          |  # stop until flush-8:0 releases
> >> >       ext4_da_writepages                    |  # read lock of sb->s_umount...
> >> >        ext4_journal_start_sb                |
> >> >         vfs_check_frozen                    |
> >> >           wait_event((sb)->s_wait_unfrozen, |
> >> >            ((sb)->s_frozen < (level)))      |
> >> >             # stop until being waked up by  |
> >> >             # fsfreeze...                   |
> >> > --------------------------------------------+--------------------------------
> >> >
> >> > Could anyone check this problem?
> >> >
> >> > Thanks,
> >> > Masayoshi Mizuma
> >> >
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Best Wishes
> Yongqiang Yang
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
