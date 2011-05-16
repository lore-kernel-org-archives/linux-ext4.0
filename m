From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3 v2] e2image: Support for conversion QCOW2 image into raw
Date: Mon, 16 May 2011 16:45:37 -0600
Message-ID: <B2AF03AA-06B3-49AA-9CB9-022D2B32A61F@dilger.ca>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com> <1305560604-31877-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45954 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1EPWpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 18:45:38 -0400
In-Reply-To: <1305560604-31877-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 16, 2011, at 09:43, Lukas Czerner wrote:
> diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
> index 17eab38..9ac050b 100644
> --- a/lib/ext2fs/qcow2.c
> +++ b/lib/ext2fs/qcow2.c
> @@ -209,9 +209,10 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
> 	}
> 
> 	/* Resize the output image to the filesystem size */
> -	if (lseek(raw_fd, img.image_size, SEEK_SET) < 0)
> +	if (lseek(raw_fd, img.image_size - 1, SEEK_SET) < 0)
> 		return errno;
> 
> +	memset(copy_buf, 0, 1);
> 	size = write(raw_fd, copy_buf, 1);
> 	if (size != 1)
> 		return errno;

This should probably be part of the first patch.  Probably memset() is overkill here, just "copy_buf[0] = 0;" is enough.

> diff --git a/misc/e2image.c b/misc/e2image.c
> index 6dc78d3..d749981 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1229,16 +1229,33 @@ static void install_image(char *device, char *image_fn, int type)
> 	exit (0);
> }
> 
> +static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
> +{
> +
> +#ifdef HAVE_OPEN64
> +	*fd = open64(name, O_RDONLY, 0600);
> +#else
> +	*fd = open(name, O_RDONLY, 0600);
> +#endif
> +	if (*fd < 0)
> +		return NULL;
> +
> +	return qcow2_read_header(*fd, name);

It probably makes sense to check the header here that it is not using AES encryption, and return an error (NULL?) if it is.  I don't think there is a flag in the header if compression is used, since that is only marked in each block.

> +	if (flags & IS_QCOW2_FLAG) {
> +		ret = qcow2_write_raw_image(qcow2_fd, fd, header);

This also reminds me that qcow2_write_raw_image() should check the block numbers read from disk whether they point to zlib-compressed blocks, and return an error if they do, instead of just writing out the compressed data to disk.  Otherwise, some users might accidentally try to "restore" the qcow2 image created by some other tool and corrupt their filesystem.

Cheers, Andreas





