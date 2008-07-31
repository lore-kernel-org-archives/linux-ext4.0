From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 22:36:13 +0530
Message-ID: <20080731170613.GC20838@skywalker>
References: <20080731161058.GA20838@skywalker> <4891EB43.9080408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:54654 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756726AbYGaRG1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 13:06:27 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6VH6Pf1006477
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:36:25 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VH6P9E1839232
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:36:25 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6VH6O04017823
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:36:25 +0530
Content-Disposition: inline
In-Reply-To: <4891EB43.9080408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:41:39AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > Hi Ted,
> > 
> > I haven't yet looked at whether it is kernel or e2fsck bug.
> > But I am having this with the latest patch queue when running
> > fsstress. The fsstress have falloc added as a supported operation.
> > So it is mostly to do with fallocate. Architecture is x86.
> > 
> > The tests performed are
> > 
> >                chown 3/39 write op
> >                creat 4/39 write op
> >                dread 4/39  
> >            fdatasync 1/39 write op
> >                fsync 1/39 write op
> >             getdents 1/39  
> >                 link 1/39 write op
> >                mkdir 2/39 write op
> >                mknod 2/39 write op
> >                 read 1/39  
> >             readlink 1/39  
> >               rename 2/39 write op
> >                rmdir 1/39 write op
> >                 stat 1/39  
> >              symlink 2/39 write op
> >                 sync 1/39  
> >             truncate 2/39 write op
> >               unlink 1/39 write op
> >                write 4/39 write op
> >            fallocate 4/39 write op
> > 
> > seed = 1218256896
> > 
> > 
> > /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sdb1
> > e2fsck 1.41.0 (10-Jul-2008)
> > Pass 1: Checking inodes, blocks, and sizes
> > Inode 10093, i_size is 974599, should be 999424.  Fix? no
> 
> are those due to blocks beyond EOF, I assume?  How is fallocate being
> called in fsstress?
> 

lr = ((__int64_t)random() << 32) + random();
off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
off %= maxfsize;
len = (random() % (getpagesize() * 32)) + 1;
#ifdef __i386__
#define __NR_fallocate          324
e = syscall(__NR_fallocate, fd, 0, off, len) < 0 ? errno : 0;
#elif defined (__powerpc__)
#define __NR_fallocate          309
e = syscall(__NR_fallocate, fd, 0, 0, (unsigned int)off, 0, (unsigned int) len) < 0 ?  errno : 0;
#elif defined (__x86_64__)
#define __NR_fallocate 285
e = syscall(__NR_fallocate, fd, 0, off, len) < 0 ?  errno : 0;
#endif

