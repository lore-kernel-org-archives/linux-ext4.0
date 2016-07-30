From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Date: Fri, 29 Jul 2016 17:53:07 -0700
Message-ID: <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard> <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
 linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160730001249.GE16044@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 29, 2016 at 5:12 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Fri, Jul 29, 2016 at 07:44:25AM -0700, Dan Williams wrote:
>> On Thu, Jul 28, 2016 at 7:21 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>> > On Thu, Jul 28, 2016 at 10:10:33AM +0200, Jan Kara wrote:
>> >> On Thu 28-07-16 08:19:49, Dave Chinner wrote:
>> [..]
>> >> So DAX doesn't need flushing to maintain consistent view of the data but it
>> >> does need flushing to make sure fsync(2) results in data written via mmap
>> >> to reach persistent storage.
>> >
>> > I thought this all changed with the removal of the pcommit
>> > instruction and wmb_pmem() going away.  Isn't it now a platform
>> > requirement now that dirty cache lines over persistent memory ranges
>> > are either guaranteed to be flushed to persistent storage on power
>> > fail or when required by REQ_FLUSH?
>>
>> No, nothing automates cache flushing.  The path of a write is:
>>
>> cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
>>
>> The ADR mechanism and the wpq-flush facility flush data thorough the
>> imc (integrated memory controller) to media.  dax_do_io() gets writes
>> to the imc, but we still need a posted-write-buffer flush mechanism to
>> guarantee data makes it out to media.
>
> So what you are saying is that on and ADR machine, we have these
> domains w.r.t. power fail:
>
> cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
>
> |-------------volatile-------------------|-----persistent--------------|
>
> because anything that gets to the IMC is guaranteed to be flushed to
> stable media on power fail.
>
> But on a posted-write-buffer system, we have this:
>
> cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
>
> |-------------volatile-------------------------------------------|--persistent--|
>
> IOWs, only things already posted to the media via REQ_FLUSH are
> considered stable on persistent media.  What happens in this case
> when power fails during a media update? Incomplete writes?

Yes, power failure during a media update will end up with incomplete
writes on an 8-byte boundary.

>
>> > Or have we somehow ended up with the fucked up situation where
>> > dax_do_io() writes are (effectively) immediately persistent and
>> > untracked by internal infrastructure, whilst mmap() writes
>> > require internal dirty tracking and fsync() to flush caches via
>> > writeback?
>>
>> dax_do_io() writes are not immediately persistent.  They bypass the
>> cpu-cache and cpu-write-bufffer and are ready to be flushed to media
>> by REQ_FLUSH or power-fail on an ADR system.
>
> IOWs, on an ADR system  write is /effectively/ immediately persistent
> because if power fails ADR guarantees it will be flushed to stable
> media, while on a posted write system it is volatile and will be
> lost. Right?

Right.

>
> If so, that's even worse than just having mmap/write behave
> differently - now writes will behave differently depending on the
> specific hardware installed. I think this makes it even more
> important for the DAX code to hide this behaviour from the
> fielsystems by treating everything as volatile.

The symmetry does sound appealing...

> If we track the dirty blocks from write in the radix tree like we
> for mmap, then we can just use a normal memcpy() in dax_do_io(),
> getting rid of the slow cache bypass that is currently run. Radix
> tree updates are much less expensive than a slow memcpy of large
> amounts of data, ad fsync can then take care of persistence, just
> like we do for mmap.

If we go this route to increase the amount of dirty-data tracking in
the radix it raises the priority of one of the items on the backlog;
namely, determine the crossover point where wbinvd of the entire cache
is faster than a clflush / clwb loop.

> We should just make the design assumption that all persistent memory
> is volatile, track where we dirty it in all paths, and use the
> fastest volatile memcpy primitives available to us in the IO path.
> We'll end up with a faster fastpath that if we use CPU cache bypass
> copies, dax_do_io() and mmap will be coherent and synchronised, and
> fsync() will have the same requirements and overhead regardless of
> the way the application modifies the pmem or the hardware platform
> used to implement the pmem.

I like the direction, I'd still want to measure where/whether it's
actually faster given the writes may have evicted hot data, and the
amortized cost of the cache flushing loop.
