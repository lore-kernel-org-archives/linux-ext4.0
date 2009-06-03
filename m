From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH,STABLE 2.6.29 14/18] ext4: Ignore i_file_acl_high	unless
 EXT4_FEATURE_INCOMPAT_64BIT is present
Date: Wed, 03 Jun 2009 12:17:28 -0600
Message-ID: <20090603181728.GP9002@webber.adilger.int>
References: <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
 <1243944479-20574-12-git-send-email-tytso@mit.edu>
 <1243944479-20574-13-git-send-email-tytso@mit.edu>
 <1243944479-20574-14-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38897 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZFCSRh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 14:17:37 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n53IHedt020320
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jun 2009 11:17:40 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKO00J00DGAIC00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 03 Jun 2009 11:17:40 -0700 (PDT)
In-reply-to: <1243944479-20574-14-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 02, 2009  08:07 -0400, Theodore Ts'o wrote:
> Don't try to look at i_file_acl_high unless the INCOMPAT_64BIT feature
> bit is set.  The field is normally zero, but older versions of e2fsck
> didn't automatically check to make sure of this, so in the spirit of
> "be liberal in what you accept", don't look at i_file_acl_high unless
> we are using a 64-bit filesystem.

Should we do the same with other "_hi" fields in the inode?  There are
many cases like this for EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT
in super.c.  Does e2fsck check and zero those already?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

