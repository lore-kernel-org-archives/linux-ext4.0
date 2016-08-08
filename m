From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Date: Mon, 8 Aug 2016 20:28:27 +0200
Message-ID: <20160808182827.GI29128@quack2.suse.cz>
References: <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard>
 <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808092655.GA29128@quack2.suse.cz>
 <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org" <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
 "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Boylston, Brian" <brian.boylston-ZPxbGqLxI0U@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CS1PR84MB0119ACB424699154BDA197B28E1B0-v3YevoQr3hP2N4EGskIB0ticc1VoeDReZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
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

On Mon 08-08-16 12:30:18, Boylston, Brian wrote:
> Jan Kara wrote on 2016-08-08:
> > On Fri 05-08-16 19:58:33, Boylston, Brian wrote:
> >> Dave Chinner wrote on 2016-08-05:
> >>> [ cut to just the important points ]
> >>> On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> >>>> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> >>>>> If I drop the fsync from the
> >>>>> buffered IO path, bandwidth remains the same but runtime drops to
> >>>>> 0.55-0.57s, so again the buffered IO write path is faster than DAX
> >>>>> while doing more work.
> >>>> =

> >>>> I do not think the test results are relevant on this point because b=
oth
> >>>> buffered and dax write() paths use uncached copy to avoid clflush. =
=A0The
> >>>> buffered path uses cached copy to the page cache and then use uncach=
ed copy to
> >>>> PMEM via writeback. =A0Therefore, the buffered IO path also benefits=
 from using
> >>>> uncached copy to avoid clflush.
> >>> =

> >>> Except that I tested without the writeback path for buffered IO, so
> >>> there was a direct comparison for single cached copy vs single
> >>> uncached copy.
> >>> =

> >>> The undenial fact is that a write() with a single cached copy with
> >>> all the overhead of dirty page tracking is /faster/ than a much
> >>> shorter, simpler IO path that uses an uncached copy. That's what the
> >>> numbers say....
> >>> =

> >>>> Cached copy (req movq) is slightly faster than uncached copy,
> >>> =

> >>> Not according to Boaz - he claims that uncached is 20% faster than
> >>> cached. How about you two get together, do some benchmarking and get
> >>> your story straight, eh?
> >>> =

> >>>> and should be
> >>>> used for writing to the page cache. =A0For writing to PMEM, however,=
 additional
> >>>> clflush can be expensive, and allocating cachelines for PMEM leads t=
o evict
> >>>> application's cachelines.
> >>> =

> >>> I keep hearing people tell me why cached copies are slower, but
> >>> no-one is providing numbers to back up their statements. The only
> >>> numbers we have are the ones I've published showing cached copies w/
> >>> full dirty tracking is faster than uncached copy w/o dirty tracking.
> >>> =

> >>> Show me the numbers that back up your statements, then I'll listen
> >>> to you.
> >> =

> >> Here are some numbers for a particular scenario, and the code is below.
> >> =

> >> Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM buf=
fer
> >> (1M total memcpy()s).  For the cached+clflush case, the flushes are do=
ne
> >> every 4MiB (which seems slightly faster than flushing every 16KiB):
> >> =

> >>                   NUMA local    NUMA remote
> >> Cached+clflush      13.5           37.1
> >> movnt                1.0            1.3
> > =

> > Thanks for the test Brian. But looking at the current source of libpmem
> > this seems to be comparing apples to oranges. Let me explain the details
> > below:
> > =

> >> In the code below, pmem_persist() does the CLFLUSH(es) on the given ra=
nge,
> >> and pmem_memcpy_persist() does non-temporal MOVs with an SFENCE:
> > =

> > Yes. libpmem does what you describe above and the name
> > pmem_memcpy_persist() is thus currently misleading because it is not
> > guaranteed to be persistent with the current implementation of DAX in
> > the kernel.
> > =

> > It is important to know which kernel version and what filesystem have y=
ou
> > used for the test to be able judge the details but generally pmem_persi=
st()
> > does properly tell the filesystem to flush all metadata associated with=
 the
> > file, commit open transactions etc. That's the full cost of persistence.
> =

> I used NVML 1.1 for the measurements.  In this version and with the hardw=
are
> that I used, the pmem_persist() flow is:
> =

>   pmem_persist()
>     pmem_flush()
>       Func_flush() =3D=3D flush_clflush
>         CLFLUSH
>     pmem_drain()
>       Func_predrain_fence() =3D=3D predrain_fence_empty
>         no-op
> =

> So, I don't think that pmem_persist() does anything to cause the filesyst=
em
> to flush metadata as it doesn't make any system calls?

Ah, you are right. I somehow misread what is in NVML sources. I agree with
Christoph that _persist suffix is then misleading for the reasons he stated
but that's irrelevant to the test you did.

So it indeed seems that in your test movnt + sfence is an order of
magnitude faster than cached memcpy + cflush + sfence. I'm surprised I have
to say.

> > At which point
> > you've lost most of the advantages using movnt. Ross researches into
> > possibilities of allowing more efficient userspace implementation but
> > currently there are none.
> =

> Apart from the current performance discussion, if the metadata for a file
> is already established (file created, space allocated by explicit writes(=
),
> and everything synced), then if I map it and do pmem_memcpy_persist(),
> are there any "ongoing" metadata updates that would need to be flushed
> (besides timestamps)?

As Christoph wrote, currently there is no way for userspace to know and
filesystem may be doing all sorts of interesting stuff underneath that
userspace doesn't know about. The only obligation filesystem has is that in
response to fsync() it has to make sure all the data written before fsync()
is visible after a crash...

								Honza
-- =

Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
