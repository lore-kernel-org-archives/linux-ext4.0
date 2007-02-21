From: Jan Kara <jack@suse.cz>
Subject: ext3 not writing inode flags
Date: Wed, 21 Feb 2007 15:22:16 +0100
Message-ID: <20070221142216.GD19607@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42165 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271AbXBUOWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Feb 2007 09:22:17 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  I've noticed that if e. g. S_IMMUTABLE flag is set on an inode, ext3
does not propagate it to its inode flags on write. This also leads to
the situation that lsattr reports no flag set but the file is in fact
immutable. Would a fix be accepted? Actually, the quota code is the
only place where S_IMMUTABLE flag is set to an inode so this is not a
big issue but still...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
