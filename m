From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC v4+ hot_track 03/19] vfs: add I/O frequency update function
Date: Tue, 6 Nov 2012 23:37:04 +0100
Message-ID: <20121106223704.GT3102@twin.jikos.cz>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
 <1351485061-12297-4-git-send-email-zwu.kernel@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: zwu.kernel@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1351485061-12297-4-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 29, 2012 at 12:30:45PM +0800, zwu.kernel@gmail.com wrote:
> --- a/fs/hot_tracking.c
> +++ b/fs/hot_tracking.c
> +struct hot_inode_item
> +*hot_inode_item_find(struct hot_info *root, u64 ino)
> +{
> +	struct hot_inode_item *he;
> +	int ret;
> +
> +again:
> +	spin_lock(&root->lock);
> +	he = radix_tree_lookup(&root->hot_inode_tree, ino);
> +	if (he) {
> +		kref_get(&he->hot_inode.refs);
> +		spin_unlock(&root->lock);
> +		return he;
> +	}
> +	spin_unlock(&root->lock);
> +
> +	he = kmem_cache_zalloc(hot_inode_item_cachep,
> +				GFP_KERNEL | GFP_NOFS);
> +	if (!he)
> +		return ERR_PTR(-ENOMEM);
> +
> +	hot_inode_item_init(he, ino, &root->hot_inode_tree);
> +
> +	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
> +	if (ret) {
> +		kmem_cache_free(hot_inode_item_cachep, he);

		radix_tree_preload_end()

> +		return ERR_PTR(ret);
> +	}
> +
> +	spin_lock(&root->lock);
> +	ret = radix_tree_insert(&root->hot_inode_tree, ino, he);
> +	if (ret == -EEXIST) {
> +		kmem_cache_free(hot_inode_item_cachep, he);
> +		spin_unlock(&root->lock);
> +		radix_tree_preload_end();
> +		goto again;
> +	}
> +	spin_unlock(&root->lock);
> +	radix_tree_preload_end();
> +
> +	kref_get(&he->hot_inode.refs);
> +	return he;
> +}
> +EXPORT_SYMBOL_GPL(hot_inode_item_find);
> +
> +static struct hot_range_item
> +*hot_range_item_find(struct hot_inode_item *he,
> +			u32 start)
> +{
> +	struct hot_range_item *hr;
> +	int ret;
> +
> +again:
> +	spin_lock(&he->lock);
> +	hr = radix_tree_lookup(&he->hot_range_tree, start);
> +	if (hr) {
> +		kref_get(&hr->hot_range.refs);
> +		spin_unlock(&he->lock);
> +		return hr;
> +	}
> +	spin_unlock(&he->lock);
> +
> +	hr = kmem_cache_zalloc(hot_range_item_cachep,
> +				GFP_KERNEL | GFP_NOFS);
> +	if (!hr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	hot_range_item_init(hr, start, he);
> +
> +	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
> +	if (ret) {
> +		kmem_cache_free(hot_range_item_cachep, hr);

		radix_tree_preload_end()

> +		return ERR_PTR(ret);
> +	}
> +
> +	spin_lock(&he->lock);
> +	ret = radix_tree_insert(&he->hot_range_tree, start, hr);
> +	if (ret == -EEXIST) {
> +		kmem_cache_free(hot_range_item_cachep, hr);
> +		spin_unlock(&he->lock);
> +		radix_tree_preload_end();
> +		goto again;
> +	}
> +	spin_unlock(&he->lock);
> +	radix_tree_preload_end();
> +
> +	kref_get(&hr->hot_range.refs);
> +	return hr;
> +}

david
