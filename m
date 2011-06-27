From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4:quiet 'unsed variables' compiling warnings.
Date: Mon, 27 Jun 2011 16:34:42 -0400
Message-ID: <20110627203442.GF2729@thunk.org>
References: <1308108420-13799-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51438 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1F0Uep (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 16:34:45 -0400
Content-Disposition: inline
In-Reply-To: <1308108420-13799-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 15, 2011 at 11:27:00AM +0800, Yongqiang Yang wrote:
> Delete unused variables.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 859f2ae..fece8c2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2860,7 +2860,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  {
>  	int bsbits, max;
>  	ext4_lblk_t end;
> -	loff_t size, orig_size, start_off;
> +	loff_t size, start_off;

Unfortunately, orig_size is being used by an mb_debug statement.  So
simply removing orig_size and its initialization will cause the build
to break if CONFIG_EXT4_DEBUG is enabled.

Can you resend this patch with this part of the patch removed?

Also, for future reference I prefer for consistency's sake that the
one-line summary be:

ext4: quiet 'used variables' compiling warnings

(note the space after "ext4: ", the lack of a ending period, and the
spelling correction for "unsed"; the other change which I will
commonly make for folks, again for consistency, is to make the first
word after "ext4: " lower case --- the summary does not have to be a
complete sentence, which is why I remove the trailing period)

Thanks,

						- Ted
