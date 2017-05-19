From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v4 05/27] btrfs:
 btrfs_wait_tree_block_writeback can be void return
Date: Thu, 18 May 2017 21:07:31 -0700
Message-ID: <20170519040731.GA30704@lim.localdomain>
References: <20170509154930.29524-1-jlayton@redhat.com>
	<20170509154930.29524-6-jlayton@redhat.com>
Reply-To: bo.li.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, hch@infradead.org,
	dhowells@redhat.com, linux-mm@kvack.org, hubcap@omnibond.com,
	linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	corbet@lwn.net, cluster-devel@redhat.com,
	v9fs-developer@lists.sourceforge.net,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	rpeterso@redhat.com, viro@zeniv.linux.org.uk, axboe@kernel.dk,
	linux-nfs@vger.kernel.org, tytso@mit.edu, clm@fb.com,
	mawilcox@microsoft.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170509154930.29524-6-jlayton@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Tue, May 09, 2017 at 11:49:08AM -0400, Jeff Layton wrote:
> Nothing checks its return value.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/btrfs/disk-io.c | 6 +++---
>  fs/btrfs/disk-io.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eb1ee7b6f532..8c479bd5534a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1222,10 +1222,10 @@ int btrfs_write_tree_block(struct extent_buffer *buf)
>  					buf->start + buf->len - 1);
>  }
>  
> -int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
> +void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
>  {
> -	return filemap_fdatawait_range(buf->pages[0]->mapping,
> -				       buf->start, buf->start + buf->len - 1);
> +	filemap_fdatawait_range(buf->pages[0]->mapping,
> +			        buf->start, buf->start + buf->len - 1);
>  }
>  
>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 2e0ec29bfd69..9cc87835abb5 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -127,7 +127,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
>  			extent_submit_bio_hook_t *submit_bio_done);
>  unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
>  int btrfs_write_tree_block(struct extent_buffer *buf);
> -int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
> +void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
>  int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
>  			     struct btrfs_fs_info *fs_info);
>  int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
> -- 
> 2.9.3
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
