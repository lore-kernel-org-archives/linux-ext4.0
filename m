From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: write/write/fallocate quota leakage
Date: Thu, 03 Jun 2010 12:21:01 +0400
Message-ID: <87typk1q8i.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V." <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62564 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab0FCIVJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 04:21:09 -0400
Received: by fxm8 with SMTP id 8so2490914fxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 01:21:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Recently one "write vs fallocate" quota leakage was fixed, but
not completely. It is still possible if uninitialized extent which
covers several delay allocated regions converted to initialized one.

Take a look at test-case attached.
The issue is clear enough, but I don't have a good solution for now.
Off course we can add one more restriction to zeroout logic, but this is
unproductive way because we have to keep zeroout logic simple as possible.

Aneesh, do you have any sound ideas?


--=-=-=
Content-Disposition: inline; filename=falloc_opt.c

/* EXT4 delalloc reservation leakage testcase
 * To make that leackage more verbose please apply following patch
 * http://download.openvz.org/~dmonakhov/junk/ext4-sanity-check.patch
 */
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	loff_t len, offset;
	int fd, ret;
	char buf[81920];
	if (argc != 2) {
		printf("Usage: %s <fname>\n", argv[0]);
		return 1;
	}
	fd = open(argv[1], O_CREAT|O_RDWR, 0777);
	ftruncate(fd, 40960);
	fsync(fd);
	ret = pwrite(fd, buf, 4096, 0);
	if (ret != 4096) {
		perror("write failed");
		return 1;
	}
	/* Leve one page gap between dirty pages */
	ret = pwrite(fd, buf, 8192, 8192);
	if (ret != 8192) {
		perror("write failed");
		return 1;
	}
	/* Create uninitialized extent */
	ret = fallocate(fd, 0x1, 0, 4096*5);
	if (ret) {
		perror("fallocate failed");
		return 1;
	}
	/* Force block allocation.
	 * Uninitialized extent will be converted to initialized one
	 * during ext4_map_blocks() on writing first pages set.
	 * Later second pages set will discover what blocks are already
	 * initialized, so reservation for that pages will leak.
	 */
	fsync(fd);
	return 0;
}

--=-=-=--
