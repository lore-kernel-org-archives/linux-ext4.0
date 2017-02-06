From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Date: Mon, 6 Feb 2017 09:30:22 -0800
Message-ID: <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org> <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matthew Wilcox <mawilcox@microsoft.com>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170206172731.GA17515@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
>> > Also can be use this opportunity
>> > to fold ->huge_fault into ->fault?
>>
>> Hmm, yes, just need a scheme to not attempt huge_faults on pte-only handlers.
>
> Do we need anything more than checking vma->vm_flags for VM_HUGETLB?

s/VM_HUGETLB/VM_HUGEPAGE/

...but yes as long as we specify that a VM_HUGEPAGE handler must
minimally handle pud and pmd.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
