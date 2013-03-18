From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] e2image: require that -a option is used only with
 raw or QCOW2 image
Date: Mon, 18 Mar 2013 10:42:05 -0500
Message-ID: <514735CD.7060002@redhat.com>
References: <1363425205-10970-1-git-send-email-tracek@redhat.com> <1363425205-10970-3-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab3CRPlz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 11:41:55 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IFftqo003884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2013 11:41:55 -0400
In-Reply-To: <1363425205-10970-3-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/16/13 4:13 AM, Tomas Racek wrote:
> All data cannot be included in normal image file so e2image should exit
> in this case.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  misc/e2image.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 6988c4d..b4e4cf9 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1295,6 +1295,13 @@ int main (int argc, char ** argv)
>  		}
>  	if (optind != argc - 2 )
>  		usage();
> +
> +	if(all_data && !img_type) {
          ^

nitpick, add space.  Can probably be fixed on merge, otherwise:

Also - what is the result today if -a is specified w/o -r or -Q?

The change itself looks good, though, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> +		com_err(program_name, 0, "-a option can only be used "
> +					 "with raw or QCOW2 images.");
> +		exit(1);
> +	}
> +
>  	device_name = argv[optind];
>  	image_fn = argv[optind+1];
>  
> 

