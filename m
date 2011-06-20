From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 0/3] directory index patch set v2
Date: Mon, 20 Jun 2011 22:28:44 +0200
Message-ID: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@whamcloud.com, colyli@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39420 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1FTU2r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 16:28:47 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5KKSjqM028538
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 22:28:45 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series implements...

      ext4: Fix compilation with -DDX_DEBUG v2
      ext4 directory index: read-ahead blocks v2
      dx read-ahead: Map blocks with a single semaphore lock

TODO: 
- Fix compilatation of ext3 with -DDX_DEBUG.
- Use worker threads for read-aheads?


 Documentation/filesystems/ext4.txt |    6 ++
 fs/ext4/ext4.h                     |    3 +
 fs/ext4/inode.c                    |   95 ++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c                    |   84 ++++++++++++++++++++++++++++++--
 fs/ext4/super.c                    |   17 ++++++
 5 files changed, 199 insertions(+), 6 deletions(-)

