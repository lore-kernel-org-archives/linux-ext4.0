From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v1] ext4:Make FIEMAP and delayed allocation play well
 together.
Date: Thu, 24 Feb 2011 11:17:13 -0600
Message-ID: <4D669299.1080200@redhat.com>
References: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1BXRRP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 12:17:15 -0500
In-Reply-To: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/24/2011 10:15 AM, Yongqiang Yang wrote:
> 1. lookup dirty pages with specified range in pagecache.
>    If no page is got, then there is no delayed-extent and
>    return with EXT_CONTINUE.
> 2. find the 1st mapped buffer,
> 3. check if the mapped buffer is both in the request range
>    and a delayed buffer. If not, there is no delayed-extent,
>    then return.
> 4. a delayed-extent is found, the extent will be collected.

...

looking better, I think - please run this through scripts/checkpatch.pl,
there are a lot of whitespace issues etc.

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |  183 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 144 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ccce8a7..710d46e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3778,42 +3778,155 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
>  /*
>   * Callback function called for each extent to gather FIEMAP information.
>   */
> +#define NR_PAGES_PER_TIME 128
> +
>  static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
>  		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
>  		       void *data)
>  {
> +	struct page *pages[NR_PAGES_PER_TIME];

This is going to be a problem... stack usage of this function has jumped
from 96 bytes to 1K with this change.  I don't think this
can live on the stack.

I'll take some time to read over the rest of this, though, thanks.
It does pass xfstests 225, which exercises fiemap, but with the sync flag.

-Eric
