From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 17:19:58 -0800
Message-ID: <CAPcyv4hDNtVEHwzPMXe_sKLa0JqRv9d+PzvTbrCiaN=CsX2-DA@mail.gmail.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	<20151118170014.GB10656@linux.intel.com>
	<x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	<20151118182320.GA7901@linux.intel.com>
	<1447882389.21443.151.camel@hpe.com>
	<CAPcyv4g5LoOZH81JfB+xTKXs5cSxZogTfFUyQqq1U8h=aNrjuw@mail.gmail.com>
	<1447884281.21443.154.camel@hpe.com>
	<20151119003624.GA26287@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Ross Zwisler <ross.zwisler@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151119003624.GA26287@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 18, 2015 at 4:36 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Nov 18, 2015 at 03:04:41PM -0700, Toshi Kani wrote:
>> On Wed, 2015-11-18 at 13:57 -0800, Dan Williams wrote:
>> > On Wed, Nov 18, 2015 at 1:33 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>> > > I am seeing a similar/same problem in my test.  I think the problem is that
>> > > in
>> > > case of a WP fault, wp_huge_pmd() -> __dax_pmd_fault() ->
>> > > vmf_insert_pfn_pmd(),
>> > > which is a no-op since the PMD is mapped already.  We need WP handling for
>> > > this
>> > > PMD map.
>> > >
>> > > If it helps, I have attached change for follow_trans_huge_pmd().  I have not
>> > > tested much, though.
>> >
>> > Interesting, I didn't get this far because my tests were crashing the
>> > kernel.  I'll add this case the pmd fault test in ndctl.
>>
>> I hit this one with mmap(MAP_POPULATE).  With this change, I then hit the WP
>> fault loop when writing to the range.
>
> Here's a fix - please let me know if this seems incomplete or incorrect for
> some reason.
>
> -- >8 --
> From 02aa9f37d7ec9c0c38413f7e304b2577eb9f974a Mon Sep 17 00:00:00 2001
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> Date: Wed, 18 Nov 2015 17:15:09 -0700
> Subject: [PATCH] mm: Allow DAX PMD mappings to become writeable
>
> Prior to this change DAX PMD mappings that were made read-only were never able
> to be made writable again.  This is because the code in insert_pfn_pmd() that
> calls pmd_mkdirty() and pmd_mkwrite() would skip these calls if the PMD
> already existed in the page table.
>
> Instead, if we are doing a write always mark the PMD entry as dirty and
> writeable.  Without this code we can get into a condition where we mark the
> PMD as read-only, and then on a subsequent write fault we get into an infinite
> loop of PMD faults where we try unsuccessfully to make the PMD writeable.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  mm/huge_memory.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bbac913..1b3df56 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -877,15 +877,13 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>         spinlock_t *ptl;
>
>         ptl = pmd_lock(mm, pmd);
> -       if (pmd_none(*pmd)) {
> -               entry = pmd_mkhuge(pfn_pmd(pfn, prot));
> -               if (write) {
> -                       entry = pmd_mkyoung(pmd_mkdirty(entry));
> -                       entry = maybe_pmd_mkwrite(entry, vma);
> -               }
> -               set_pmd_at(mm, addr, pmd, entry);
> -               update_mmu_cache_pmd(vma, addr, pmd);
> +       entry = pmd_mkhuge(pfn_pmd(pfn, prot));
> +       if (write) {
> +               entry = pmd_mkyoung(pmd_mkdirty(entry));
> +               entry = maybe_pmd_mkwrite(entry, vma);
>         }
> +       set_pmd_at(mm, addr, pmd, entry);
> +       update_mmu_cache_pmd(vma, addr, pmd);
>         spin_unlock(ptl);

Hmm other paths that do pmd_mkwrite are using pmdp_set_access_flags()
and it's not immediately clear to me why.
