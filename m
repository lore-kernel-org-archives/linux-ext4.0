From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 11:41:39 -0500
Message-ID: <4891EB43.9080408@redhat.com>
References: <20080731161058.GA20838@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYGaQsq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2008 12:48:46 -0400
In-Reply-To: <20080731161058.GA20838@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> I haven't yet looked at whether it is kernel or e2fsck bug.
> But I am having this with the latest patch queue when running
> fsstress. The fsstress have falloc added as a supported operation.
> So it is mostly to do with fallocate. Architecture is x86.
> 
> The tests performed are
> 
>                chown 3/39 write op
>                creat 4/39 write op
>                dread 4/39  
>            fdatasync 1/39 write op
>                fsync 1/39 write op
>             getdents 1/39  
>                 link 1/39 write op
>                mkdir 2/39 write op
>                mknod 2/39 write op
>                 read 1/39  
>             readlink 1/39  
>               rename 2/39 write op
>                rmdir 1/39 write op
>                 stat 1/39  
>              symlink 2/39 write op
>                 sync 1/39  
>             truncate 2/39 write op
>               unlink 1/39 write op
>                write 4/39 write op
>            fallocate 4/39 write op
> 
> seed = 1218256896
> 
> 
> /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sdb1
> e2fsck 1.41.0 (10-Jul-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 10093, i_size is 974599, should be 999424.  Fix? no

are those due to blocks beyond EOF, I assume?  How is fallocate being
called in fsstress?

-Eric
