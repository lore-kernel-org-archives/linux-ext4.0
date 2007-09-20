From: Jan Kara <jack@suse.cz>
Subject: Avoid rec_len overflow with 64KB block size
Date: Thu, 20 Sep 2007 16:32:14 +0200
Message-ID: <20070920143214.GC1986@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <sho@tnes.nec.co.jp>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34029 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbXITOcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 10:32:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

   Hello,

  when converting ext4 directories to pagecache I just came over
Takashi's patch preventing overflowing of rec_len. Looking over the
patch - can't we do it more elegantly by using say 0xffff instead of 64K
and perform conversion (using some helper) at the moment we read / store
rec_len? That would be IMHO more transparent than current approach (at
least it took me some time to understand what's going on with the
current patch when I was looking at the code)...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
