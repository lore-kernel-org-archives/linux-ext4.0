From: Jan Kara <jack@suse.cz>
Subject: ext2_discard_prealloc() called on each iput?
Date: Tue, 22 May 2007 18:11:27 +0200
Message-ID: <20070522161127.GC13633@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36288 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765302AbXEVQAR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2007 12:00:17 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  while fixing some problems with preallocation in UDF, I had a look how
ext2 solves similar problems. I found out that ext2_discard_prealloc() is
called on every iput() from ext2_put_inode(). Is it really appropriate? I
don't see a reason for doing so...
  Also I found slightly misleading the comment at ext2_release_file().
As far as I understand the code it isn't when /all/ files are closed but
rather when all fd's for given filp are closed. I.e. if you open the same
file two times, ->release will get called once for each open. Am I right?
If so, then also calling ext2_discard_prealloc() from ext2_release_file()
is suboptimal, isn't it?
					Thanks for answer
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
