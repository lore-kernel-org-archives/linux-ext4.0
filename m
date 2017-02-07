From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Date: Tue, 7 Feb 2017 10:08:11 -0800
Message-ID: <CAPcyv4h1+LbuG6K1Q=ERQ+52Ui12LBmZ4N5iEd96KfeqFy8AcA@mail.gmail.com>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
 <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org>
 <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
 <20170207084411.GA527@node.shutemov.name>
 <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
 <20170207174042.GB5578@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>,
 "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170207174042.GB5578-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
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

On Tue, Feb 7, 2017 at 9:40 AM, Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> On Tue, Feb 07, 2017 at 08:56:56AM -0800, Dan Williams wrote:
>> On Tue, Feb 7, 2017 at 12:44 AM, Kirill A. Shutemov
>> <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
>> > On Mon, Feb 06, 2017 at 09:30:22AM -0800, Dan Williams wrote:
>> >> On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> >> > On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
>> >> >> > Also can be use this opportunity
>> >> >> > to fold ->huge_fault into ->fault?
>> >
>> > BTW, for tmpfs we already use ->fault for both small and huge pages.
>> > If ->fault returned THP, core mm look if it's possible to map the page as
>> > huge in this particular VMA (due to size/alignment). If yes mm maps the
>> > page with PMD, if not fallback to PTE.
>> >
>> > I think it would be nice to do the same for DAX: filesystem provides core
>> > mm with largest page this part of file can be mapped with (base aligned
>> > address + lenght for DAX) and core mm sort out the rest.
>>
>> For DAX we would need plumb pfn_t into the core mm so that we have the
>> PFN_DEV and PFN_MAP flags beyond the raw pfn.
>
> Sounds good to me.
>
>> >> >> Hmm, yes, just need a scheme to not attempt huge_faults on pte-only handlers.
>> >> >
>> >> > Do we need anything more than checking vma->vm_flags for VM_HUGETLB?
>> >>
>> >> s/VM_HUGETLB/VM_HUGEPAGE/
>> >>
>> >> ...but yes as long as we specify that a VM_HUGEPAGE handler must
>> >> minimally handle pud and pmd.
>> >
>> > VM_HUGEPAGE is result of MADV_HUGEPAGE. It's not required to have THP in
>> > the VMA.
>>
>> Filesystem-DAX and Device-DAX specify VM_HUGEPAGE by default.
>
> But why? Looks like abuse of the flag.

Good question, that's been there since DAX was initially added and I
don't see a good reason for it currently. I'll take a look at what you
have for huge-tmpfs support.
