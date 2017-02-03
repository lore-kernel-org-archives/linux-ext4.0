From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Date: Fri, 3 Feb 2017 13:47:06 -0800
Message-ID: <CAPcyv4g4NBzE9B+-=uZD38NUd4HurCJUYDnOow7CZGppuJs8FQ@mail.gmail.com>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>,
	Vlastimil Babka <vbabka@suse.cz>
To: Dave Jiang <dave.jiang@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 3, 2017 at 1:31 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
> been somewhat painful with getting the flags set and removed at the
> correct locations. More than one kernel oops was introduced due to
> difficulties of getting the placement correctly. Removing the flag
> values and introducing an input parameter to huge_fault that indicates
> the size of the page entry. This makes the code easier to trace and
> should avoid the issues we see with the fault flags where removal of the
> flag was necessary in the fallback paths.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Tested-by: Dan Williams <dan.j.williams@intel.com>

This fixes a crash I can produce with the existing ndctl unit tests
[1] on next-20170202.  Now to go extend the tests to go after the PUD
case...

[1]: https://github.com/pmem/ndctl

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
