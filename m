From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 4/6] dax: export a low-level __dax_zero_page_range
	helper
Date: Thu, 12 May 2016 10:41:38 +0200
Message-ID: <20160512084138.GC10306@quack2.suse.cz>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
	<1463000932-31680-5-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>,
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1463000932-31680-5-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed 11-05-16 15:08:50, Vishal Verma wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> This allows XFS to perform zeroing using the iomap infrastructure and
> avoid buffer heads.
> 
> [vishal: fix conflicts with dax-error-handling]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

BTW: You are supposed to add your Signed-off-by when forwarding patches
like this...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
