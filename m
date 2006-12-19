From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Tue, 19 Dec 2006 17:12:51 +0530
Message-ID: <20061219114251.GA25086@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53512 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbWLSLm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Dec 2006 06:42:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBJBgrb9012171
	for <linux-ext4@vger.kernel.org>; Tue, 19 Dec 2006 06:42:53 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBJBgrP2519108
	for <linux-ext4@vger.kernel.org>; Tue, 19 Dec 2006 04:42:53 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBJBgruh001596
	for <linux-ext4@vger.kernel.org>; Tue, 19 Dec 2006 04:42:53 -0700
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061215123920.GB24572@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I wrote a simple tool to test these patches. The tool takes four
arguments:

* command: It may have either of the two values - "prealloc" or "write"
* filename: This is the filename with relative path
* offset: The offset within the file from where the preallocation, or
		the write should start.
* length: Total number of bytes to be allocated/written from offset.

Following cases were tested :
1. * preallocation from 0 to 32MB
   * write to various parts of the preallocated space in sets
   * observed that the extents get split and also get merged

2. * preallocate with holes at various places in the file
   * write to blocks starting from a hole and ending into preallocated
      blocks and vice-versa
   * try to write to entire set of blocks (i.e. from 0 to the last
      preallocated block) which has holes in between.


I also tried some random preallocation and write operations. They seem
to work fine. There is a patch also ready for e2fsprogs utils to
recognize uninitialized extents, which I used to verify the results of
the above testcases. I will post that patch in the next mail.

Here is the code for the simple tool :


#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<errno.h>

#define EXT4_IOC_FALLOCATE		0x40106609

struct ext4_falloc_input {
	unsigned long long offset;
	unsigned long long len;
	};

int do_prealloc(char* fname, struct ext4_falloc_input input)
{
  int ret, fd = open(fname, O_CREAT|O_RDWR, 0666);

  if(fd<0) {
	printf("Error opening file %s\n", fname);
	return 1;
  }

  printf("%s : Trying to preallocate blocks (offset=%llu, len=%llu)\n", 
					fname, input.offset, input.len);
  ret = ioctl(fd, EXT4_IOC_FALLOCATE, &input);

  if(ret <0) {
	printf("IOCTL: received error %d, ret=%d\n", errno, ret);
  	close(fd); 
	exit(1);
  }
  printf("IOCTL succedded !  ret=%d\n", ret);
  close(fd); 
}

int do_write(char* fname, struct ext4_falloc_input input)
{
  int ret, fd;
  char *buf;

  buf = (char *)malloc(input.len);

  fd = open(fname, O_CREAT|O_RDWR, 0666);
  if(fd<0) {
	printf("Error opening file %s\n", fname);
	return 1;
  }

  printf("%s : Trying to write to file (offset=%llu, len=%llu)\n", 
					fname, input.offset, input.len);

  ret = lseek(fd, input.offset, SEEK_SET);
  if(ret != input.offset) {
	printf("lseek() failed error=%d, ret=%d\n", errno, ret);
 	close(fd); 
	return(1);
  }

  ret = write(fd, buf, input.len);
  if(ret != input.len) {
	printf("write() failed error=%d, ret=%d\n", errno, ret);
 	close(fd); 
	return(1);
  }

  printf("Write succedded ! Written %llu bytes ret=%d\n", input.len, ret);
  close(fd); 
}


int main(int argc, char **argv)
{
  struct ext4_falloc_input input;
  int ret = 1, fd;
  char *fname; 

  if(argc<5) {
	printf("%s <CMD: prealloc/write> <filename-with-path> <offset> <length>\n", argv[0]);
	exit(1);
  }

  fname = argv[2];
  input.offset=(unsigned long long)atol(argv[3]);;
  input.len=(unsigned long long)atol(argv[4]);

  if(input.offset<0 || input.len<= 0) {
	printf("%s: Invalid arguments.\n", argv[0]);
	exit(1);
  }

  if(!strcmp(argv[1], "prealloc"))
  	ret = do_prealloc(fname, input);
  else if(!strcmp(argv[1], "write"))
	ret = do_write(fname, input);
  else
	printf("%s: Invalid arguments.\n", argv[0]);

  return ret;
}
