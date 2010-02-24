From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Wed, 24 Feb 2010 22:36:17 +0100
Message-ID: <20100224213617.GA3097@quack.suse.cz>
References: <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
 <16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
 <baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
 <20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
 <877hq2tyg8.fsf@openvz.org>
 <4B855A97.4010702@redhat.com>
 <20100224170506.GN3687@quack.suse.cz>
 <87eikao896.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87eikao896.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 24-02-10 20:26:13, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Wed 24-02-10 10:57:59, Eric Sandeen wrote:
> >> Dmitry Monakhov wrote:
> >> > Jan Kara <jack@suse.cz> writes:
> >> >>> The fact is that I've been able to reproduce the problem on LVM block
> >> >>> devices, and sd* block devices so it's definitely not a loop device
> >> >>> specific problem.
> >> >>>
> >> >>> By the way, I tried several other things other than "echo s
> >> >>>> /proc/sysrq_trigger" I tried multiple sync followed with a one minute
> >> >>> "sleep",
> >> >>>
> >> >>> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
> >> >>> changes" but doesn't stops them.
> >> >>   Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
> >> >> /dev/loop0, I cannot reproduce the problem (was running the script for
> >> >> something like an hour).
> >> > Theoretically some pages may exist after rw=>ro remount
> >> > because of generic race between write/sync, And they will be written
> >> > in by writepage if page already has buffers. This not happen in ext4
> >> > because. Each time it try to perform writepages it try to start_journal
> >> > and this result in EROFS.
> >> > The race bug will be closed some day but new one may appear again.
> >> > 
> >> > Let's be honest and change ext3 writepage like follows:
> >> > - check ROFS flag inside write page
> >> > - dump writepage's errors.
> >> > 
> >> > 
> >> 
> >> sounds like the wrong approach to me, we really need to fix the root
> >> cause and make remount,ro finish the job, I think.
> Off course, but still. This is just a sanity check. Similar check
> in ext4 help me to find the generic issue. Off course it have to
> be guarded by unlikely() statement.
  Well I think that something like

  WARN_ON_ONCE(IS_RDONLY(inode));

  in the beginning of every ext3 writepage implementation would be totally
sufficient for catching such bugs. Plus it has the advantage that it won't
loose user's data if possible. So I'll take patch in this direction.

> >> Throwing away writes which an application already thinks are completed
> >> just because remount,ro didn't keep up sounds like a bad idea.  I think
> >> I would much rather have the write complete shortly after the readonly
> >> transition, if I had to choose...
> >   Well, my opinion is that VFS should take care about the rw->ro transition
> > so that it isn't racy...
> No, My patch just try to nail the RO semantics in to writepage.
> Since other places are already guarded by start_journal, writepage is
> the only one which may has weakness.
> About ENOSPC/EDQUOT spam. It may be not bad to print a error message
> for crazy person who use mmap for space file.
  I'm sorry but I disagree. We set the error in the mapping and return the
error in case user calls fsync() on the file. Now I agree that most
applications will just miss that but that's no excuse for us writing such
messages in the system log. The user just got what he told the system to
do.
  And yes, we could be nicer to applications by making sure at page-fault
time that we have space for the mmaped write. I actually have patches for
that but they are stuck in the queue behind Nick's
truncate-calling-sequence rewrite.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
