From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 14 Sep 2011 15:24:54 +0900
Message-ID: <20110914152454.7F2B.61FB500B@jp.fujitsu.com>
References: <20110907173444.GF7725@quack.suse.cz> <CAD-Xujm80u_DeFd-edO7RL_6OozZ7mWsrX7auxVMtNbb0LZBOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAD-Xujm80u_DeFd-edO7RL_6OozZ7mWsrX7auxVMtNbb0LZBOw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


(2011/09/13 12:00), Valerie Aurora wrote:

> On Wed, Sep 7, 2011 at 10:34 AM, Jan Kara <jack@suse.cz> wrote:
> >  Hello,
> >
> >  Thanks for report!
> >
> > On Wed 07-09-11 12:29:30, Masayoshi MIZUMA wrote:
> >> When I checked the freeze feature for ext3 filesystem using fsfreeze
> >> command at 3.1.0-rc4, I think the following deadlock problem happened.
> >>
> >> How to reproduce:
> >>  # mkfs -t ext3 /dev/sdd1
> >>  # mount /dev/sdd1 /MNT
> >>  # ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
> >>  # fsfreeze -f /MNT
> >>  # fsfreeze -u /MNT
> >>
> >>  If this deadlock is reproduced, "fsfreeze -u /MNT" does not return.
> >>
> >> The detail of deadlock:
> >> o [flush-8:16:1523]
> >>   wb_do_writeback
> >>    wb_writeback
> >>    ...
> >>      ext3_journalled_writepage
> >>       journal_start
> >>        start_this_handle
> >>        # waiting until journal->j_barrier_count turns 0...
> >>        # j_barrier_count was incremented by journal_lock_updates()
> >>        # via ext3_freeze().
> >>
> >> o [fsstress:2673]
> >>   sys_sync
> >>    sync_filesystems
> >>     iterate_supers
> >>      down_read(sb->s_umount)
> >>      sync_one_sb
> >>       __sync_filesystem
> >>        writeback_inodes_sb
> >>         writeback_inodes_sb_nr
> >>          wait_for_completion
> >>           wait_for_common
> >>           # waiting for completion of [flush-8:16:1523]...
> >>
> >> o [fsfreeze:2749]
> >>   sys_ioctl
> >>    do_vfs_ioctl
> >>     thaw_super
> >>     # waiting for down_write(sb->s_umount)...
> >>     # [fsfreeze:2673] did down_read(sb->s_umount).
> > Yes, this is a classical deadlock that can happen for any filesystem. The
> > problem is flusher thread holds s_umount semaphore (either directly, or as
> > in your case, indirectly via blocked sync) and tries to do some IO which
> > blocks on frozen filesystem. It's particularly easy to hit for ext3 because
> > it doesn't do vfs_check_frozen() checks but all other filesystems have the
> > race window as well. Val Henson is working on fixing the problem - she even
> > has some first version of patches I believe.
> 
> Yes, if the bug reporter could test the patches I just sent out, that
> would be great.  I'm happy to resend privately.  Thanks!

I put your patches to 3.1.0-rc4 and tested it. Then, the deadlock was
not reproduced, so your patches work fine, thank you!

Masayoshi

> 
> -VAL


