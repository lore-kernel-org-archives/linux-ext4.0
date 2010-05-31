From: Christoph Hellwig <hch@lst.de>
Subject: ext2 quota corruption in xfstest 235
Date: Mon, 31 May 2010 11:51:31 +0200
Message-ID: <20100531095131.GA10496@lst.de>
References: <20100531094704.GB10283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35351 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab0EaJvd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 05:51:33 -0400
Content-Disposition: inline
In-Reply-To: <20100531094704.GB10283@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm, ext2 doesn't seem to be too happy these days:

235 2s ...[ 3091.091422] EXT2-fs (vdb6): warning: mounting unchecked fs,
running e2fsck is recommended
@@ -1,20 +1,11 @@
 QA output created by 235
+repquota: Illegal reference (6 >= 6) in user quota file on /dev/vdb6. Quota file is probably corrupted.
+Please run quotacheck(8) and try again.
 *** Report for user quotas on device [SCR_DEV]
 Block grace time: 7days; Inode grace time: 7days

...
