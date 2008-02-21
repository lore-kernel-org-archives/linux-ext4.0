From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Thu, 21 Feb 2008 01:52:21 -0700
Message-ID: <20080221085221.GV3029@webber.adilger.int>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com>
 <20080220222019.GG30305@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51470 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYBUIwY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2008 03:52:24 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1L8qNW9007793
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 00:52:23 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWK00201Z9CTC00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 21 Feb 2008 00:52:23 -0800 (PST)
In-reply-to: <20080220222019.GG30305@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 20, 2008  17:20 -0500, Theodore Ts'o wrote:
> There are only three things which mke2fs will do, in my design:

This should all go into the mke2fs man page...

> [fs_types]
> 	ext3 = {
> 		features = has_journal
> 	}
> 	ext4 = {
> 		features = extents,flex_bg
> 		inode_size = 256
> 	}

Presumably the ext4 feature should also have features = has_journal?
If this is the default for ext4, why would it need to be given for ext3?

We should also add "dir_nlink,flexbg" while we are in there.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
