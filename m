From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Add inline data support to
	iomap_readpage_actor
Date: Mon, 2 Jul 2018 14:52:30 +0200
Message-ID: <20180702125230.GB3366@lst.de>
References: <20180615130209.1970-2-hch@lst.de>
	<20180629144444.28826-1-agruenba@redhat.com>
	<20180701062141.GA27281@lst.de>
	<CAHc6FU4MAo4BXpKBAnP-abRJ1ZBN1RLZKO9KQzyk=L96PVY-iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHc6FU4MAo4BXpKBAnP-abRJ1ZBN1RLZKO9KQzyk=L96PVY-iA@mail.gmail.com>
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

On Sun, Jul 01, 2018 at 11:43:43PM +0200, Andreas Gruenbacher wrote:
> > +               WARN_ON_ONCE(plen != PAGE_SIZE);
> 
> Inline mappings only extend to the end of the file (iomap->offset == 0
> && iomap->length == inode->i_size), so length and plen will be
> inode->i_size here. This assertion should just be removed.

But we should generally still return PAGE_SIZE from iomap_begin
because we cover the whole page and zero the rest, don't we?

Either way, I can remove the assert from now.
