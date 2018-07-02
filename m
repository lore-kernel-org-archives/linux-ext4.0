From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] iomap: Add inline data support to
	iomap_readpage_actor
Date: Mon, 2 Jul 2018 17:05:18 +0200
Message-ID: <CAHc6FU6vpbobB6fOFY5z8KvLdJC_5_zRGJMXBX9EZFkN1Z3=DQ@mail.gmail.com>
References: <20180615130209.1970-2-hch@lst.de>
	<20180629144444.28826-1-agruenba@redhat.com>
	<20180701062141.GA27281@lst.de>
	<CAHc6FU4MAo4BXpKBAnP-abRJ1ZBN1RLZKO9KQzyk=L96PVY-iA@mail.gmail.com>
	<20180702125230.GB3366@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180702125230.GB3366@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On 2 July 2018 at 14:52, Christoph Hellwig <hch@lst.de> wrote:
> On Sun, Jul 01, 2018 at 11:43:43PM +0200, Andreas Gruenbacher wrote:
>> > +               WARN_ON_ONCE(plen != PAGE_SIZE);
>>
>> Inline mappings only extend to the end of the file (iomap->offset == 0
>> && iomap->length == inode->i_size), so length and plen will be
>> inode->i_size here. This assertion should just be removed.
>
> But we should generally still return PAGE_SIZE from iomap_begin
> because we cover the whole page and zero the rest, don't we?

iomap_begin doesn't know when it's being called for readpage. Direct
I/O reads don't pad to the page size,  for example, so handling the
padding in the caller seems reasonable. If you compare with regular
block-based mappings, those are also block but not necessarily page
aligned.

For stuffed files, iomap_begin will return an IOMAP_HOLE mapping for
offsets beyond the end of the file, so iterating beyond the end of the
file is fine (even if readpage doesn't do that).

> Either way, I can remove the assert from now.

Yes, thanks.

Andreas
