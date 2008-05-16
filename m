From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 23:53:04 +0100
Message-ID: <20080516225304.GG15334@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <482E08E6.4030507@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> > Checking filesystem is hard.  Something systematic would be good - for
> > which you will want an electronically controlled power switch.
> 
> Right, that was the plan.  I wasn't really going to stand there and pull
> the plug.  :)  I'd like to get to "out of $NUMBER power-loss events
> under this usage, I saw $THIS corruption $THISMANY times ..."

That would be lovely.

> > If you just want to test the block I/O layer and drive itself, don't
> > use the filesystem, but write a program which just access the block
> > device, continuously writing with/without barriers every so often, and
> > after power cycle read back to see what was and wasn't written.
> 
> Well, I think it is worth testing through the filesystem, different
> journaling mechanisms will probably react^wcorrupt in different ways.

I agree, but intentional tests on the block device will show the
drives characteristcs on power failure much sooner and more
consistently.  Then you can concentrate on the worst drivers :-)

> > I think there may be drives which won't show any effect - if they have
> > enough internal power (from platter inertia) to write everything in
> > the cache before losing it.
> 
> ... and those with flux capacitors.  ;)  I've heard of this mechanism
> but I'm  not sure I believe it is present in any modern drive.  Not sure
> the seagates of the world will tell us, either ....

If you do the large-seek write pattern I suggested, and timing
confirms the drive is queueing many of them in cache, it will be
really, really clear if the drive has a flux capacitor or equivalent :-)

> > If you want to test, the worst case is to queue many small writes at
> > seek positions acrosss the disk, so that flushing the disk's write
> > cache takes the longest time.  A good pattern might be take numbers
> > 0..2^N-1 (e.g. 0..255), for each number reverse the bit order (0, 128,
> > 64, 192...) and do writes at those block positions, scaling up to the
> > range of the whole disk.  The idea is if the disk just caches the last
> > few queued, they will always be quite spread out.
> 
> I suppose we could go about it 2 ways; come up with something diabolical
> and  try very hard to break it (I think we know that we can) or do
> something more realistic (like untarring & building a kernel?) and see
> what happens in that case...

I would suggest one of the metadata intensive filesystem tests,
creating lots of files in different directories, that sort of thing.

> > The MacOS X folks decided that speed is most important for fsync().
> > fsync() does not guarantee commit to platter.  *But* they added an
> > fcntl() for applications to request a commit to platter, which SQLite
> > at least uses.  I don't know if MacOS X uses barriers for filesystem
> > operations.
> 
> heh,  reminds me of xfs's "osyncisosync" option ;)

VxFS have a few similar options ;-)

> >> and install by default on lvm which won't pass barriers anyway.
> > 
> > Considering how many things depend on LVM not passing barriers, that
> > is scary.  People use software RAID assuming integrity.  They are
> > immune to many hardware faults.  But it turns out, on Linux, that a
> > single disk can have higher integrity against power failure than a
> > RAID.
> 
> FWIW...  md also only does it on raid1... but lvm with a single device
> or mirror underneath really *should* IMHO...
>
> >> So maybe it's hypocritical to send this patch from redhat.com :)
> > 
> > So send the patch to fix LVM too :-)
> 
> hehe, I'll try ... ;)

Fwiw, if it were implemented in MD, the difference between barriers
and flushes could be worth having for performance, even when
underlying devices implement barriers with flush.

It would be good, especially for MT, to optimising away those
operations in unnecessary cases on underlying device request queues,
as well as the main MD queue.  An example is WRITE-BARRIER, usually
implemented as FLUSH, WRITE, FLUSH, can actually report completion
when the WRITE is finished, and doesn't need to issue the second FLUSH
at all for a long time, until there's a subsequent WRITE on that drive
(and on the same partition, fwiw.)

I'm increasingly thinking that decomposing WRITE-BARRIER to three
requests, FLUSH+WRITE+FLUSH, should be done at the generic I/O request
level, because that is the best place to optimise away, merge, or
delay unnecessary flushes, and to relax request ordering around them
if we ever do that.  (BARRIER would remain only as an op for extra
performance only on drivers which can do barriers another way; many
drivers would never see or handle it).

Since we need FLUSH for proper fsync() anyway, that would simplify
drivers too.

Then the MD patch could just implement FLUSH, which is probably
simpler than implementing WRITE-BARRIER.

-- Jamie
