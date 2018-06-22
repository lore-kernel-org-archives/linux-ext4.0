From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4: handle layout changes to pinned DAX mappings
Date: Fri, 22 Jun 2018 10:25:33 +0200
Message-ID: <20180622082533.biejwdtrn4tymiy4@quack2.suse.cz>
References: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
 <20180620221503.25237-3-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180620221503.25237-3-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Wed 20-06-18 16:15:03, Ross Zwisler wrote:
> diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
> index 0cb13badf473..a3b78241e9f6 100644
> --- a/fs/ext4/truncate.h
> +++ b/fs/ext4/truncate.h
> @@ -12,6 +12,7 @@
>  static inline void ext4_truncate_failed_write(struct inode *inode)
>  {
>  	down_write(&EXT4_I(inode)->i_mmap_sem);
> +	ext4_break_layouts(inode);
>  	truncate_inode_pages(inode->i_mapping, inode->i_size);
>  	ext4_truncate(inode);
>  	up_write(&EXT4_I(inode)->i_mmap_sem);

One comment here: I don't think ext4_break_layouts() is necessary here.
ext4_truncate_failed_write() exists to truncate blocks beyond EOF. As such
these blocks could never be even mmaped, let alone pinned by GUP. Maybe
just add a comment that blocks we are truncating here were never visible to
userspace and so we don't need ext4_break_layouts() protection.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
