From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH,RFC 3/7] ext4: clear the dirty bit for a page in
	writeback at the last minute
Date: Sat, 12 Feb 2011 20:34:53 -0500
Message-ID: <20110213013452.GF19533@dhcp231-156.rdu.redhat.com>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu> <1297556157-21559-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1BMBjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 20:39:44 -0500
Content-Disposition: inline
In-Reply-To: <1297556157-21559-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 12, 2011 at 07:15:53PM -0500, Theodore Ts'o wrote:
> Move when we call clear_page_dirty_for_io() to just before we actually
> write the page.  This simplifies the code somewhat, and avoids marking
> pages as clean and then needing to remark them as dirty later.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |   28 +++++++++++-----------------
>  1 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e230f4f..3eca465 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2060,7 +2060,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  		if (nr_pages == 0)
>  			break;
>  		for (i = 0; i < nr_pages; i++) {
> -			int commit_write = 0, redirty_page = 0;
> +			int commit_write = 0, skip_page = 0;
>  			struct page *page = pvec.pages[i];
>  
>  			index = page->index;
> @@ -2086,14 +2086,12 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  			 * If the page does not have buffers (for
>  			 * whatever reason), try to create them using
>  			 * __block_write_begin.  If this fails,
> -			 * redirty the page and move on.
> +			 * skip the page and move on.
>  			 */
>  			if (!page_has_buffers(page)) {
>  				if (__block_write_begin(page, 0, len,
>  						noalloc_get_block_write)) {
> -				redirty_page:
> -					redirty_page_for_writepage(mpd->wbc,
> -								   page);
> +				skip_page:

Hmm so it looks like it's been done like this before.  I guess if thats the way
you want it then it's ok, I just find it hard to read.  Other than that this
looks good.  Thanks,

Josef
