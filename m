From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: 64-bit inode support in e2fsprogs? (was Re: [RFC PATCH 11/17] Fix overflow in calculation of total file system blocks)
Date: Thu, 13 Nov 2008 22:10:28 -0500
Message-ID: <20081114031028.GH20637@shell>
References: <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <1226461390-5502-12-git-send-email-vaurora@redhat.com> <20081113200402.GW16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYKNDKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 22:10:30 -0500
Content-Disposition: inline
In-Reply-To: <20081113200402.GW16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:04:02PM -0700, Andreas Dilger wrote:
> 
> There is a similar fix missing from ext2fs_allocate_inode_bitmap() (even
> though there isn't any support for 64-bit inode numbers as yet.

That's a question I have: Should the 64-bit port have partial support
for 64-bit inodes?  Supporting 64-bit inodes is enough effort and risk
(especially in terms of glue code to convert back to 32-bit versions)
that I think it makes sense to wait until we know more about what they
will look like and have concrete plans to support them.

-VAL
