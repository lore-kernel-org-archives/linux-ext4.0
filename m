From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: Dump extent/sindices using debugfs
Date: Thu, 12 Jun 2008 02:32:04 -0600
Message-ID: <20080612083204.GU3726@webber.adilger.int>
References: <1213179088.3298.12.camel@alpha.linsyssoft.com>
 <20080611104351.GA9008@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Girish Shilamkar <Girish.Shilamkar@sun.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48685 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYFLIcG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 04:32:06 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5C8W6TV020322
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 01:32:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2C00K01D02NV00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 12 Jun 2008 01:32:06 -0700 (PDT)
In-reply-to: <20080611104351.GA9008@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 11, 2008  16:13 +0530, Aneesh Kumar K.V wrote:
> On Wed, Jun 11, 2008 at 03:41:28PM +0530, Girish Shilamkar wrote:
> > 	The attached patch adds a command to debugfs to display all the
> > extents/indices contained in an inode or the block specified.
> > 	The options to the command includes tranversing and dumping the entire
> > extent tree (if inode specified) or the branch (in case of block) and
> > can display only the headers if required.
> > 
> > Would you please let me know your comments/suggestions ?
> 
> lib/ext2fs/tst_extents (I don't know why we don't install this by
> default) have inode, root and ns/n command which help to iterate the
> extent format inode

The "tst_*" programs are purely for regression testing.  Having this
functionality built into a proper tool like debugfs is needed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

