From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3 v2] e2image: Support for conversion QCOW2 image into
 raw
Date: Tue, 17 May 2011 13:10:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105171308380.3449@dhcp-27-109.brq.redhat.com>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com> <1305560604-31877-3-git-send-email-lczerner@redhat.com> <B2AF03AA-06B3-49AA-9CB9-022D2B32A61F@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1EQLLA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 07:11:00 -0400
In-Reply-To: <B2AF03AA-06B3-49AA-9CB9-022D2B32A61F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 16 May 2011, Andreas Dilger wrote:

> On May 16, 2011, at 09:43, Lukas Czerner wrote:
> > diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
> > index 17eab38..9ac050b 100644
> > --- a/lib/ext2fs/qcow2.c
> > +++ b/lib/ext2fs/qcow2.c
> > @@ -209,9 +209,10 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
> > 	}
> > 
> > 	/* Resize the output image to the filesystem size */
> > -	if (lseek(raw_fd, img.image_size, SEEK_SET) < 0)
> > +	if (lseek(raw_fd, img.image_size - 1, SEEK_SET) < 0)
> > 		return errno;
> > 
> > +	memset(copy_buf, 0, 1);
> > 	size = write(raw_fd, copy_buf, 1);
> > 	if (size != 1)
> > 		return errno;
> 
> This should probably be part of the first patch.  Probably memset() is overkill here, just "copy_buf[0] = 0;" is enough.

Right, thanks.
> 
> > diff --git a/misc/e2image.c b/misc/e2image.c
> > index 6dc78d3..d749981 100644
> > --- a/misc/e2image.c
> > +++ b/misc/e2image.c
> > @@ -1229,16 +1229,33 @@ static void install_image(char *device, char *image_fn, int type)
> > 	exit (0);
> > }
> > 
> > +static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
> > +{
> > +
> > +#ifdef HAVE_OPEN64
> > +	*fd = open64(name, O_RDONLY, 0600);
> > +#else
> > +	*fd = open(name, O_RDONLY, 0600);
> > +#endif
> > +	if (*fd < 0)
> > +		return NULL;
> > +
> > +	return qcow2_read_header(*fd, name);
> 
> It probably makes sense to check the header here that it is not using AES encryption, and return an error (NULL?) if it is.  I don't think there is a flag in the header if compression is used, since that is only marked in each block.
> 
> > +	if (flags & IS_QCOW2_FLAG) {
> > +		ret = qcow2_write_raw_image(qcow2_fd, fd, header);
> 
> This also reminds me that qcow2_write_raw_image() should check the block numbers read from disk whether they point to zlib-compressed blocks, and return an error if they do, instead of just writing out the compressed data to disk.  Otherwise, some users might accidentally try to "restore" the qcow2 image created by some other tool and corrupt their filesystem.

I'll check for the encryption and compression in qcow2_write_raw_image()
so it can return an corresponding error code (QCOW_COMPRESSED,
QCOW_ENCRYPTED).

> 
> Cheers, Andreas

Once again thanks for the review!

-Lukas
