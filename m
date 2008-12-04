From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/6][REPOST] ext{2,3,4}: tighten inheritance and	setting of
 inode flags
Date: Wed, 03 Dec 2008 23:39:54 -0700
Message-ID: <20081204063954.GG3186@webber.adilger.int>
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: akpm@linux-foundation.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50175 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbYLDGj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 01:39:59 -0500
In-reply-to: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 03, 2008  19:54 +0000, Duane Griffin wrote:
> This patch series prevents the inheritance and setting of flags that are
> inappropriate for specific inode types.
> 
> Flags which should be inherited are listed explicitly so as to prevent
> future flags being overlooked and inherited by accident.
> 
> It introduces a function to mask flags based on the inode type and uses
> it in inode creation and the SETFLAGS ioctl to help prevent future
> inconsistency.
> 
> Patches 1-3 fix the TOPDIR flag inheritance bug reported at
> http://bugzilla.kernel.org/show_bug.cgi?id=9866.
> 
> Patches 4-6 fix a related problem with non-regular file/dir inodes
> inheriting inappropriate flags, discovered while testing. For example,
> on an unpatched system, the following sequence will create an
> un(re)movable device node:

I worked with Duane during the development of these patches and agree
that they implement the proper solution to a problem that has repeated
a number of times as new flags are added.

Acked-by: Andreas Dilger <adilger@sun.com>

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

