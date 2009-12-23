From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] Ext4 quota fixes for 2.6.31 kernel
Date: Wed, 23 Dec 2009 18:27:51 +0100
Message-ID: <1261589276-1380-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZLWR2E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:28:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following five patches fix deadlocks, quota miscomputations, and such
in ext4 implementation of quota for 2.6.31 kernel.

								Honza

