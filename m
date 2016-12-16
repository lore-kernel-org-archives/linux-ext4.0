From: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH] fscrypt: Factor out bio specific functions
Date: Fri, 16 Dec 2016 16:37:40 +0100
Message-ID: <72D4D0FB-F56D-4457-9660-4CFF7B4CFB6E@sigma-star.at>
References: <20161216105006.10207-1-richard@nod.at>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: rdunlap@infradead.org, tytso@mit.edu, arnd@arndb.de, dedekind1@gmail.com,
 ebiggers@google.com, linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
 hch@infradead.org, linux-mtd@lists.infradead.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
 linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20161216105006.10207-1-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> On 16.12.2016, at 11:50, Richard Weinberger <richard@nod.at> wrote:
> 
> That way we can get rid of the direct dependency on CONFIG_BLOCK.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> fs/crypto/Kconfig           |   1 -
> fs/crypto/Makefile          |   1 +
> fs/crypto/bio.c             | 115 ++++++++++++++++++++++++++++++++++++++++++++
> fs/crypto/crypto.c          |  89 ++--------------------------------
> fs/crypto/fscrypt_private.h |  14 ++++++
> include/linux/fscrypto.h    |   6 ++-
> 6 files changed, 137 insertions(+), 89 deletions(-)
> create mode 100644 fs/crypto/bio.c
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index f514978f6688..08b46e6e3995 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -1,6 +1,5 @@
> config FS_ENCRYPTION
> 	tristate "FS Encryption (Per-file encryption)"
> -	depends on BLOCK
> 	select CRYPTO
> 	select CRYPTO_AES
> 	select CRYPTO_CBC
> diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
> index f17684c48739..9f6607f17b53 100644
> --- a/fs/crypto/Makefile
> +++ b/fs/crypto/Makefile
> @@ -1,3 +1,4 @@
> obj-$(CONFIG_FS_ENCRYPTION)	+= fscrypto.o
> 
> fscrypto-y := crypto.o fname.o policy.o keyinfo.o
> +fscrypto-$(CONFIG_BLOCK) += bio.o
> diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
> new file mode 100644
> index 000000000000..6a6e694c6879
> --- /dev/null
> +++ b/fs/crypto/bio.c
> @@ -0,0 +1,115 @@
> +/*
> + * This contains encryption functions for per-file encryption.
> + *
> + * Copyright (C) 2015, Google, Inc.
> + * Copyright (C) 2015, Motorola Mobility
> + *
> + * Written by Michael Halcrow, 2014.
> + *
> + * Filename encryption additions
> + *	Uday Savagaonkar, 2014
> + * Encryption policy handling additions
> + *	Ildar Muslukhov, 2014
> + * Add fscrypt_pullback_bio_page()
> + *	Jaegeuk Kim, 2015.
> + *
> + * This has not yet undergone a rigorous security audit.
> + *
> + * The usage of AES-XTS should conform to recommendations in NIST
> + * Special Publication 800-38E and IEEE P1619/D16.
> + */
> +
> +#include <linux/pagemap.h>
> +#include <linux/module.h>
> +#include <linux/bio.h>
> +#include <linux/namei.h>
> +#include "fscrypt_private.h"
> +
> +/*
> + * Call fscrypt_decrypt_page on every single page, reusing the encryption
> + * context.
> + */
> +static void completion_pages(struct work_struct *work)
> +{
> +	struct fscrypt_ctx *ctx =
> +		container_of(work, struct fscrypt_ctx, r.work);
> +	struct bio *bio = ctx->r.bio;
> +	struct bio_vec *bv;
> +	int i;
> +
> +	bio_for_each_segment_all(bv, bio, i) {
> +		struct page *page = bv->bv_page;
> +		int ret = fscrypt_decrypt_page(page->mapping->host, page,
> +				PAGE_SIZE, 0, page->index);
> +
> +		if (ret) {
> +			WARN_ON_ONCE(1);
> +			SetPageError(page);
> +		} else {
> +			SetPageUptodate(page);
> +		}
> +		unlock_page(page);
> +	}
> +	fscrypt_release_ctx(ctx);
> +	bio_put(bio);
> +}
> +
> +void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio)
> +{
> +	INIT_WORK(&ctx->r.work, completion_pages);
> +	ctx->r.bio = bio;
> +	queue_work(fscrypt_read_workqueue, &ctx->r.work);
> +}
> +EXPORT_SYMBOL(fscrypt_decrypt_bio_pages);
> +
> +void fscrypt_pullback_bio_page(struct page **page, bool restore)
> +{
> +	struct fscrypt_ctx *ctx;
> +	struct page *bounce_page;
> +
> +	/* The bounce data pages are unmapped. */
> +	if ((*page)->mapping)
> +		return;
> +
> +	/* The bounce data page is unmapped. */
> +	bounce_page = *page;
> +	ctx = (struct fscrypt_ctx *)page_private(bounce_page);
> +
> +	/* restore control page */
> +	*page = ctx->w.control_page;
> +
> +	if (restore)
> +		fscrypt_restore_control_page(bounce_page);
> +}
> +EXPORT_SYMBOL(fscrypt_pullback_bio_page);
> +
> +int fscrypt_bio_submit_page(const struct inode *inode, sector_t blk,
> +			    struct page *page)
> +{
> +	struct bio *bio;
> +	int ret;
> +
> +	bio = bio_alloc(GFP_NOWAIT, 1);
> +	if (!bio) {
> +		ret = -ENOMEM;
> +		goto errout;
> +	}
> +	bio->bi_bdev = inode->i_sb->s_bdev;
> +	bio->bi_iter.bi_sector = blk << (inode->i_sb->s_blocksize_bits - 9);
> +	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> +	ret = bio_add_page(bio, page, inode->i_sb->s_blocksize, 0);
> +	if (ret != inode->i_sb->s_blocksize) {
> +		/* should never happen! */
> +		WARN_ON(1);
> +		bio_put(bio);
> +		ret = -EIO;
> +		goto errout;
> +	}
> +	ret = submit_bio_wait(bio);
> +	if ((ret == 0) && bio->bi_error)
> +		ret = -EIO;
> +	bio_put(bio);
> +
> +errout:
> +	return ret;
> +}
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index ac8e4f6a3773..3e981f0fd6e3 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -24,7 +24,6 @@
> #include <linux/module.h>
> #include <linux/scatterlist.h>
> #include <linux/ratelimit.h>
> -#include <linux/bio.h>
> #include <linux/dcache.h>
> #include <linux/namei.h>
> #include "fscrypt_private.h"
> @@ -44,7 +43,7 @@ static mempool_t *fscrypt_bounce_page_pool = NULL;
> static LIST_HEAD(fscrypt_free_ctxs);
> static DEFINE_SPINLOCK(fscrypt_ctx_lock);
> 
> -static struct workqueue_struct *fscrypt_read_workqueue;
> +struct workqueue_struct *fscrypt_read_workqueue;
> static DEFINE_MUTEX(fscrypt_init_mutex);
> 
> static struct kmem_cache *fscrypt_ctx_cachep;
> @@ -330,8 +329,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
> {
> 	struct fscrypt_ctx *ctx;
> 	struct page *ciphertext_page = NULL;
> -	struct bio *bio;
> -	int ret, err = 0;
> +	int err = 0;
> 
> 	BUG_ON(inode->i_sb->s_blocksize != PAGE_SIZE);
> 
> @@ -349,33 +347,10 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
> 		err = do_page_crypto(inode, FS_ENCRYPT, lblk,
> 					ZERO_PAGE(0), ciphertext_page,
> 					PAGE_SIZE, 0, GFP_NOFS);
> +		err = fscrypt_bio_submit_page(inode, pblk, ciphertext_page);

Any specific reason why you didn't just move the whole fscrypt_zeroout_range() to bio.c?
It's quite useless without having CONFIG_BLOCK=y. This also would then save you the
#ifdef CONFIG_BLOCK in fs/crypto/fscrypt_private.h below.

Apart from that, the rest looks good to me. :)

