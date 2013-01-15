From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/5] libe2p: teach parse_num_blocks2() to return bytes if
 log_block_size < 0
Date: Tue, 15 Jan 2013 23:23:37 +0800
Message-ID: <20130115152337.GC19209@gmail.com>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
 <1358210232-30578-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:63864 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3AOPJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 10:09:49 -0500
Received: by mail-da0-f48.google.com with SMTP id k18so74692dae.7
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 07:09:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1358210232-30578-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 07:37:10PM -0500, Theodore Ts'o wrote:
> Previously the behavior of parse_num_block2 was undefined if
> log_block_size was less than zero.  It will now return a number in
> units of bytes.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng
> ---
>  lib/e2p/parse_num.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
> index d9ad3e7..cb0dc5b 100644
> --- a/lib/e2p/parse_num.c
> +++ b/lib/e2p/parse_num.c
> @@ -35,10 +35,16 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
>  		num <<= 10;
>  		/* fallthrough */
>  	case 'K': case 'k':
> -		num >>= log_block_size;
> +		if (log_block_size < 0)
> +			num <<= 10;
> +		else
> +			num >>= log_block_size;
>  		break;
>  	case 's':
> -		num >>= (1+log_block_size);
> +		if (log_block_size < 0)
> +			num << 1;
> +		else
> +			num >>= (1+log_block_size);
>  		break;
>  	case '\0':
>  		break;
> @@ -62,11 +68,21 @@ main(int argc, char **argv)
>  	unsigned long num;
>  	int log_block_size = 0;
>  
> -	if (argc != 2) {
> -		fprintf(stderr, "Usage: %s arg\n", argv[0]);
> +	if (argc != 2 && argc != 3) {
> +		fprintf(stderr, "Usage: %s arg [log_block_size]\n", argv[0]);
>  		exit(1);
>  	}
>  
> +	if (argc == 3) {
> +		char *p;
> +
> +		log_block_size = strtol(argv[2], &p, 0);
> +		if (*p) {
> +			fprintf(stderr, "Bad log_block_size: %s\n", argv[2]);
> +			exit(1);
> +		}
> +	}
> +
>  	num = parse_num_blocks(argv[1], log_block_size);
>  
>  	printf("Parsed number: %lu\n", num);
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
