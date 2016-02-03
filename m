From: Christoph Hellwig <hch@lst.de>
Subject: vfs/xfs: directio updates to ease COW handling V2
Date: Wed,  3 Feb 2016 19:40:13 +0100
Message-ID: <1454524816-11392-1-git-send-email-hch@lst.de>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbcBCSkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2016 13:40:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

See http://www.infradead.org/rpr.html

The first patch ensures ->end_io is always called for direct I/O requests
that pass it in, even if there was a zero length write, or if an error
occured.  The existing users have been updated to ignore it, but XFS
will make use of it in the future, and a comment in ext4 suggests it
might be useful for it as well.

The other two simplify the XFS direct I/O code.

Changes since V1:
 - allow ->end_io to return errors
 - a comment spelling fix


