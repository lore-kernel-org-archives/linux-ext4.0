From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: small tool for unit testing
Date: Fri, 19 Jan 2007 14:52:41 +0530
Message-ID: <20070119092240.GA19867@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37471 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003AbXASJYu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jan 2007 04:24:50 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0J9OlNp015749
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:24:47 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0J9NQT9239102
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:23:26 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0J9NPAr030025
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:23:25 -0500
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 17, 2007 at 03:16:58PM +0530, Amit K. Arora wrote:
> The patches for e2fsprogs and fsx-linux are available with me. I can
> post them if anyone is interested to try/test the preallocation patches.
> Also, I have a small test program/tool written which can be used for
> unit testing.

Here is a small test program/tool which can be used to preallocate
blocks and write to these preallocated blocks. 


#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<errno.h>

#define _IOC_NRBITS     8
#define _IOC_TYPEBITS   8
#define _IOC_SIZEBITS   14
#define _IOC_DIRBITS    2

#define _IOC_NRMASK     ((1 << _IOC_NRBITS)-1)
#define _IOC_TYPEMASK   ((1 << _IOC_TYPEBITS)-1)
#define _IOC_SIZEMASK   ((1 << _IOC_SIZEBITS)-1)
#define _IOC_DIRMASK    ((1 << _IOC_DIRBITS)-1)

#define _IOC_NRSHIFT    0
#define _IOC_TYPESHIFT  (_IOC_NRSHIFT+_IOC_NRBITS)
#define _IOC_SIZESHIFT  (_IOC_TYPESHIFT+_IOC_TYPEBITS)
#define _IOC_DIRSHIFT   (_IOC_SIZESHIFT+_IOC_SIZEBITS)

/*
 * Direction bits.
 */
#define _IOC_WRITE      1U

#define _IOC(dir,type,nr,size) \
        (((dir)  << _IOC_DIRSHIFT) | \
         ((type) << _IOC_TYPESHIFT) | \
         ((nr)   << _IOC_NRSHIFT) | \
         ((size) << _IOC_SIZESHIFT))

/* provoke compile error for invalid uses of size argument */
extern unsigned int __invalid_size_argument_for_IOC;
#define _IOC_TYPECHECK(t) \
        ((sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
          sizeof(t) : __invalid_size_argument_for_IOC)

/* used to create numbers */
#define _IOW(type,nr,size)      _IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(size)))



#define EXT4_IOC_PREALLOCATE            _IOW('f', 9, struct ext4_falloc_input)

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
  ret = ioctl(fd, EXT4_IOC_PREALLOCATE, &input);

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

--
Regards,
Amit Arora
