From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v4 0/4] ext4 crypto: backup and restore encrypted files
Date: Wed, 16 Dec 2015 17:46:04 -0500
Message-ID: <1450305968-21785-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50782 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbbLPWqW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 17:46:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These patches allow backing up and restoring encrypted files without
having access to the key.  To do this we add four ioctls; two to
backup and restore the encryption metadata, and two to backup and
restore the encrypted filename.

One tricky bit is that if the file's i_size is not a multiple of the
AES block size, we need to be able to copy the bytes between i_size
and the end of the block, since they contain the ciphertext
bytes of the zeros between EOF and the end of the block.

There are two ways of solving this.  One would be an new DIO_FLAG that
rounds i_size up to the file system blocksize, which we would pass
when reading encrypted files using O_DIRECT.  This would require
changes to the core direct I/O, and may be controversial.  It also may
make it more difficult to back port these patches to ancient BSP
kernels.

So what we're doing for now is admittedly a hack.  Since encrypted
files are read-only without access to the key, it is safe to create a
shadow copy of the inode structure, and round up i_size to the end of
the block in the shadow inode.  We only do this when reading
the last block in the file, so the overhead shouldn't be too bad.

The original i_size is returned as part of the encryption metadata
returned by EXT4_IOC_GET_ENCRYPTION_METADATA and when the encryption
metadata is set using EXT4_IOC_GET_ENCRYPTION_METADATA, the i_size
will be restored to its original value.

Changes from v3:
 - Add EXT4_IOC_SET_ENCRYPTED_FILENAME ioctl which will restore the
   encrypted hard link.
 - Add mnt_want_write_file() and mnt_drop_write_file() calls.
 - Add security / permission checks to the ioctls.


Theodore Ts'o (4):
  ext4 crypto: add missing locking for keyring_key access
  ext4 crypto: add ciphertext_access mount option
  ext4 crypto: simplify interfaces to directory entry insert functions
  ext4 crypto: add ioctls to allow backup of encryption metadata

 fs/ext4/crypto_key.c  | 128 ++++++++++++++++++++++++++++++++++++-
 fs/ext4/ext4.h        |  18 +++++-
 fs/ext4/ext4_crypto.h |  16 +++++
 fs/ext4/file.c        |   5 +-
 fs/ext4/indirect.c    |  24 +++++--
 fs/ext4/inline.c      |  10 ++-
 fs/ext4/inode.c       |  17 +++--
 fs/ext4/ioctl.c       |  87 +++++++++++++++++++++++++
 fs/ext4/namei.c       | 174 +++++++++++++++++++++++++++++++++++++++++---------
 fs/ext4/super.c       |  48 ++++++++++++++
 10 files changed, 475 insertions(+), 52 deletions(-)

-- cut here for sample test program --

