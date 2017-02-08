From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Date: Wed, 8 Feb 2017 09:41:56 +0100
Message-ID: <20170208084156.GD26317@quack2.suse.cz>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
 <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org>
 <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
 <20170207084411.GA527@node.shutemov.name>
 <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>,
 "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
 Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Tue 07-02-17 08:56:56, Dan Williams wrote:
> On Tue, Feb 7, 2017 at 12:44 AM, Kirill A. Shutemov
> <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> > On Mon, Feb 06, 2017 at 09:30:22AM -0800, Dan Williams wrote:
> >> On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >> > On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
> >> >> > Also can be use this opportunity
> >> >> > to fold ->huge_fault into ->fault?
> >
> > BTW, for tmpfs we already use ->fault for both small and huge pages.
> > If ->fault returned THP, core mm look if it's possible to map the page as
> > huge in this particular VMA (due to size/alignment). If yes mm maps the
> > page with PMD, if not fallback to PTE.
> >
> > I think it would be nice to do the same for DAX: filesystem provides core
> > mm with largest page this part of file can be mapped with (base aligned
> > address + lenght for DAX) and core mm sort out the rest.
> 
> For DAX we would need plumb pfn_t into the core mm so that we have the
> PFN_DEV and PFN_MAP flags beyond the raw pfn.

So we can pass necessary information through struct vm_fault rather easily.
However due to DAX locking we cannot really "return" pfn for generic code
to install (we need to unlock radix tree locks after modifying page
tables). So if we want generic code to handle PFNs what needs to be done is
to teach finish_fault() to handle pfn_t which is passed to it and install
it in page tables.

Long term we could transition all page fault handlers (at least the
non-trivial ones) to using finish_fault() which would IMO make the code
flow easier to follow and export less of MM internals into drivers. However
there's so many fault handlers that I didn't have a good motivation to do
that yet.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
