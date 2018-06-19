From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap preparations for GFS2 v2
Date: Tue, 19 Jun 2018 16:35:50 +0200
Message-ID: <20180619143550.GA15162@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
	<CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
	<20180615080326.GB19525@lst.de>
	<5a1e303b-e96e-7faf-1bcd-36d63a237514@redhat.com>
	<CAHc6FU79WMraW95k-p_2x8GF_dtmDBST50D=3joYAua2KBtOqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHc6FU79WMraW95k-p_2x8GF_dtmDBST50D=3joYAua2KBtOqw@mail.gmail.com>
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

On Tue, Jun 19, 2018 at 01:08:12PM +0200, Andreas Gruenbacher wrote:
> What I'm seeing in the readpage address space operation is pages which
> are not PageUptodate(), with a page-size buffer head that is
> buffer_uptodate(). The filesystem doesn't bother keeping the page
> flags in sync with the buffer head flags, nothing unusual.

It is in fact highly unusual, as all the generic routines do set
the page uptodate once all buffers are uptodate.

> When
> iomap_readpage is called on such a page, it will replace the current
> contents with what's on disk, losing the changes in memory. So we
> cannot just call iomap_readpages, we need to check the buffer head
> flags as well. Or, since the old code is still needed for page size !=
> block size anyway, we can fall back to that for pages that have
> buffers for now.

I'd like to understand where that buffer_head comes from, something
seems fishy here.
