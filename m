From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3 v2] e2image: Add support for qcow2 format
Date: Tue, 17 May 2011 13:08:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105171254420.3449@dhcp-27-109.brq.redhat.com>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com> <1305560604-31877-2-git-send-email-lczerner@redhat.com> <0FCF10DD-DE65-46A2-913B-531BC397DDAC@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab1EQLIe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 07:08:34 -0400
In-Reply-To: <0FCF10DD-DE65-46A2-913B-531BC397DDAC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas thanks for the review and useful comments.

On Mon, 16 May 2011, Andreas Dilger wrote:

> > diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
> > new file mode 100644
> > index 0000000..17eab38
> > --- /dev/null
> > +++ b/lib/ext2fs/qcow2.c
> > @@ -0,0 +1,227 @@
> > +/*
> > + * qcow2.c --- Set of qcow2 related functions
> 
> It would be nice to have a better comment here.  I can see from the filename that this is related to "qcow2".  How about something like:
> 
> * Functions to generate qcow2 formatted disk images.  This format is used
> * originally by QEMU for virtual machines, and stores the filesystem data
> * on disk in a packed format to avoid creating sparse image files that need
> * lots of seeking to read and write.
> *
> * The qcow2 format supports zlib compression, but that is not yet implemented.
> *
> * It is possible to directly mount a qcow2 image using qemu-nbd:
> *
> * [root]# modprobe nbd max_part=63
> * [root]# qemu-nbd -c /dev/nbd0 image.img
> * [root]# mount /dev/nbd0p1 /mnt/qemu
> *
> * Format details at http://people.gnome.org/~markmc/qcow-image-format.html

Very good, I will use it.

> 
> > +/* Functions for converting qcow2 image into raw image */
> > +
> > +struct ext2_qcow2_hdr *qcow2_read_header(int fd, char *fname)
> > +{
> > +	void *buffer = NULL;
> > +	struct ext2_qcow2_hdr *hdr = NULL;
> > +	size_t size;
> > +
> > +	buffer = malloc(sizeof(struct ext2_qcow2_hdr));
> 
> Because this will be linked into libext2fs, all of these functions should be converted to use the libext2 helper functions for portability reasons.
> 
> s/malloc(/,ext2fs_get_mem(/g
> 
> though in some places ext2fs_get_array() is preferable, since it does overflow checking.

I will change malloc to ext2fs_get_mem, but leave calloc as it is since
it will zero the memory as well unliki ext2fs_get_array().

> 
> > +	if (!buffer)
> > +		return NULL;
> > +	memset(buffer, 0, sizeof(struct ext2_qcow2_hdr));
> > +
> > +	if (lseek(fd, 0, SEEK_SET) < 0)
> > +		return NULL;
> 
> This should instead use the built-in llseek:
> 
> s/lseek(/ext2fs_llseek(/g
> 
> > +	size = read(fd, buffer, sizeof(struct ext2_qcow2_hdr));
> 
> This should use io_channel_read_blk64()

I do not think so, because there is no "real filesystem" on the qcow2
image, so there is no point of generating all the structures including
io_channel. I think that simple read is more than enough,
isn't it ? I do not see the benefit of it and also it reads block
aligned data only, which header is not.
 
> > +static void flush_l2_cache(struct ext2_qcow2_image *image)
> > +{
> > +	blk64_t offset, seek = 0;
> > +	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
> > +	struct ext2_qcow2_l2_table *table = cache->used_head;
> > +	int fd = image->fd;
> > +
> > +	/* Store current position */
> > +	if ((offset = lseek(fd, 0, SEEK_CUR)) < 0) {
> > +		strerror(errno);
> > +		exit(1);
> 
> Hmm, seems like a bit harsh for error handling?  I guess there isn't much to be done if the seek fails, and that is pretty unlikely.  However, exit(1) also makes it harder to ever use this code from within a program.
> 
> Also, the use of strerror(errno) in many places is just returning a pointer to a formatted string to the caller, and not actually printing anything that the user can see.  You were probably thinking of "perror()", but it would be better to print a more meaningful error than what perror will provide

There is not anything I can do if lseek fails. Note that this kind of error
handling is used in various places in e2image already. Also it is not a
library so I do not see why it should be used by other programs.

However you're right about strerror(), I really meant perror() :) Thanks.
But given that how unlikely will this happen on lseek() I'll just create new
helper which will print perror() and exit(1). I think this is more than
enough for this case, no need to write special err message for each
lseek in the e2image (there are a lot of them).

> Cheers, Andreas
> 

I'll resend the updated version shortly.

Thanks!
-Lukas
