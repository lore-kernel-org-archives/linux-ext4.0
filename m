From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] ext4 crypto: back up encrypted files
Date: Thu, 10 Dec 2015 11:31:24 -0500
Message-ID: <20151210163124.GC8898@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Cc: mhalcrow@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50764 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbLJQbZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 11:31:25 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

And here are some test programs / scripts that I've been using to test
these patches.  They also demonstrate how to use the ioctl's.

      		     	  	      	     - Ted

--uAKRQypu60I7Lcqm
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="ext4-crypto-cp-md.c"

/*
 * Test program to trigger the precache ioctl
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>

typedef unsigned long u32;

struct ext4_encrypted_metadata {
	u32 len;
	char metadata[288];
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
	int	s_fd, d_fd = -1;
	int	oflags = O_RDONLY;
	struct ext4_encrypted_metadata f_mdata, fn_mdata;

	if (argc < 2 || argc > 3) {
		fprintf(stderr, "Usage: %s source [destination]\n",
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
	} else {
		print_mdata("filename", &fn_mdata);
	}
	if (d_fd >= 0 && f_mdata.len > 0) {
		if (ioctl(d_fd, EXT4_IOC_SET_ENCRYPTION_METADATA, &f_mdata)) {
			perror("EXT4_IOC_SET_ENCRYPTION_METADATA");
		}
	}
	return 0;
}

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=test-cp-md

#!/bin/bash -vx
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
dd if=$F of=/vdc/out iflag=direct oflag=direct bs=4k
/vdb/ext4-crypto-cp-md $F /vdc/out
umount /vdc
mount -t ext4 /dev/vdc /vdc
echo foobar | e4crypt add_key
truncate --reference /vdc/a/test_file /vdc/out
diff /vdc/out /vdc/a/test_file

--uAKRQypu60I7Lcqm--
