From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3 v2] e2image: Add support for qcow2 format
Date: Mon, 16 May 2011 16:32:05 -0600
Message-ID: <0FCF10DD-DE65-46A2-913B-531BC397DDAC@dilger.ca>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com> <1305560604-31877-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:50713 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1EPWcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 18:32:07 -0400
In-Reply-To: <1305560604-31877-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 16, 2011, at 09:43, Lukas Czerner wrote:
> diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
> index 4de2c8d..a47f9e6 100644
> --- a/lib/ext2fs/e2image.h
> +++ b/lib/ext2fs/e2image.h
> @@ -12,6 +12,14 @@
> +/* Image types */
> +#define IMAGE_RAW	1
> +#define IMAGE_QCOW2	2
> +
> +/* Image flags */
> +#define INSTALL_FLAG	1
> +#define SCRAMBLE_FLAG	2
> +#define IS_QCOW2_FLAG	3

These should be given better names, with some prefix like "E2IMAGE_".

> diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
> new file mode 100644
> index 0000000..17eab38
> --- /dev/null
> +++ b/lib/ext2fs/qcow2.c
> @@ -0,0 +1,227 @@
> +/*
> + * qcow2.c --- Set of qcow2 related functions

It would be nice to have a better comment here.  I can see from the filename that this is related to "qcow2".  How about something like:

* Functions to generate qcow2 formatted disk images.  This format is used
* originally by QEMU for virtual machines, and stores the filesystem data
* on disk in a packed format to avoid creating sparse image files that need
* lots of seeking to read and write.
*
* The qcow2 format supports zlib compression, but that is not yet implemented.
*
* It is possible to directly mount a qcow2 image using qemu-nbd:
*
* [root]# modprobe nbd max_part=63
* [root]# qemu-nbd -c /dev/nbd0 image.img
* [root]# mount /dev/nbd0p1 /mnt/qemu
*
* Format details at http://people.gnome.org/~markmc/qcow-image-format.html

> +/* Functions for converting qcow2 image into raw image */
> +
> +struct ext2_qcow2_hdr *qcow2_read_header(int fd, char *fname)
> +{
> +	void *buffer = NULL;
> +	struct ext2_qcow2_hdr *hdr = NULL;
> +	size_t size;
> +
> +	buffer = malloc(sizeof(struct ext2_qcow2_hdr));

Because this will be linked into libext2fs, all of these functions should be converted to use the libext2 helper functions for portability reasons.

s/malloc(/,ext2fs_get_mem(/g

though in some places ext2fs_get_array() is preferable, since it does overflow checking.

> +	if (!buffer)
> +		return NULL;
> +	memset(buffer, 0, sizeof(struct ext2_qcow2_hdr));
> +
> +	if (lseek(fd, 0, SEEK_SET) < 0)
> +		return NULL;

This should instead use the built-in llseek:

s/lseek(/ext2fs_llseek(/g

> +	size = read(fd, buffer, sizeof(struct ext2_qcow2_hdr));

This should use io_channel_read_blk64()

> +	if (size != sizeof(struct ext2_qcow2_hdr)) {
> +		free(buffer);

s/free(/ext2fs_free_mem(/g

> +		return NULL;
> +	}
> +
> +	hdr = (struct ext2_qcow2_hdr *)(buffer);
> +
> +	if ((ext2fs_be32_to_cpu(hdr->magic) != QCOW_MAGIC) ||
> +	    (ext2fs_be32_to_cpu(hdr->version) != 2)) {
> +		free(hdr);
> +		return NULL;
> +	}
> +
> +	return hdr;
> +}
> +
> +static int qcow2_read_l1_table(struct ext2_qcow2_image *img)
> +{
> +	int fd = img->fd;
> +	size_t size, l1_size = img->l1_size * sizeof(__u64);
> +	__u64 *table;
> +
> +	table = calloc(1, l1_size);


> +	if (!table)
> +		return errno;
> +
> +	if (lseek(fd, img->l1_offset, SEEK_SET) < 0)
> +		return errno;
> +
> +	size = read(fd, table, l1_size);
> +	if (size != l1_size) {
> +		free(table);
> +		return errno;
> +	}
> +
> +	img->l1_table = table;
> +
> +	return 0;
> +}
> +
> +static int qcow2_read_l2_table(struct ext2_qcow2_image *img, off_t offset,
> +			    __u64 **l2_table)
> +{

Instead of "off_t" (which is not 64-bit clean) this should use "ext2_off64_t" for offset, and blk64_t for l2_table.  See also my other email about using more consistent types within libext2fs itself.

s/off_t/ext2_off64_t/g

> +	int fd = img->fd;
> +	size_t size;
> +
> +	assert(*l2_table);
> +
> +	if (lseek(fd, offset, SEEK_SET) < 0)
> +		return errno;
> +
> +	size = read(fd, *l2_table, img->cluster_size);
> +	if (size != img->cluster_size)
> +		return errno;
> +
> +	return 0;
> +}
> +
> +static int qcow2_copy_data(int fdin, int fdout, off_t off_in, off_t off_out,
> +			       void *buf, size_t count)
> +{
> +	size_t size;
> +
> +	assert(buf);
> +
> +	if (lseek(fdout, off_out, SEEK_SET) < 0)
> +		return errno;
> +
> +	if (lseek(fdin, off_in, SEEK_SET) < 0)
> +		return errno;
> +
> +	size = read(fdin, buf, count);
> +	if (size != count)
> +		return errno;
> +
> +	size = write(fdout, buf, count);
> +	if (size != count)
> +		return errno;
> +
> +	return 0;
> +}
> +
> +
> +int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
> +			      struct ext2_qcow2_hdr *hdr)
> +{
> +	struct ext2_qcow2_image img;
> +	int ret = 0;
> +	unsigned int l1_index, l2_index;
> +	off_t offset;
> +	__u64 *l1_table, *l2_table;
> +	void *copy_buf = NULL;
> +	size_t size;
> +
> +	img.fd = qcow2_fd;
> +	img.hdr = hdr;
> +	img.l2_cache = NULL;
> +	img.l1_table = NULL;
> +	img.cluster_bits = ext2fs_be32_to_cpu(hdr->cluster_bits);
> +	img.cluster_size = 1 << img.cluster_bits;
> +	img.l1_size = ext2fs_be32_to_cpu(hdr->l1_size);
> +	img.l1_offset = ext2fs_be64_to_cpu(hdr->l1_table_offset);
> +	img.l2_size = 1 << (img.cluster_bits - 3);
> +	img.image_size = ext2fs_be64_to_cpu(hdr->size);
> +
> +	l2_table = calloc(1, img.cluster_size);
> +	if (!l2_table) {
> +		ret = errno;
> +		goto out;
> +	}
> +
> +	copy_buf = calloc(1, 1 << img.cluster_bits);
> +	if (!copy_buf) {
> +		ret = errno;
> +		goto out;
> +	}
> +
> +	if (lseek(raw_fd, 0, SEEK_SET) < 0) {
> +		ret = errno;
> +		goto out;
> +	}
> +
> +	ret = qcow2_read_l1_table(&img);
> +	if (ret)
> +		goto out;
> +
> +	l1_table = img.l1_table;
> +	/* Walk through l1 table */
> +	for (l1_index = 0; l1_index < img.l1_size; l1_index++) {
> +		off_t off_out;
> +
> +		offset = ext2fs_be64_to_cpu(l1_table[l1_index]) &
> +			 ~QCOW_OFLAG_COPIED;
> +
> +		if ((offset > img.image_size) ||
> +		    (offset <= 0))
> +			continue;
> +
> +		ret = qcow2_read_l2_table(&img, offset, &l2_table);
> +		if (ret)
> +			break;
> +
> +		/* Walk through l2 table and copy data blocks into raw image */
> +		for (l2_index = 0; l2_index < img.l2_size; l2_index++) {
> +			offset = ext2fs_be64_to_cpu(l2_table[l2_index]) &
> +				 ~QCOW_OFLAG_COPIED;
> +
> +			if (offset == 0)
> +				continue;
> +
> +			off_out = (l1_index * img.l2_size) +
> +				  l2_index;
> +			off_out <<= img.cluster_bits;
> +			ret = qcow2_copy_data(qcow2_fd, raw_fd, offset,
> +					off_out, copy_buf, img.cluster_size);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +
> +	/* Resize the output image to the filesystem size */
> +	if (lseek(raw_fd, img.image_size, SEEK_SET) < 0)
> +		return errno;
> +
> +	size = write(raw_fd, copy_buf, 1);
> +	if (size != 1)
> +		return errno;
> +
> +out:
> +	if (copy_buf)
> +		free(copy_buf);
> +	if (img.l1_table)
> +		free(img.l1_table);
> +	if (l2_table)
> +		free(l2_table);
> +	return ret;
> +}

> diff --git a/lib/ext2fs/qcow2.h b/lib/ext2fs/qcow2.h
> new file mode 100644
> index 0000000..28eaac5
> --- /dev/null
> +++ b/lib/ext2fs/qcow2.h
> @@ -0,0 +1,94 @@
> +/*
> + * e2qcow.h --- 
> + *
> + * Copyright

This copyright line should be completed.

> diff --git a/misc/e2image.c b/misc/e2image.c
> index 003ac5a..6dc78d3 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c

> static void generic_write(int fd, char *buf, int blocksize, blk64_t block)

This function should probably just take "void *buf" instead of "char *buf".

> static void write_block(int fd, char *buf, int sparse_offset,
> 			int blocksize, blk64_t block)
> {
> #ifdef HAVE_LSEEK64
> -		if (lseek64(fd, sparse_offset, SEEK_CUR) < 0)
> -			perror("lseek");
> +		ret = lseek64(fd, sparse_offset, SEEK_CUR);
> #else
> -		if (lseek(fd, sparse_offset, SEEK_CUR) < 0)
> -			perror("lseek");
> +		ret = lseek(fd, sparse_offset, SEEK_CUR);
> #endif

This should just use ext2fs_llseek() as well.

> +static int initialize_qcow2_image(int fd, ext2_filsys fs,
> +			    struct ext2_qcow2_image *image)
> +{
> +	struct ext2_qcow2_hdr *header;
> +	blk64_t total_size, offset;
> +	int shift, l2_bits, header_size, l1_size, ret;
> +	int cluster_bits = get_bits_from_size(fs->blocksize);
> +	struct ext2_super_block *sb = fs->super;
> +
> +	/* Allocate header */
> +	header = malloc(sizeof(struct ext2_qcow2_hdr));
> +	if (!header)
> +		return errno;
> +	memset(header, 0, sizeof(struct ext2_qcow2_hdr));
> +
> +	total_size = ext2fs_blocks_count(sb) << cluster_bits;
> +	image->cluster_size = 1 << cluster_bits;

Isn't this just "fs->blocksize" again?

> +	image->l2_size = 1 << (cluster_bits - 3);
> +	image->cluster_bits = cluster_bits;
> +	image->fd = fd;
> +
> +	/* Make space for L1 table */
> +	offset += align_offset(l1_size * sizeof(blk64_t), image->cluster_size);
> +
> +	/* Initialize refcounting */
> +	ret = init_refcount(image, offset);
> +	if (ret)
> +		return ret;

This will leak "header" on error.

> +static void flush_l2_cache(struct ext2_qcow2_image *image)
> +{
> +	blk64_t offset, seek = 0;
> +	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
> +	struct ext2_qcow2_l2_table *table = cache->used_head;
> +	int fd = image->fd;
> +
> +	/* Store current position */
> +	if ((offset = lseek(fd, 0, SEEK_CUR)) < 0) {
> +		strerror(errno);
> +		exit(1);

Hmm, seems like a bit harsh for error handling?  I guess there isn't much to be done if the seek fails, and that is pretty unlikely.  However, exit(1) also makes it harder to ever use this code from within a program.

Also, the use of strerror(errno) in many places is just returning a pointer to a formatted string to the caller, and not actually printing anything that the user can see.  You were probably thinking of "perror()", but it would be better to print a more meaningful error than what perror will provide

		fprintf(stderr, "%s: unable to seek image file: %s\n",
			program_name, strerror(errno));

> +	while (cache->free < cache->count) {
> +		assert(table);

This assert() doesn't need to be inside the while loop.

> +static int add_l2_item(struct ext2_qcow2_image *img, blk64_t blk,
> +		       blk64_t data, blk64_t next)
> +{
> +	/*
> +	 * Need to create new table if it does not exist,
> +	 * or if it is full
> +	 * */

Strange formatting of comment?

> +static int update_refcount(int fd, struct ext2_qcow2_image *img,
> +			   blk64_t offset, blk64_t rfblk_pos)
> +{
> +		generic_write(fd, (char *)ref->refcount_block,
> +			      img->cluster_size, 0);
> +		memset((char *)ref->refcount_block, 0, img->cluster_size);

No need to cast to (char *) for memset.

> +static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
> +{
> +	errcode_t	retval;
> +	blk64_t		blk, datablk, offset, size, actual, end;
> +	char		*buf;
> +	int		sparse = 0;
> +	struct ext2_qcow2_image		*img;
> +	unsigned int		header_size, i;
> +	blk64_t		l1_index, l2_offset, l2_index;
> +	char *buffer;
> +	__u64 *l2_table;

It would be nice to align these variable declarations consistently.

> +	/* allocate  struct ext2_qcow2_image */
> +	img = malloc(sizeof(struct ext2_qcow2_image));
> +	if (!img) {
> +		com_err(program_name, ENOMEM, "while allocating "
> +					      "ext2_qcow2_image");

Probably nicer to write:

		com_err(program_name, ENOMEM,
			"while allocating ext2_qcow2_image");

> +		exit(1);
> +	}
> +
> +	retval = initialize_qcow2_image(fd, fs, img);
> +	if (retval) {
> +		com_err(program_name, retval, "while allocating initializing "
> +					   "ext2_qcow2_image");

Same.

> +	/* Write qcow2 data blocks */
> +	for (blk = 0; blk < ext2fs_blocks_count(fs->super); blk++) {
> +		if ((blk >= fs->super->s_first_data_block) &&
> +		    ext2fs_test_block_bitmap2(meta_block_map, blk)) {
> +			retval = io_channel_read_blk64(fs->io, blk, 1, buf);
> +			if (retval) {
> +				com_err(program_name, retval,
> +					"error reading block %llu", blk);
> +			}

What happens if this error is hit?  It doesn't make sense to continue using "buf", and I don't think com_err() does anything other than printing an error.

> +			if (update_refcount(fd, img, offset, offset)) {
> +				/*
> +				 * We have created the new refcount block, this
> +				 * means that we need to refcount it as well.So

Move "So" to next line.

> +				 * the prefious update_refcount refcounted the
> +				 * block itself and now we are going to create
> +				 * refcount for data. New refcount block should
> +				 * not be created!
> +				 */
> +				if (update_refcount(fd, img, offset, offset)) {
> +					fprintf(stderr, "Programming error\n");

Would be good to have a better error message here.

> +					if (update_refcount(fd, img, offset,
> +							    offset)) {
> +						fprintf(stderr, "Programming"
> +								"error\n");
> +						exit(1);

Same.

> @@ -649,16 +1251,23 @@ int main (int argc, char ** argv)
> +	while ((c = getopt(argc, argv, "rsIQ")) != EOF)
> 		switch (c) {
> 		case 'r':
> +			if (img_type)
> +				usage();
> +			img_type |= IMAGE_RAW;
> 			break;
> 		case 's':
> +			flags |= SCRAMBLE_FLAG;
> 			break;
> 		case 'I':
> +			flags |= INSTALL_FLAG;
> +			break;
> +		case 'Q':
> +			if (img_type)
> +				usage();
> +			img_type |= IMAGE_QCOW2;

It's always nicer if the command-line options are in alphabetical order, so that it is easier to add in new options.

Cheers, Andreas





