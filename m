From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ext4: correct partial write discard size calculation
Date: Tue, 06 Dec 2011 17:14:20 -0700
Message-ID: <4EDEAFDC.8000308@linux.vnet.ibm.com>
References: <1323209988-14304-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43912 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1LGAOt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Dec 2011 19:14:49 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 19:14:49 -0500
In-Reply-To: <1323209988-14304-1-git-send-email-apw@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andy,

We are currently doing some debugging in this region of the code, and 
the code that you are modifying here may need to come back out, but I 
will try your patch in my sand box too.  Thx!

Allison Henderson

On 12/06/2011 03:19 PM, Andy Whitcroft wrote:
> When copying large numbers of files we are seeing occasional write failures
> with errno EINVAL.  These are being returned from ext4_da_write_end()
> when attempting to discard the end portion of a partial write.  The error
> is detected and reported by the page index check below:
>
>      int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
> 		    struct inode *inode, struct page *page, loff_t from,
> 		    loff_t length, int flags)
>      {
>      [...]
>          if (index != page->index)
>                  return -EINVAL;
>      [...]
>
> This code was introduced by the commit below:
>
>    commit 02fac1297eb3f471a27368271aadd285548297b0
>    Author: Allison Henderson<achender@linux.vnet.ibm.com>
>    Date:   Tue Sep 6 21:53:01 2011 -0400
>
>      ext4: fix partial page writes
>
> This error is triggering when a write occurs at pos == 0 and results in
> 0 bytes being written (copied == 0):
>
>      page_len = PAGE_CACHE_SIZE -
>                      ((pos + copied - 1)&  (PAGE_CACHE_SIZE - 1));
>      if (page_len>  0) {
>              ret = ext4_discard_partial_page_buffers_no_lock(handle,
>                      inode, page, pos + copied - 1, page_len,
>      [...]
>
> In this case we will calculate that we need to clear out only one byte of
> the page.  As we are aligned at the page boundary and wrote 0 bytes we
> actually need to clear the entire page.  Also note that when we attempt
> to apply the discard we will apply it at offset -1 (0 + 0 - 1), which is
> the wrong place:
>
>      page_len = 4096 - ((0 + 0 - 1)&  4095)
>      page_len = 1
>
> Firstly fix up the offset calculation.  Once this is done the erroring
> case will correctly believe that the entire page needs to be discarded.
> However in this case we did not actually write to the page so the page
> is not instantiated and no discard is required.  So also only apply the
> discard where we are not discarding the entire page.
>
> Signed-off-by: Andy Whitcroft<apw@canonical.com>
> ---
>   fs/ext4/inode.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> This issue is most easily reproducible within a VM on a fast, lightly
> loaded host.  In that configuration I can trigger a failure with about
> 1/2GB of medium sized files (.debs in this case).  Without the patch
> the copy will fail 'EINVAL' 99% of the time, always failing within two
> iterations.  With the patch I have run 100 iterations of the same copy
> without failure.
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 240f6e2..c137168 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2533,11 +2533,11 @@ static int ext4_da_write_end(struct file *file,
>   							page, fsdata);
>
>   	page_len = PAGE_CACHE_SIZE -
> -			((pos + copied - 1)&  (PAGE_CACHE_SIZE - 1));
> +			((pos + copied)&  (PAGE_CACHE_SIZE - 1));
>
> -	if (page_len>  0) {
> +	if (page_len>  0&&  page_len<  PAGE_CACHE_SIZE) {
>   		ret = ext4_discard_partial_page_buffers_no_lock(handle,
> -			inode, page, pos + copied - 1, page_len,
> +			inode, page, pos + copied, page_len,
>   			EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
>   	}
>

