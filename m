From: jvrao <jvrao@linux.vnet.ibm.com>
Subject: lsetxattr/lgetxattr on ext4.
Date: Wed, 31 Mar 2010 17:06:13 -0700
Message-ID: <4BB3E375.5010604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35160 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab0DAAG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Mar 2010 20:06:26 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2VNxWj8011233
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 17:59:32 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3106IbX063896
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 18:06:19 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3106F23028739
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 18:06:15 -0600
Received: from [127.0.0.1] (IBM-2AECC81F76A.beaverton.ibm.com [9.47.22.70])
	by d03av04.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o3106D5V028680
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 18:06:14 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

lsetxattr()/lgetxsttr() functions are not working on a ext4 symlink. 
But works fine on a regular file.

I tried the following program.. Not sure if I am missing something.
Any help will be appreciated.


--------- simple program -------------
[jvrao]# cat sxl.c
#include <stdio.h>
#include <sys/types.h>
#include <attr/xattr.h>

main()
{
	int ha=5;
	int ha_out=-1;
	int err;
	err = lsetxattr("./foo", "user.junk", &ha, sizeof(int),0);
	if (err == -1)
		perror("lsetxattr failed");
	lgetxattr("./foo", "user.junk", &ha_out, sizeof(int));
	if (err == -1)
		perror("lsetxattr failed");
	printf("file:./foo ha:%d  ha_out:%d\n", ha, ha_out);

	ha_out = -1;
	err = lsetxattr("./foo.sl", "user.junk", &ha, sizeof(int),0);
	if (err == -1)
		perror("lsetxattr failed");
	lgetxattr("./foo.sl", "user.junk", &ha_out, sizeof(int));
	if (err == -1)
		perror("lsetxattr failed");
	printf("file:./foo.sl  ha:%d  ha_out:%d\n", ha, ha_out);
}
------------------------

[jvrao]# ls -l foo*
-rw-r--r--. 1 root root 0 2010-03-31 16:49 foo
lrwxrwxrwx. 1 root root 3 2010-03-31 16:49 foo.sl -> foo

[jvrao]# ./sxl
file:./foo ha:5  ha_out:5
lsetxattr failed: Operation not permitted
lsetxattr failed: Operation not permitted
file:./foo.sl  ha:5  ha_out:-1



