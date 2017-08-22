From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Date: Tue, 22 Aug 2017 10:27:19 -0700
Message-ID: <CAPcyv4jpM_4fY+f+0i6ysnQ=0i2W9eq1pUCO0axYTHKbOtaufg@mail.gmail.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821215703.GA24473@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170821215703.GA24473-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Mon, Aug 21, 2017 at 2:57 PM, Ross Zwisler
<ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
>> Pretty crude for now...
>>
>> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
>
> One other thing that should probably be wired up before this is all said and
> done is the VmFlag string in /proc/<pid>/smaps.  Right now when we set this
> flag it ends up as ??:
>
> 7f44e6cbd000-7f44e6dbd000 rw-s 00000000 103:00 12              /root/dax/data
> Size:               1024 kB
> Rss:                   0 kB
> Pss:                   0 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         0 kB
> Referenced:            0 kB
> Anonymous:             0 kB
> LazyFree:              0 kB
> AnonHugePages:         0 kB
> ShmemPmdMapped:        0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> VmFlags: rd wr sh mr mw me ms ?? mm hg
>
> The quick one-liner at the end of this patch changes that to:
>
> 7fe30e87f000-7fe30e97f000 rw-s 00000000 103:00 12               /root/dax/data
> Size:               1024 kB
> Rss:                   0 kB
> Pss:                   0 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         0 kB
> Referenced:            0 kB
> Anonymous:             0 kB
> LazyFree:              0 kB
> AnonHugePages:         0 kB
> ShmemPmdMapped:        0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> VmFlags: rd wr sh mr mw me ms sf mm hg
>
> I think that of software can rely on this flag for userspace flushing without
> worrying about any new TOCTOU races because there isn't a way to unset the
> VM_SYNC flag once it is set - it should be valid as long as the mmap() remains
> open and the mmap'd address is valid.
>
> --- 8< ---
>  fs/proc/task_mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index b836fd6..a2a82ed 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -650,6 +650,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>                 [ilog2(VM_ACCOUNT)]     = "ac",
>                 [ilog2(VM_NORESERVE)]   = "nr",
>                 [ilog2(VM_HUGETLB)]     = "ht",
> +               [ilog2(VM_SYNC)]        = "sf",
>                 [ilog2(VM_ARCH_1)]      = "ar",
>                 [ilog2(VM_DONTDUMP)]    = "dd",
>  #ifdef CONFIG_MEM_SOFT_DIRTY

So, I'm not sure I agree with this. I'm explicitly *not* advertising
MAP_DIRECT in ->vm_flags in my patches because we've seen applications
try to use smaps as an API rather than a debug tool. The toctou race
is fundamentally unsolvable unless you trust the agent that setup the
mapping will not tear it down while you've observed the sync flag.
Otherwise, if you do trust that the mapping will not be torn down then
userspace can already just trust itself and not rely on the kernel to
communicate the flag state.

I'm not against adding it, but the reasoning should be for debug and
not an api guarantee that applications will rely on, and unfortunately
I think we've seen that applications will rely on smaps no matter how
we document it.
