From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: Problems with the max value for create directory
Date: Tue, 23 Dec 2008 11:02:54 +0800
Message-ID: <495054DE.9030405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49229 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYLWDCN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Dec 2008 22:02:13 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id B0665170135
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 11:09:36 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id mBN39a4F021943
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 11:09:36 +0800
Received: from [127.0.0.1] (unknown [10.167.141.190])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id 15672291A29
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 11:08:08 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I creat 65537 long directories and failed when the block size is 1024.

# mkfs.ext4dev -b 1024 -I 256 /dev/hda3
# tune2fs -E test_fs -O extents /dev/hda3
# mount -t ext4dev /dev/hda3 /mnt
# ./create_long_dirs 65537 /mnt

The code of create_long_dirs.c:

#define _ATFILE_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <fcntl.h>
#include <sys/types.h>
//#define __USE_ATFILE
#include <sys/stat.h>

#define NAME_LEN	255
#define NCHARS		62
#define MAX_LEN1	62
#define MAX_LEN2	(62 * 62)
#define MAX_LEN3	(62 * 62 * 62)

/* valid characters for the directory name */
char chars[NCHARS + 1] =
	"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

/* to store the generated directory name */
char name[NAME_LEN + 1];
int names;
int parent_fd;

void init_name(void)
{
	int i;

	srand(time(NULL));

	for (i = 0; i < NAME_LEN; i++)
		name[i] = chars[rand() % 62];
}

void create_dir(void)
{
	if (mkdirat(parent_fd, name, S_IRWXU)) {
		perror("mkdir");
		exit(1);
	}
}

/*
 * create_dirs - create @names directory names
 * @n: how many names to be created
 *
 * if n <= 62,       we need to modify 1 char of the name
 * if n <= 62*62,    we need to modify 2 chars
 * if n <= 62*62*62, we need to modify 3 chars
 */
void create_dirs(int n)
{
	int i, j, k;
	int depth;

	if (n <= MAX_LEN1)
		depth = 1;
	else if (n <= MAX_LEN2)
		depth = 2;
	else
		depth = 3;

	for (i = 0; i < NCHARS; i++) {
		name[0] = chars[i];
		if (depth == 1) {
			create_dir();
			if (--n == 0)
				return;
			continue;
		}

		for (j = 0; j < NCHARS; j++) {
			name[1] = chars[j];
			if (depth == 2) {
				create_dir();
				if (--n == 0)
					return;
				continue;
			}

			for (k = 0; k < NCHARS; k++) {
				name[2] = chars[k];
				create_dir();
				if (--n == 0)
					return;
			}
		}
	}
}

void usage()
{
	fprintf(stderr, "Usage: create_long_dirs nr_dirs parent_dir\n");
}

int main(int argc, char *argv[])
{
	if (argc != 3) {
		usage();
		return 1;
	}

	names = atoi(argv[1]);
	if (names > MAX_LEN3 || names <= 0) {
		usage();
		return 1;
	}

	parent_fd = open(argv[2], O_RDONLY);
	if (parent_fd == -1) {
		perror("open parent dir failed");
		return 1;
	}

	init_name();

	create_dirs(names);

	return 0;
}


-- 
Regards
Zhang Xiliang



