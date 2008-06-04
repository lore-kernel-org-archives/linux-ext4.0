From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 0/3] ext{2,3,4}: don't inherit inappropriate inode flags from parent
Date: Wed,  4 Jun 2008 13:46:25 +0100
Message-ID: <1212583588-5754-1-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1373 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYFDMqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 08:46:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866. It also prevents inheritance
of other flags that Andreas Dilger identified as inappropriate to inherit. I'll
follow up shortly with a separate set of patches to prevent flags being set on
inappropriate node types.

Cheers,
Duane.
