From: sho@tnes.nec.co.jp
Subject: Re:[RFC][PATCH 0/3] Extent base online defrag
Date: Wed, 29 Nov 2006 23:39:31 +0900
Message-ID: <20061129233931sho@rifu.tnes.nec.co.jp>
References: <012a01c713a5$54910430$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:8603 "EHLO
	tyo202.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S967366AbWK2Ojt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 09:39:49 -0500
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kATEdlYw017474
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 23:39:47 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kATEdll13869 for linux-ext4@vger.kernel.org; Wed, 29 Nov 2006 23:39:47 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id kATEdkg01923 for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 23:39:46 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061129.234508.92101876 for <linux-ext4@vger.kernel.org>
	; Wed, 29 Nov 2006 23:45:09 +0900
To: girish@clusterfs.com
In-reply-to: <012a01c713a5$54910430$4168010a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi,

Thank you for your trial and report of the result!

> Hi,
> I tried to use defrag utility. But these are the results that, I got:
> 
> [root@metis e4defrag]# ./defrag /dev/hda8
> Start defragment for device(/dev/hda8)
>        Total:                   393
>        Success:                   0 
>        Failure:                 393
> [root@metis e4defrag]# ./defrag /mnt/test1/root
> Start defragment for directory(/mnt/test1/root)
>        Total:                   392
>        Success:                   0
>        Failure:                 392
> I tried same thing with different directories and files, but the result
> was the same.
> By doing strace on defrag utility I found that ioctl always returned
> ENOSPC. So I decreased the no. files, but still that didn't help, I came
> down till filesystem was only 9% full.

I think that your files didn't have many fragments, so ioctl returned
ENOSPC.  e4defrag iterates ioctl per 64MB.  If the specified 64MB
range has only one fragment(extent), the kernel returns ENOSPC
at the current implement.
So I'll change this behaviour to realize whether there was actual
error.  I intend to update my patches in early December.

If you need to check the number of fragments(extents),
you can use the following simple program using Alex's debug code.
Example:
# ./scan_ext -e data0
Extents of data0:
start = 10240 len = 1024 block = 0
start = 212992 len = 1536 block = 1024
start = 197632 len = 1024 block = 2560
start = 450560 len = 1536 block = 3584
start = 662019 len = 1535 block = 5120
start = 721424 len = 1 block = 6655
start = 722944 len = 1024 block = 6656
start = 726016 len = 512 block = 7680

start: The physical block number.
len: The length of the extent.
block: The logical block number.

The program is following.
-----
#include <stdio.h>
#include <sys/ioctl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


#define GET_EXTENTS	0
#define GET_STATUS	1
#define	GET_DEPTH	2

#define EXT3_IOC_GET_EXTENTS		_IOR('f', 7, long)
#define EXT3_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
#define EXT3_IOC_GET_TREE_STATS		_IOR('f', 9, long)

#define	BUF_LEN	1024

/*
 * this structure is used to gather extents from the tree via ioctl
 */
struct ext3_extent_buf {
	unsigned long start;
	int buflen;
	void *buffer;
	void *cur;
	int err;
};

/*
 * storage for cached extent
 */
struct ext3_ext_cache {
	unsigned int   ec_start;
	unsigned int   ec_block;
	unsigned int   ec_len;
	unsigned int   ec_type;
}; 

/*
 * this structure is used to collect stats info about the tree
 */
struct ext3_extent_tree_stats {
	int depth;
	int extents_num;
	int leaf_num;
};

struct ext3_ext_cache ec[BUF_LEN];

int
main(int argc, char **argv) {

	int cmd = EXT3_IOC_GET_EXTENTS;
	char	*file;
	int	fd;
	struct	ext3_extent_buf ebuf;
	void	*arg;
	struct ext3_extent_tree_stats	estat;
	int	ret;
	int	i;

	if (argc < 3) {
		fprintf(stderr, "Usage: scan_ext -e|-s|-d file\n");
		exit(1);
	}	

	if (!strcmp(argv[1], "-e")) {
		file = argv[2];
	} else if (!strcmp(argv[1], "-d")) {
		file = argv[2];
		cmd = EXT3_IOC_GET_TREE_DEPTH;	
	} else if (!strcmp(argv[1], "-s")) {
		file = argv[2];
		cmd = EXT3_IOC_GET_TREE_STATS;
	} else {
		file = argv[1];
	}

	if ((fd = open(file, O_RDONLY)) < 0) {
		perror("open");
		exit(1);
	}
		
	switch (cmd) {
	case EXT3_IOC_GET_EXTENTS:
		printf("Extents of %s:\n", argv[2]);
		ebuf.start = 0;
		ebuf.buflen = BUF_LEN * sizeof(struct ext3_ext_cache);
		ebuf.buffer = ebuf.cur = ec;
		ebuf.err = 0;
		arg = &ebuf;	
		break;
	case EXT3_IOC_GET_TREE_DEPTH:
		arg = NULL;	
		break;
	case EXT3_IOC_GET_TREE_STATS:
		arg = &estat;
		break;
	}

	if ((ret = ioctl(fd, cmd, arg)) < 0) {
		perror("ioctl");
		exit(1);
	}

	switch (cmd) {
	case EXT3_IOC_GET_EXTENTS:
		for(i = 0; i < ret; i++) {
			printf("start = %u len = %u block = %u\n",
				ec[i].ec_start, ec[i].ec_len,
				ec[i].ec_block); 
		}	
		break;
	case EXT3_IOC_GET_TREE_DEPTH:
		printf("depth = %d\n", ret);
		break;
	case EXT3_IOC_GET_TREE_STATS:
		printf("depth       = %d\n", estat.depth);
		printf("extents     = %d\n", estat.extents_num);
		printf("leaf blocks = %d\n", estat.leaf_num);
		break;
	}

	exit(0);
}

Cheers, Takashi
