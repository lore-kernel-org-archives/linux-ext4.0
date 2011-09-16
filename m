From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/37] libext2fs: Add crc32c implementation for
 metadata checksumming
Date: Thu, 15 Sep 2011 23:32:03 -0400
Message-ID: <20110916033203.GQ28181@thunk.org>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003536.1176.46176.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50443 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab1IPDcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:32:10 -0400
Content-Disposition: inline
In-Reply-To: <20110901003536.1176.46176.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:35:36PM -0700, Darrick J. Wong wrote:
> Add a slicing-by-8 CRC32c implementation for metadata checksumming.
> Adapted from Bob Pearson's kernel patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

I've added this patch to e2fsprogs' next branch, with the following
changes:
   1) I also folded in the self-test patch 5/37
   2) I added "ext2fs_" to the crc32_be and crc32_le functions, to avoid
	namespace contamination -- I did the same thing with the crc16.c
	function, BTW.

					- Ted
