From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: add a page_done callback
Date: Tue, 17 Jul 2018 16:02:58 +0200
Message-ID: <20180717140258.GA18365@lst.de>
References: <20180619164137.13720-1-hch@lst.de>
	<20180619164137.13720-6-hch@lst.de>
	<20180713025853.xugxx6zte3kvvqjy@merlin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel@redhat.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180713025853.xugxx6zte3kvvqjy@merlin>
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

On Thu, Jul 12, 2018 at 09:58:53PM -0500, Goldwyn Rodrigues wrote:
> Would it be better if we keep this function as a part of iomap_ops? I
> know gfs2 sets this conditionally, but we can always check the condition
> in the function assigned to page_done(). It would keep all the functions
> in one place.

It works at a very different level than the other iomap ops.  We had
extensive discussions on previous versions, it should all be on
the list.
