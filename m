From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/4 v3] e2image: Add support for qcow2 format
Date: Wed, 18 May 2011 14:59:39 -0600
Message-ID: <F49A0A47-D093-406E-8B50-00DDBEEA2194@dilger.ca>
References: <1305718615-5991-1-git-send-email-lczerner@redhat.com> <1305718615-5991-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:21971 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1ERU7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:59:40 -0400
In-Reply-To: <1305718615-5991-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 18, 2011, at 05:36, Lukas Czerner wrote:
> diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
> new file mode 100644
> index 0000000..7de72ed
> --- /dev/null
> +++ b/lib/ext2fs/qcow2.c

> +int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
> +			      struct ext2_qcow2_hdr *hdr)
> +{
> +	struct ext2_qcow2_image img;
> +	errcode_t ret = 0;
> +	unsigned int l1_index, l2_index;
> +	ext2_off64_t offset;
> +	blk64_t *l1_table, *l2_table;
> +	void *copy_buf = NULL;
> +	size_t size;
> +
> +	if (hdr->crypt_method)
> +		return -QCOW_ENCRYPTED;

Good.

> +	for (l1_index = 0; l1_index < img.l1_size; l1_index++) {
> +		ext2_off64_t off_out;
> +
> +		offset = ext2fs_be64_to_cpu(l1_table[l1_index]) &
> +			 ~QCOW_OFLAG_COPIED;
> +
> +		if ((offset > img.image_size) ||
> +		    (offset <= 0))
> +			continue;

Should this be considered an error, instead of just silently continuing?  At a minimum it should print an error to the user and return a non-zero value on exit, but I'm not sure whether it should abort because the user may care more about extracting _some_ data from the image instead of little or none.

Cheers, Andreas





