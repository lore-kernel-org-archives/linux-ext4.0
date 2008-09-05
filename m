From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add e4migrate
Date: Fri, 05 Sep 2008 17:44:26 -0600
Message-ID: <20080905234426.GC3086@webber.adilger.int>
References: <1220609506-2052-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45461 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYIEXo3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2008 19:44:29 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m85NiSUE015846
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 16:44:29 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6Q00F01XJT4300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 05 Sep 2008 16:44:28 -0700 (PDT)
In-reply-to: <1220609506-2052-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 05, 2008  15:41 +0530, Aneesh Kumar wrote:
> +e4migrate \- Migrate an ext3 inode to ext4 inode format
> +.B e4migrate will migrate filename in ext3 inode format to ext4 inode format
> +This can be used to migrate an ext3 file system to ext4 file system

Can you please explain a bit more about what is done here?  Is it changing
block mapped inodes to extent mapped?  Resising the inodes/GDT? Changing
other things like growing large inode space for ns timestamps/version?

We have an option to e2fsck (like -D for rehash directory, but instead
"-E expand_extra_isize") to resize the "extra_isize" of an existing inode
to ensure that enough space is in the filesystem for i_version_hi, if it
isn't already.  This is in our patch "e2fsprogs-expand-extra-isize.patch"
in the Lustre patchset.

I think it makes more sense to have options for existing tools, rather
than having 10 new different tools, but maybe Ted has other opinions.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

