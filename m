From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 0/2] Journal Checksums
Date: Wed, 30 May 2007 15:58:12 +0530
Message-ID: <1180520892.3787.43.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36249 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbXE3Kav (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2007 06:30:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
 	The following patch set adds journal checksumming support for linux
kernel and e2fsprogs. 

Two new flags have been added i.e 
JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT and JBD2_FEATURE_COMPAT_CHECKSUM.

_CHECKSUM flag indicates that the commit block contains the checksum for
the blocks described the the descriptor blocks.
Due to checksums, writing of the commit record no longer needs to be
synchronous, this behavior is controlled using _ASYNC_COMMIT flag. Older
kernels/e2fsck should not be able to recover the journal with
_ASYNC_COMMIT hence it is made incompat. 
The commit header has been extended to hold the checksum along with the
type of the checksum.

For recovery in pass scan checksums are verified to ensure the sanity
and completeness(in case of _ASYNC_COMMIT) of every transaction.

Any suggestions/comments are welcome.

Thanks & Regards,
Girish.
