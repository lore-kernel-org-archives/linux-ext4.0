From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 17:21:26 -0500
Message-ID: <482E08E6.4030507@redhat.com>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080516220315.GB15334@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jamie Lokier wrote:
> Eric Sandeen wrote:
>>> If we were seeing a significant number of "hey, my disk got wrecked"
>>> reports which attributable to this then yes, perhaps we should change
>>> the default.  But I've never seen _any_, although I've seen claims that
>>> others have seen reports.
>> Hm, how would we know, really?  What does it look like?  It'd totally
>> depend on what got lost...  When do you find out?  Again depends what
>> you're doing, I think.  I'll admit that I don't have any good evidence
>> of my own.  I'll go off and do some plug-pull-testing and a benchmark or
>> two.
> 
> You have to pull the plug quite a lot, while there is data in write
> cache, and when the data is something you will notice later.
> 
> Checking filesystem is hard.  Something systematic would be good - for
> which you will want an electronically controlled power switch.

Right, that was the plan.  I wasn't really going to stand there and pull
the plug.  :)  I'd like to get to "out of $NUMBER power-loss events
under this usage, I saw $THIS corruption $THISMANY times ..."

> I have seen corruption which I believe is from lack of barriers, and
> hasn't occurred since I implemented them (or disabled write cache).
> But it's hard to be sure that was the real cause.
> 
> If you just want to test the block I/O layer and drive itself, don't
> use the filesystem, but write a program which just access the block
> device, continuously writing with/without barriers every so often, and
> after power cycle read back to see what was and wasn't written.

Well, I think it is worth testing through the filesystem, different
journaling mechanisms will probably react^wcorrupt in different ways.

> I think there may be drives which won't show any effect - if they have
> enough internal power (from platter inertia) to write everything in
> the cache before losing it.

... and those with flux capacitors.  ;)  I've heard of this mechanism
but I'm  not sure I believe it is present in any modern drive.  Not sure
the seagates of the world will tell us, either ....

> If you want to test, the worst case is to queue many small writes at
> seek positions acrosss the disk, so that flushing the disk's write
> cache takes the longest time.  A good pattern might be take numbers
> 0..2^N-1 (e.g. 0..255), for each number reverse the bit order (0, 128,
> 64, 192...) and do writes at those block positions, scaling up to the
> range of the whole disk.  The idea is if the disk just caches the last
> few queued, they will always be quite spread out.

I suppose we could go about it 2 ways; come up with something diabolical
and  try very hard to break it (I think we know that we can) or do
something more realistic (like untarring & building a kernel?) and see
what happens in that case...

> The MacOS X folks decided that speed is most important for fsync().
> fsync() does not guarantee commit to platter.  *But* they added an
> fcntl() for applications to request a commit to platter, which SQLite
> at least uses.  I don't know if MacOS X uses barriers for filesystem
> operations.

heh,  reminds me of xfs's "osyncisosync" option ;)

>> and install by default on lvm which won't pass barriers anyway.
> 
> Considering how many things depend on LVM not passing barriers, that
> is scary.  People use software RAID assuming integrity.  They are
> immune to many hardware faults.  But it turns out, on Linux, that a
> single disk can have higher integrity against power failure than a
> RAID.

FWIW...  md also only does it on raid1... but lvm with a single device
or mirror underneath really *should* IMHO...

>> So maybe it's hypocritical to send this patch from redhat.com :)
> 
> So send the patch to fix LVM too :-)

hehe, I'll try ... ;)

>> And as another "who uses barriers" datapoint, reiserfs & xfs both have
>> them on by default.
> 
> Are they noticably slower than ext3?  If not, it suggests ext3 can be
> fixed to keep its performance with barriers enabled.

Well it all depends on what you're testing (and the hardware you're
testing it on).  Between ext3 & xfs you can find plenty of tests which
will show either one or the other as faster.  And most benchmark results
out there probably don't state whether barriers were in force or not.

> Specifically: under some workloads, batching larger changes into the
> journal between commit blocks might compensate.  Maybe the journal has
> been tuned for barriers off because they are by default?
> 
>> I suppose alternately I could send another patch to remove "remember
>> that ext3/4 by default offers higher data integrity guarantees than
>> most." from Documentation/filesystems/ext4.txt  ;)
> 
> It would be fair.  I suspect a fair number of people are under the
> impression ext3 uses barriers with no special options, prior to this
> thread.  It was advertised as a feature in development during the 2.5
> series.

It certainly does come into play in benchmarking scenarios...

-Eric
