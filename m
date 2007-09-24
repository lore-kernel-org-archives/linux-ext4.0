From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] Avoid rec_len overflow with 64KB block size
Date: Mon, 24 Sep 2007 19:37:38 +0200
Message-ID: <20070924173738.GF6871@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50892 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764168AbXIXRQ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 13:16:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  In the following series I'm sending patches to ext2, ext3 and ext4
solving possible overflow of rec_len when using 64KB blocksize. Minming,
would you add these to the patch queue? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
