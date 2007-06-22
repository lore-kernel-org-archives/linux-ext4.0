From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/3] ext4: Extent code cleanup
Date: Fri, 22 Jun 2007 16:15:09 +0400
Message-ID: <20070622121509.GA395@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, devel@openvz.org
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:18716 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbXFVMOK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 08:14:10 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, i've finaly found time to review and test ext4 patches.
And i have some fixes:
[1] One more one line fix for ext4-block-reservation patch. IMHO
    it is better to merge it with my previous block reservation fixes.

[2] Fix compilation with EXT_DEBUG

[3] Some code cleanup
