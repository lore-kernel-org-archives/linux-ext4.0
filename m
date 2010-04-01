From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: lsetxattr/lgetxattr on ext4.
Date: Thu, 01 Apr 2010 14:54:56 -0700
Message-ID: <1270158896.2342.6.camel@mingming-laptop>
References: <4BB3E375.5010604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jvrao <jvrao@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37868 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab0DAVy7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 17:54:59 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o31Lk7u3003489
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 17:46:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31LswZX171112
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 17:54:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o31Lswwa004151
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 18:54:58 -0300
In-Reply-To: <4BB3E375.5010604@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-03-31 at 17:06 -0700, jvrao wrote:
> lsetxattr()/lgetxsttr() functions are not working on a ext4 symlink. 
> But works fine on a regular file.
> 
> I tried the following program.. Not sure if I am missing something.
> Any help will be appreciated.
> 
> 


I tried your test program on ext2/3/btrfs, it seems all broken. 
Not sure how this not being visible? Thought xattrs are heavily used by
default on some distros.


Mingming

> --------- simple program -------------
> [jvrao]# cat sxl.c
> #include <stdio.h>
> #include <sys/types.h>
> #include <attr/xattr.h>
> 
> main()
> {
> 	int ha=5;
> 	int ha_out=-1;
> 	int err;
> 	err = lsetxattr("./foo", "user.junk", &ha, sizeof(int),0);
> 	if (err == -1)
> 		perror("lsetxattr failed");
> 	lgetxattr("./foo", "user.junk", &ha_out, sizeof(int));
> 	if (err == -1)
> 		perror("lsetxattr failed");
> 	printf("file:./foo ha:%d  ha_out:%d\n", ha, ha_out);
> 
> 	ha_out = -1;
> 	err = lsetxattr("./foo.sl", "user.junk", &ha, sizeof(int),0);
> 	if (err == -1)
> 		perror("lsetxattr failed");
> 	lgetxattr("./foo.sl", "user.junk", &ha_out, sizeof(int));
> 	if (err == -1)
> 		perror("lsetxattr failed");
> 	printf("file:./foo.sl  ha:%d  ha_out:%d\n", ha, ha_out);
> }
> ------------------------
> 
> [jvrao]# ls -l foo*
> -rw-r--r--. 1 root root 0 2010-03-31 16:49 foo
> lrwxrwxrwx. 1 root root 3 2010-03-31 16:49 foo.sl -> foo
> 
> [jvrao]# ./sxl
> file:./foo ha:5  ha_out:5
> lsetxattr failed: Operation not permitted
> lsetxattr failed: Operation not permitted
> file:./foo.sl  ha:5  ha_out:-1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


