From: Andreas Dilger <adilger@sun.com>
Subject: Re: 64-bit inode support in e2fsprogs? (was Re: [RFC PATCH 11/17]	Fix
 overflow in calculation of total file system blocks)
Date: Fri, 14 Nov 2008 13:32:52 -0700
Message-ID: <20081114203252.GW16005@webber.adilger.int>
References: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <20081113200402.GW16005@webber.adilger.int> <20081114031028.GH20637@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59643 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKNUc5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 15:32:57 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAEKWtPp005557
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2008 12:32:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAC00K01BLYF800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 14 Nov 2008 12:32:55 -0800 (PST)
In-reply-to: <20081114031028.GH20637@shell>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 13, 2008  22:10 -0500, Valerie Aurora Henson wrote:
> On Thu, Nov 13, 2008 at 01:04:02PM -0700, Andreas Dilger wrote:
> > There is a similar fix missing from ext2fs_allocate_inode_bitmap() (even
> > though there isn't any support for 64-bit inode numbers as yet.
> 
> That's a question I have: Should the 64-bit port have partial support
> for 64-bit inodes?  Supporting 64-bit inodes is enough effort and risk
> (especially in terms of glue code to convert back to 32-bit versions)
> that I think it makes sense to wait until we know more about what they
> will look like and have concrete plans to support them.

I agree, in general, but this kind of wordsize overflow bug is easy to
miss, and we may as well only have to figure out the bug once.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

