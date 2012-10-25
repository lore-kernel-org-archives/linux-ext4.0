From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] mm: print out information of file affected by
 memory error
Date: Thu, 25 Oct 2012 21:32:49 +0200
Message-ID: <20121025193249.GC3262@quack.suse.cz>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab2JYTcz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 15:32:55 -0400
Content-Disposition: inline
In-Reply-To: <1351177969-893-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-10-12 11:12:47, Naoya Horiguchi wrote:
> Printing out the information about which file can be affected by a
> memory error in generic_error_remove_page() is helpful for user to
> estimate the impact of the error.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/truncate.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git v3.7-rc2.orig/mm/truncate.c v3.7-rc2/mm/truncate.c
> index d51ce92..df0c6ab7 100644
> --- v3.7-rc2.orig/mm/truncate.c
> +++ v3.7-rc2/mm/truncate.c
> @@ -151,14 +151,20 @@ int truncate_inode_page(struct address_space *mapping, struct page *page)
>   */
>  int generic_error_remove_page(struct address_space *mapping, struct page *page)
>  {
> +	int ret;
> +	struct inode *inode = mapping->host;
> +
  This will oops if mapping == NULL. Currently the only caller seems to
check beforehand but still, it's better keep the code as robust as it it.

>  	if (!mapping)
>  		return -EINVAL;
>  	/*
>  	 * Only punch for normal data pages for now.
>  	 * Handling other types like directories would need more auditing.
>  	 */
> -	if (!S_ISREG(mapping->host->i_mode))
> +	if (!S_ISREG(inode->i_mode))
>  		return -EIO;
> +	pr_info("MCE %#lx: file info pgoff:%lu, inode:%lu, dev:%s\n",
> +		page_to_pfn(page), page_index(page),
> +		inode->i_ino, inode->i_sb->s_id);
>  	return truncate_inode_page(mapping, page);
>  }
>  EXPORT_SYMBOL(generic_error_remove_page);
  Otherwise the patch looks OK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
