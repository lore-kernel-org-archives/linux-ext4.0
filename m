From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: set EXT4_EXTENTS_FL only for directory and
	regular files
Date: Wed, 20 Feb 2008 01:24:26 +0530
Message-ID: <20080219195426.GA6543@skywalker>
References: <1203450545-9938-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53124 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756147AbYBSTyb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 14:54:31 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1JJsRbl008555
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 01:24:27 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JJsR9v1077414
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 01:24:27 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1JJsQVu022819
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 19:54:27 GMT
Content-Disposition: inline
In-Reply-To: <1203450545-9938-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming,


On Wed, Feb 20, 2008 at 01:19:05AM +0530, Aneesh Kumar K.V wrote:
> Also don't inherit EXT4_EXTENTS_FL from parent directory.
> If we have a directory with extent flag set and later mount the file
> system with -o noextents, the files created in that directory will also
> have extent flag set but we would not have called ext4_ext_tree_init for
> them. This will cause error later when we are verifying the extent header
> 
> Also we don't want to set extent flag for symlinks, char, block, fifo
> or socket
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This should replace the below two patches in the patch queue.

ext4-donot-set-extents-flag-for-any-symlinks.patch
ext4-clear-extents-flag-on-inodes-created-in-ext4-mknod.patch


-aneesh
