From: iaw4 <ivo_welch@brown.edu>
Subject: why not allow checksumming of file contents, too?
Date: Fri, 13 Jun 2008 01:33:19 +0000 (UTC)
Message-ID: <loom.20080613T013006-144@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59450 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992AbYFMBfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 21:35:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K6yBy-0000DG-Pa
	for linux-ext4@vger.kernel.org; Fri, 13 Jun 2008 01:35:02 +0000
Received: from ip70-181-37-87.ri.ri.cox.net ([70.181.37.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 01:35:02 +0000
Received: from ivo_welch by ip70-181-37-87.ri.ri.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 01:35:02 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


there is already checksumming of metadata.  having a file-system option of
checksumming every file's contents upon closing the write would be very
convenient, too.  It would only take an extra few bytes in the file descriptor,
wouldn't it?  It would be nice insurance against hardware corruption.  zfs has
it, too, I believe.  just a suggestions from someone who is just an end user...




