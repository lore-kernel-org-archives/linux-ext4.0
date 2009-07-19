From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/5] e4defrag: return more specific error message on ioctl
 failure
Date: Sun, 19 Jul 2009 16:36:31 -0500
Message-ID: <4A6391DF.3090105@redhat.com>
References: <1248025668-25901-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZGSVga (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 17:36:30 -0400
In-Reply-To: <1248025668-25901-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peng Tao wrote:
> Currently e4defrag relies on the EXT4_IOC_MOVE_EXT ioctl to perform online
> defragmentation. However, this iotcl kernel patch is not available before
> 2.6.30-rc1. e4defrag shall fail without obvious reasons on systems running
> older kernels. The patch adds more detailed error message addressing this
> issue and prompts users with the minimal kernel version that is needed to
> run e4defrag.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
>  misc/e4defrag.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index c25514a..f1c3008 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -1553,7 +1553,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
>  			if (mode_flag & DETAIL) {
>  				printf("\n");
>  				PRINT_ERR_MSG_WITH_ERRNO(
> -						"Failed to defrag");
> +					"Failed to defrag with "
> +					"EXT4_IOC_MOVE_EXT ioctl");
> +				if (errno == ENOTTY)
> +					printf("\tAt least 2.6.31-rc1 of"
> +						" vallina kernel is required\n");

Typo here, s/b "vanilla"

-Eric

>  			} else {
>  				printf("\t[ NG ]\n");
>  			}

