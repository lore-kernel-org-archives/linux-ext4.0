From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] Ext4 quota fixes for 2.6.32 -stable kernel
Date: Wed, 23 Dec 2009 18:25:03 +0100
Message-ID: <1261589108-17588-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZLWRZX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:25:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following five patches fix deadlocks, miscomputations, and similar
problems in ext4 implementation of quota.

								Honza

