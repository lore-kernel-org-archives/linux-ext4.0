From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: dm: bind new table before destroying old
Date: Thu, 19 Nov 2009 07:49:52 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911190738270.30671@hs20-bc2-1.build.redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<20091111132056.GA28612@redhat.com> <20091111234555.GA24019@redhat.com>
	<20091119005036.GE6644@agk-dp.fab.redhat.com>
	<20091119025140.GA17829@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>,
	Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
To: linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091119025140.GA17829@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Wed, 18 Nov 2009, malahal@us.ibm.com wrote:

> Alasdair G Kergon [agk@redhat.com] wrote:
> > > After further testing I've hit a lockdep trace.  My testing was with
> > > handing over on the same device.  I had the snapshot (of an ext3 FS)
> > > mounted and I was doing a sequential direct-io write to a file in the
> > > FS.  While writing I triggered a handover with the following:
> > 
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.32-rc6-snitm #8
> > > -------------------------------------------------------
> > > dmsetup/1827 is trying to acquire lock:
> > >  (&md->suspend_lock){+.+...}, at: [<ffffffffa00678d8>] dm_swap_table+0x2d/0x249 [dm_mod]
> > > 
> > > but task is already holding lock:
> > >  (&journal->j_barrier){+.+...}, at: [<ffffffff8119192d>] journal_lock_updates+0xe1/0xf0
> > > 
> > > which lock already depends on the new lock.
> > 
> > I'm going to assume this is bogus - and I can't spot any annotations
> > available to suppress it, so people will just have to ignore it.
> > 
> > Suspend involves:
> >   get suspend lock
> >   if dev is not already suspended
> >     get journal lock
> >     set state "dev is suspended"
> >   release suspend lock
> >   
> > Resume involves
> >   [journal lock is held]
> >   get suspend lock
> >   if dev is suspended 
> >     release journal lock
> >     set state "dev is not suspended"
> >   release suspend lock
> > 
> > It looks as if lockdep sees that as a problem:
> >   Imagine those two sections running in parallel without the "Is dev
> >   suspended?" check, of which lockdep has no knowledge.
> 
> Agreed, but is it possible to restructure the suspend code such that it
> acquires the journal lock before the suspend lock, and then releases the
> journal lock if dev is already suspended? This needs some explaining
> in a comment form though! :-)
> 
> Thanks, Malahal.

The real reason for the warning is that ext3 jbd takes the mutex on 
suspend (ext3_freeze) and then keeps it taken until resume 
(ext3_unfreeze).

You also get a warning if you issue "dmsetup suspend" manually, it warns 
that a task exists with mutex held.

If suspending and resuming manually, suspend and resume are done from 
different processes, thus ext3 is violating mutex specification
Documentation/mutex-design.txt
* - only the owner can unlock the mutex
* - task may not exit with mutex held

It is really a bug in ext3 and ext4 and device mapper has nothing to do 
with it, except that it triggers it. The bug should be reported to ext[34] 
maintainers and fixed there.

Mikulas
