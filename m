From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/5] e2image: eliminate division by zero
Date: Fri, 03 Jan 2014 10:40:25 -0600
Message-ID: <52C6E7F9.8030809@redhat.com>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu> <1388726998-14349-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaACQk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 11:40:29 -0500
In-Reply-To: <1388726998-14349-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/2/14, 11:29 PM, Theodore Ts'o wrote:
> Dividing a floating point number by zero is undefined in C.  It
> happens to work with gcc/glibc, but it's not something that's
> guaranteed.
> 
> Addresses-Coverity-ID: #1147781
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>  misc/e2image.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 253fad1..ac62ffe 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -704,14 +704,15 @@ more_blocks:
>  	if (show_progress) {
>  		time_t duration = time(NULL) - start_time;
>  		char buff[30];
> -		while (bscount--)
> -			fputc('\b', stderr);
> +		fputc('\r', stderr);
>  		strftime(buff, 30, "%T", gmtime(&duration));
> -		fprintf(stderr, _("\b\b\b\b\b\b\b\bCopied %llu / %llu "
> -			 "blocks (%d%%) in %s at %.2f MB/s       \n"),
> -		       total_written, meta_blocks_count,
> -		       calc_percent(total_written, meta_blocks_count), buff,
> -		       calc_rate(total_written, fs->blocksize, duration));
> +		fprintf(stderr, _("Copied %llu / %llu blocks (%d%%) in %s "),
> +			total_written, meta_blocks_count,
> +			calc_percent(total_written, meta_blocks_count), buff);
> +		if (duration)
> +			fprintf(stderr, _("at %.2f MB/s"),
> +				calc_rate(total_written, fs->blocksize, duration));
> +		fputs("       \n", stderr);
>  	}
>  #ifdef HAVE_FTRUNCATE64
>  	if (sparse) {
> 

