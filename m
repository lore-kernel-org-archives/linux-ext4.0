From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Wed, 29 May 2013 14:05:29 +0200
Message-ID: <1369829133-4307-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965866Ab3E2MFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 May 2013 08:05:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  while working on my patchset, I stumbled over an overflow bug which
made me do a quick audit of shifts in ext4 code. I've found a couple of
places which use << and which can overflow (usually on 32-bit
architecture only but at least SEEK_HOLE / SEEK_DATA bugs are real even
for 64-bit architectures). Patches in this series fix the issues I've
found. Likely this is also stable material so Ted, you might want to add
stable@vger.kernel.org to CC when merging the patches.

								Honza
