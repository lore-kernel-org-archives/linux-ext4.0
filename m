From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	restricts
 block allocation
Date: Wed, 24 Jun 2009 01:19:50 +0200
Message-ID: <20090623231950.GN31668@webber.adilger.int>
References: <4A409168.3020404@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45608 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbZFWXUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 19:20:21 -0400
Content-disposition: inline
In-reply-to: <4A409168.3020404@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 23, 2009  17:25 +0900, Akira Fujita wrote:
> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "advisory".
> Restricted blocks with "mandatory" are never used by block allocator.
> But in "advisory" case, block allocator is allowed to use restricted blocks
> when there are no free blocks on FS.

Would it make more sense to implement the range protections via the
existing preallocation ranges (PA)?  An inode can have multiple
PAs attached to it to have it prefer allocations from that range.

We could also attach PAs to the superblock to prevent other files from
allocating out of those ranges.  This would work better with the existing
allocation code instead of creating a second similar mechanism.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

