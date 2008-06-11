From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] e2fsprogs: Dump extent/sindices using debugfs
Date: Wed, 11 Jun 2008 16:13:51 +0530
Message-ID: <20080611104351.GA9008@skywalker>
References: <1213179088.3298.12.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47033 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYFKKoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 06:44:23 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5BAhrwF013040
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 16:13:53 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BAhbrU1478760
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 16:13:37 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5BAhqii025654
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 16:13:53 +0530
Content-Disposition: inline
In-Reply-To: <1213179088.3298.12.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 03:41:28PM +0530, Girish Shilamkar wrote:
> Hi Ted,
> 	The attached patch adds a command to debugfs to display all the
> extents/indices contained in an inode or the block specified.
> 	The options to the command includes tranversing and dumping the entire
> extent tree (if inode specified) or the branch (in case of block) and
> can display only the headers if required.
> 
> Would you please let me know your comments/suggestions ?

lib/ext2fs/tst_extents (I don't know why we don't install this by
default) have inode, root and ns/n command which help to iterate the
extent format inode

-aneesh
