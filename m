From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext3 improvements for 2.6.31-rc8
Date: Tue, 25 Aug 2009 14:45:44 +0200
Message-ID: <20090825124544.GD405@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZHYMpn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 08:45:43 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Jan Kara (1):
      ext3: Improve error message that changing journaling mode on remount is not possible

Theodore Ts'o (1):
      ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED

The diffstat is

 fs/ext3/Kconfig |   32 +++++++++++++++++---------------
 fs/ext3/super.c |   40 +++++++++++++++++++++++++++-------------
 2 files changed, 44 insertions(+), 28 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
