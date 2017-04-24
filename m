From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 10/20] fuse: set mapping error in
 writepage_locked when it fails
Date: Mon, 24 Apr 2017 18:04:31 +0200
Message-ID: <20170424160431.GK23988@quack2.suse.cz>
References: <20170424132259.8680-1-jlayton@redhat.com>
	<20170424132259.8680-11-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, hch@infradead.org,
	dhowells@redhat.com, linux-mm@kvack.org,
	linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	corbet@lwn.net, cluster-devel@redhat.com,
	v9fs-developer@lists.sourceforge.net,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, osd-dev@open-osd.org,
	axboe@kernel.dk, tytso@mit.edu, clm@fb.com,
	mawilcox@microsoft.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, jack@suse.com,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170424132259.8680-11-jlayton@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Mon 24-04-17 09:22:49, Jeff Layton wrote:
> This ensures that we see errors on fsync when writeback fails.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Hum, but do we really want to clobber mapping errors with temporary stuff
like ENOMEM? Or do you want to handle that in mapping_set_error?

								Honza

> ---
>  fs/fuse/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index ec238fb5a584..07d0efcb050c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1669,6 +1669,7 @@ static int fuse_writepage_locked(struct page *page)
>  err_free:
>  	fuse_request_free(req);
>  err:
> +	mapping_set_error(page->mapping, error);
>  	end_page_writeback(page);
>  	return error;
>  }
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