- David



> 		if (err)
> 			goto errout;
> 
> -		bio = bio_alloc(GFP_NOWAIT, 1);
> -		if (!bio) {
> -			err = -ENOMEM;
> -			goto errout;
> -		}
> -		bio->bi_bdev = inode->i_sb->s_bdev;
> -		bio->bi_iter.bi_sector =
> -			pblk << (inode->i_sb->s_blocksize_bits - 9);
> -		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> -		ret = bio_add_page(bio, ciphertext_page,
> -					inode->i_sb->s_blocksize, 0);
> -		if (ret != inode->i_sb->s_blocksize) {
> -			/* should never happen! */
> -			WARN_ON(1);
> -			bio_put(bio);
> -			err = -EIO;
> -			goto errout;
> -		}
> -		err = submit_bio_wait(bio);
> -		if ((err == 0) && bio->bi_error)
> -			err = -EIO;
> -		bio_put(bio);
> -		if (err)
> -			goto errout;
> 		lblk++;
> 		pblk++;
> 	}
> @@ -442,64 +417,6 @@ const struct dentry_operations fscrypt_d_ops = {
> };
> EXPORT_SYMBOL(fscrypt_d_ops);
> 
> -/*
> - * Call fscrypt_decrypt_page on every single page, reusing the encryption
> - * context.
> - */
> -static void completion_pages(struct work_struct *work)
> -{
> -	struct fscrypt_ctx *ctx =
> -		container_of(work, struct fscrypt_ctx, r.work);
> -	struct bio *bio = ctx->r.bio;
> -	struct bio_vec *bv;
> -	int i;
> -
> -	bio_for_each_segment_all(bv, bio, i) {
> -		struct page *page = bv->bv_page;
> -		int ret = fscrypt_decrypt_page(page->mapping->host, page,
> -				PAGE_SIZE, 0, page->index);
> -
> -		if (ret) {
> -			WARN_ON_ONCE(1);
> -			SetPageError(page);
> -		} else {
> -			SetPageUptodate(page);
> -		}
> -		unlock_page(page);
> -	}
> -	fscrypt_release_ctx(ctx);
> -	bio_put(bio);
> -}
> -
> -void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio)
> -{
> -	INIT_WORK(&ctx->r.work, completion_pages);
> -	ctx->r.bio = bio;
> -	queue_work(fscrypt_read_workqueue, &ctx->r.work);
> -}
> -EXPORT_SYMBOL(fscrypt_decrypt_bio_pages);
> -
> -void fscrypt_pullback_bio_page(struct page **page, bool restore)
> -{
> -	struct fscrypt_ctx *ctx;
> -	struct page *bounce_page;
> -
> -	/* The bounce data pages are unmapped. */
> -	if ((*page)->mapping)
> -		return;
> -
> -	/* The bounce data page is unmapped. */
> -	bounce_page = *page;
> -	ctx = (struct fscrypt_ctx *)page_private(bounce_page);
> -
> -	/* restore control page */
> -	*page = ctx->w.control_page;
> -
> -	if (restore)
> -		fscrypt_restore_control_page(bounce_page);
> -}
> -EXPORT_SYMBOL(fscrypt_pullback_bio_page);
> -
> void fscrypt_restore_control_page(struct page *page)
> {
> 	struct fscrypt_ctx *ctx;
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index aeab032d7d35..32a5b3598446 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -86,8 +86,22 @@ struct fscrypt_completion_result {
> 
> /* crypto.c */
> int fscrypt_initialize(unsigned int cop_flags);
> +extern struct workqueue_struct *fscrypt_read_workqueue;
> 
> /* keyinfo.c */
> extern int fscrypt_get_crypt_info(struct inode *);
> 
> +/* bio.c */
> +#ifdef CONFIG_BLOCK
> +extern int fscrypt_bio_submit_page(const struct inode *inode, sector_t blk,
> +				   struct page *page);
> +#else
> +static inline int fscrypt_bio_submit_page(const struct inode *inode,
> +					  sector_t blk, struct page *page)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +#endif
> +
> #endif /* _FSCRYPT_PRIVATE_H */
> diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
> index c074b670aa99..167b0dfd4e98 100644
> --- a/include/linux/fscrypto.h
> +++ b/include/linux/fscrypto.h
> @@ -174,8 +174,6 @@ extern struct page *fscrypt_encrypt_page(const struct inode *, struct page *,
> 						u64, gfp_t);
> extern int fscrypt_decrypt_page(const struct inode *, struct page *, unsigned int,
> 				unsigned int, u64);
> -extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
> -extern void fscrypt_pullback_bio_page(struct page **, bool);
> extern void fscrypt_restore_control_page(struct page *);
> extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
> 						unsigned int);
> @@ -201,6 +199,10 @@ extern int fscrypt_fname_disk_to_usr(struct inode *, u32, u32,
> 			const struct fscrypt_str *, struct fscrypt_str *);
> extern int fscrypt_fname_usr_to_disk(struct inode *, const struct qstr *,
> 			struct fscrypt_str *);
> +
> +/* bio.c */
> +extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
> +extern void fscrypt_pullback_bio_page(struct page **, bool);
> #endif
> 
> /* crypto.c */
> -- 
> 2.10.2
> 



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