/*
 * ext4-crypto-cp-md.c
 *
 * Test program to test the new crypto metadata backup/restore ioctl's
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>

typedef unsigned long u32;
typedef signed long s32;

struct ext4_encrypted_metadata {
	u32 len;
	char metadata[288];
};

struct ext4_set_encrypted_fname {
	s32 fd;
	u32 len;
	unsigned char enc_fname[256];
};

#ifndef EXT4_IOC_GET_ENCRYPTION_METADATA
#define EXT4_IOC_GET_ENCRYPTION_METADATA _IOWR('f', 22, struct ext4_encrypted_metadata)
#endif
#ifndef EXT4_IOC_SET_ENCRYPTION_METADATA
#define EXT4_IOC_SET_ENCRYPTION_METADATA _IOR('f', 23, struct ext4_encrypted_metadata)
#endif
#ifndef EXT4_IOC_GET_ENCRYPTED_FILENAME
#define EXT4_IOC_GET_ENCRYPTED_FILENAME	_IOWR('f', 24, struct ext4_encrypted_metadata)
#endif
#ifndef EXT4_IOC_SET_ENCRYPTED_FILENAME
#define EXT4_IOC_SET_ENCRYPTED_FILENAME	_IOR('f', 25, struct ext4_set_encrypted_fname)
#endif

void print_mdata(const char *s, struct ext4_encrypted_metadata *mdata)
{
	int i;

	printf("%s len %d: \n", s, mdata->len);
	for (i = 0; i < mdata->len; i++)
		printf("%02x ", mdata->metadata[i] & 0xFF);
	printf("\n");
}

int main(int argc, char **argv)
{
	int	s_fd, d_fd = -1, dir_fd = -1;
	int	oflags = O_RDONLY;
	struct ext4_encrypted_metadata f_mdata, fn_mdata;

	if (argc < 2 || argc > 4) {
		fprintf(stderr, "Usage: %s source [destination] [destdir]\n",
			argv[0]);
		exit(1);
	}
	s_fd = open(argv[1], O_RDONLY);
	if (s_fd < 0) {
		perror(argv[1]);
		exit(1);
	}
	if (argc > 2) {
		d_fd = open(argv[2], O_RDONLY);
		if (d_fd < 0) {
			perror(argv[2]);
			exit(1);
		}
	}
	if (argc > 3) {
		dir_fd = open(argv[3], O_DIRECTORY);
		if (dir_fd < 0) {
			perror(argv[3]);
			exit(1);
		}
	}
	f_mdata.len = sizeof(f_mdata.metadata);
	if (ioctl(s_fd, EXT4_IOC_GET_ENCRYPTION_METADATA, &f_mdata)) {
		perror("EXT4_IOC_GET_ENCRYPTION_METADATA");
		f_mdata.len = 0;
	} else {
		print_mdata("file", &f_mdata);
	}
	fn_mdata.len = sizeof(fn_mdata.metadata);
	if (ioctl(s_fd, EXT4_IOC_GET_ENCRYPTED_FILENAME, &fn_mdata)) {
		perror("EXT4_IOC_GET_ENCRYPTED_FILENAME");
		fn_mdata.len = 0;
	} else {
		print_mdata("filename", &fn_mdata);
	}
	if (d_fd >= 0 && f_mdata.len > 0) {
		if (ioctl(d_fd, EXT4_IOC_SET_ENCRYPTION_METADATA, &f_mdata)) {
			perror("EXT4_IOC_SET_ENCRYPTION_METADATA");
		}
	}
	if (d_fd >= 0 && dir_fd >= 0 && fn_mdata.len > 0) {
		struct ext4_set_encrypted_fname set_fn;

		set_fn.fd = d_fd;
		set_fn.len = fn_mdata.len;
		memcpy(&set_fn.enc_fname, &fn_mdata.metadata, fn_mdata.len);
		if (ioctl(dir_fd, EXT4_IOC_SET_ENCRYPTED_FILENAME, &set_fn)) {
			perror("EXT4_IOC_SET_ENCRYPTED_FILENAME");
		}
	}
	return 0;
}

-- cut here for a sample shell script --

#!/bin/bash -vx
#
# Sample shell script which demonstrates how to use the demonstration
# C program.  We use dd to copy the file using O_DIRECT, but the backup
# process should use SEEK_HOLE and SEEK_DATA to efficiently copy sparse
# files.
# For more details, please see:
#     http://linux.die.net/man/2/lseek
#     https://blogs.oracle.com/bonwick/en/entry/seek_hole_and_seek_data

umount /vdc
dmesg -n 7
mke2fs -Fq -t ext4 -O encrypt /dev/vdc
debugfs -w -R "ssv encrypt_pw_salt deadbeef-dead-beef-1234-5678deadbeef" /dev/vdc
mount -t ext4 /dev/vdc /vdc
mkdir /vdc/a
echo foobar | e4crypt add_key /vdc/a
cat << EOF > /vdc/a/test_file
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In accumsan
mi ac magna vestibulum commodo. Cras facilisis posuere tellus in
efficitur. Sed mollis mi eget elit vulputate pellentesque. Ut vitae
laoreet diam. Aliquam sem leo, luctus eget leo eu, hendrerit egestas
risus. Nulla non nisi ut nisl suscipit dictum. Donec eleifend dapibus
mi eu porttitor. Nulla lacinia tellus nec porttitor tincidunt. Nam
lectus nibh, fringilla sit amet enim id, consequat tincidunt
mauris. Ut blandit orci vitae elit suscipit varius. Donec vel sem
tristique, efficitur felis sit amet, sagittis metus. In laoreet
ultricies interdum. Aliquam felis est, pharetra eget nisl vel,
fringilla aliquet velit. Etiam ut augue ut ante fringilla gravida quis
a arcu.
EOF
umount /vdc
keyctl purge logon
mount -t ext4 -o ciphertext_access /dev/vdc /vdc
F=/vdc/a/$(ls /vdc/a)
dd if=$F of=/vdc/tmpfile iflag=direct oflag=direct bs=4k
mkdir /vdc/b
/vdb/ext4-crypto-cp-md /vdc/a /vdc/b
/vdb/ext4-crypto-cp-md $F /vdc/tmpfile /vdc/b
#
# note: after this point we would normally delete /vdc/tmpfile
# but for the purposes of this script we keep it for test purposes
#
umount /vdc
mount -t ext4 /dev/vdc /vdc
echo foobar | e4crypt add_key
md5sum /vdc/b/test_file /vdc/a/test_file
umount /vdc
e2fsck -fn /dev/vdc
keyctl purge logon
exit 0

-- cut here --

-- 
2.5.0

