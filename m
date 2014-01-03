From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/5] e2image: avoid potential divide by zero
Date: Fri, 03 Jan 2014 10:42:34 -0600
Message-ID: <52C6E87A.6030706@redhat.com>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu> <1388726998-14349-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaACQmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 11:42:39 -0500
In-Reply-To: <1388726998-14349-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/2/14, 11:29 PM, Theodore Ts'o wrote:
> It's highly unlikely after five seconds that zero blocks would have
> been written, but let's silence the Coverity warning.
> 
> Addresses-Coverity-ID: 1147780
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  misc/e2image.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index ac62ffe..6c51137 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -634,7 +634,7 @@ more_blocks:
>  			bscount = print_progress(total_written,
>  						 meta_blocks_count);
>  			duration = time(NULL) - start_time;
> -			if (duration > 5) {
> +			if (duration > 5 && total_written) {
>  				time_t est = (duration * meta_blocks_count /
>  					      total_written) - duration;
>  				char buff[30];
> 

