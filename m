From: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Date: Mon, 01 Aug 2016 13:13:45 +0300
Message-ID: <579F20D9.80107@plexistor.com>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com> <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz> <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 07/30/2016 03:12 AM, Dave Chinner wrote:
<>
> 
> If we track the dirty blocks from write in the radix tree like we
> for mmap, then we can just use a normal memcpy() in dax_do_io(),
> getting rid of the slow cache bypass that is currently run. Radix
> tree updates are much less expensive than a slow memcpy of large
> amounts of data, ad fsync can then take care of persistence, just
> like we do for mmap.
> 

No! 

mov_nt instructions, That "slow cache bypass that is currently run" above
is actually faster then cached writes by 20%, and if you add the dirty
tracking and cl_flush instructions it becomes x2 slower in the most
optimal case and 3 times slower in the DAX case.

The network guys have noticed the mov_nt instructions superior performance
for years before we pushed DAX into the tree. look for users of copy_from_iter_nocache
and the comments when they where introduced, those where used before DAX, and
nothing at all to do with persistence.

So what you are suggesting is fine only 3 times slower in the current
implementation.

> We should just make the design assumption that all persistent memory
> is volatile, track where we dirty it in all paths, and use the
> fastest volatile memcpy primitives available to us in the IO path.

The "fastest volatile memcpy primitives available" is what we do
today with the mov_nt instructions.

> We'll end up with a faster fastpath that if we use CPU cache bypass
> copies, dax_do_io() and mmap will be coherent and synchronised, and
> fsync() will have the same requirements and overhead regardless of
> the way the application modifies the pmem or the hardware platform
> used to implement the pmem.
> 

I measured, there is tests running in our labs every night, your
suggestion on an ADR system is 3 times slower to reach persistence.

Is why I was pushing for MMAP_PMEM_AWARE, because a smart mmap application
from user-mode uses mov_nt anyway because it wants that 20% gain regardless
of what the Kernel will do. Then it calls fsync() and the Kernel will burn
x2 more CPU, just for the sake of burning CPU, because the data is already
persistent at the get go.

> Cheers,
> Dave.

As you, I do not care for DAX very much, but please lets keep the physical
facts strait

Cheers indeed
Boaz
