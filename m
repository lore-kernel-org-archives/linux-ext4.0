From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: play with 8TB to 16TB fs's better
Date: Wed, 9 Jan 2008 20:59:34 -0700
Message-ID: <20080110035934.GD3351@webber.adilger.int>
References: <20080108193325.GB3323@unused.rdu.redhat.com> <20080108230215.GI3351@webber.adilger.int> <20080109210438.GF3323@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53621 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYAJD7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 22:59:37 -0500
Content-Disposition: inline
In-Reply-To: <20080109210438.GF3323@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 09, 2008  16:04 -0500, Josef Bacik wrote:
> +static int valid_size(unsigned long long *size64, int blocksize)
> +{
> +	/* see if we are above 16tb */
> +	if ((*size64 / blocksize) > 0xFFFFFFFF) {
> +		/* if we are just at 16tb adjust the size slightly */

I'd change these comments to read "2^32 blocks" instead of "16TB" because
this is a different size with 1kB or 16kB blocks...

> +static int check_for_wrap(const char *file, int blocksize)
> +{
> +	int fd, tmp, total = 0;
> +	char buffer[blocksize];

I don't think this is ANSI-C to declare the stack variable size based
on a function parameter.  This instead should malloc() a buffer instead.
It probably makes sense to make it a unique non-zero pattern, just to
catch the case where the block is not read from disk, or is read from some
other spot on disk that IS zero.

> +#ifdef HAVE_OPEN64
> +	fd = open64(file, O_RDWR);
> +#else
> +	fd = open(file, O_RDWR);
> +#endif

It would be desirable to use the ext2fs_open() fs handle, and
io_channel_write_block() to do the write at block 2^31+1 to verify the libext2fs
code.  It appears the io_channel_{read,write}_block() code would at least work
with 64-bit offsets on 64-bit architectures, because it takes an unsigned long
as the block number...

The other issue is that none of the unix IO calls will be portable to the
other IO managers, and will circumvent the undo IO manager, so it is better
to use the normal io_channel_{read,write}_block().

> +	if (ext2fs_sync_device(fd, 1)) {
> +		fprintf(stderr, "Error flushing cache to disk %s\n", file);
> +		close(fd);
> +		exit(1);
> +	}

I'm not sure we need a sync+flush before the second write?

> +	memset(buffer, 0xa, blocksize);

It would be better to set this to some more unique pattern (e.g. current
time in first 8 bytes) to ensure there isn't some hold-over data from a
previous run or something.

> +	memset(buffer, 0xa, blocksize);

I don't think we need this second memset, since the buffer should still be
the existing non-zero data.

> +	for (tmp = 0; tmp < blocksize; tmp++) {
> +		if (buffer[tmp] != 0x0) {
> +			close(fd);
> +			return -1;
> +		}

Would probably be easier to just allocate a second buffer, copy it from
the original buffer at the beginning of the test, and then memcmp() it
against the block read from disk.
> +				com_err(program_name, retval, "Write wrapped, "
> +					"filesystem is too large for the disk "
> +					"to handle\n");
> +
> +		fprintf(stderr, "\nWarning: older 2.6 kernels (2.6.18 and "
> +			"older) may have problems with such a \n\tlarge "
> +			"filesystem.  If you have problems try a newer "
> +			"kernel\n");

Why are some messages com_err() and others fprintf()?  The content of the
message is good though.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
