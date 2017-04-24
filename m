From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 09/20] 9p: set mapping error when
 writeback fails in launder_page
Date: Mon, 24 Apr 2017 17:57:55 +0200
Message-ID: <20170424155755.GJ23988@quack2.suse.cz>
References: <20170424132259.8680-1-jlayton@redhat.com>
	<20170424132259.8680-10-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jfs-discussion@lists.sourceforge.net, neilb@suse.de, dhowells@redhat.com,
	linux-mm@kvack.org, linux-cifs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, corbet@lwn.net,
	cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, osd-dev@open-osd.org,
	axboe@kernel.dk, tytso@mit.edu, clm@fb.com,
	mawilcox@microsoft.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk
To: Jeff Layton <jlayton@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-10-jlayton@redhat.com>
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

On Mon 24-04-17 09:22:48, Jeff Layton wrote:
> launder_page is just writeback under the page lock. We still need to
> mark the mapping for errors there when they occur.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/9p/vfs_addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index adaf6f6dd858..7af6e6501698 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -223,8 +223,11 @@ static int v9fs_launder_page(struct page *page)
>  	v9fs_fscache_wait_on_page_write(inode, page);
>  	if (clear_page_dirty_for_io(page)) {
>  		retval = v9fs_vfs_writepage_locked(page);
> -		if (retval)
> +		if (retval) {
> +			if (retval != -EAGAIN)
> +				mapping_set_error(page->mapping, retval);
>  			return retval;
> +		}
>  	}
>  	return 0;
>  }
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
