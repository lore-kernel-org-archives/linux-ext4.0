From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Date: Fri, 5 Aug 2016 21:27:39 +1000
Message-ID: <20160805112739.GG16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard>
 <1470335997.8908.128.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 "xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org" <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
 "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470335997.8908.128.camel-ZPxbGqLxI0U@public.gmane.org>
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

[ cut to just the important points ]
On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> > If I drop the fsync from the
> > buffered IO path, bandwidth remains the same but runtime drops to
> > 0.55-0.57s, so again the buffered IO write path is faster than DAX
> > while doing more work.
> =

> I do not think the test results are relevant on this point because both
> buffered and dax write() paths use uncached copy to avoid clflush. =A0The
> buffered path uses cached copy to the page cache and then use uncached co=
py to
> PMEM via writeback. =A0Therefore, the buffered IO path also benefits from=
 using
> uncached copy to avoid clflush.

Except that I tested without the writeback path for buffered IO, so
there was a direct comparison for single cached copy vs single
uncached copy.

The undenial fact is that a write() with a single cached copy with
all the overhead of dirty page tracking is /faster/ than a much
shorter, simpler IO path that uses an uncached copy. That's what the
numbers say....

> Cached copy (req movq) is slightly faster than uncached copy,

Not according to Boaz - he claims that uncached is 20% faster than
cached. How about you two get together, do some benchmarking and get
your story straight, eh?

> and should be
> used for writing to the page cache. =A0For writing to PMEM, however, addi=
tional
> clflush can be expensive, and allocating cachelines for PMEM leads to evi=
ct
> application's cachelines.

I keep hearing people tell me why cached copies are slower, but
no-one is providing numbers to back up their statements. The only
numbers we have are the ones I've published showing cached copies w/
full dirty tracking is faster than uncached copy w/o dirty tracking.

Show me the numbers that back up your statements, then I'll listen
to you.

-Dave.
-- =

Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
