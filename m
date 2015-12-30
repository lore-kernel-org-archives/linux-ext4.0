From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
Date: Wed, 30 Dec 2015 12:39:04 -0800
Message-ID: <CAPcyv4jAO-jJ3VCOJRCc7zrQULED362SdZ88dDgN+zfQQEsfsA@mail.gmail.com>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
	<56838FA3.5030909@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"J. Bruce Fields" <bfields@fieldses.org>, "Theodore Ts'o" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>,
	Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <willy@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>, X86 ML <x86@kernel.org>,
	XFS Developers <xfs@oss.sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
To: Bob Liu <bob.liu@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <56838FA3.5030909@oracle.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 30, 2015 at 12:02 AM, Bob Liu <bob.liu@oracle.com> wrote:
> Hi Ross,
>
> On 12/24/2015 03:39 AM, Ross Zwisler wrote:
>> Add support for tracking dirty DAX entries in the struct address_space
>> radix tree.  This tree is already used for dirty page writeback, and it
>> already supports the use of exceptional (non struct page*) entries.
>>
>> In order to properly track dirty DAX pages we will insert new exceptional
>> entries into the radix tree that represent dirty DAX PTE or PMD pages.
>
> I may get it wrong, but there is "struct page" for persistent memory after
> "[PATCH v4 00/18]get_user_pages() for dax pte and pmd mappings".
> So why not just add "struct page" to radix tree directly just like normal page cache?
>
> Then we don't need to deal with any exceptional entries and special writeback.

That "struct page" is optional and fsync/msync needs to operate in its absence.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
