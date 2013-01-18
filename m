From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/12 v2] ext4: Several simplifications and fixes
Date: Fri, 18 Jan 2013 13:00:34 +0100
Message-ID: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3ARMA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  this patch series contains several simplifications of ext4 code I came across
when thinking how to simplify handling of uninitialized extents. The series has
somewhat grown since last time. I have quite a bit more patches in my tree
(e.g. removing the need for page pointers from ext4_ioend_t so the structure
shrunk a lot, moving of PageWriteback completion after extent conversion, ...)
but they need more work and I'm not sure they will be ready for the next merge
window. But I hope everything in this series should be simple enough so that
it can go in.

The series contains two fixes:
[PATCH 02/12] ext4: Use redirty_page_for_writepage() in ext4_bio_write_page()
and
[PATCH 11/12] ext4: Make ext4_bio_writepage() handle unprepared buffers
[PATCH 12/12] ext4: Fix ext4_writepage() to achieve data=ordered guarantees

The rest are simplifications and cleanups. In total the series removes ~250
LOC.

								Honza
