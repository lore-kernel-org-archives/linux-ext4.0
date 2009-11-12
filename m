From: Jan Kara <jack@suse.cz>
Subject: [PULL] Build fix when ext3 is a module
Date: Thu, 12 Nov 2009 10:49:12 +0100
Message-ID: <20091112094912.GD14528@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZKLJtI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 04:49:08 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I'm wearing a brown paper bag for today... Could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Stefan Schmidt (1):
      fs/jbd: Export log_start_commit to fix ext3 build.

The diffstat is

 fs/jbd/journal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
