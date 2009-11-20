From: Jan Kara <jack@suse.cz>
Subject: norecovery option for ext3
Date: Fri, 20 Nov 2009 13:24:03 +0100
Message-ID: <20091120122403.GD15422@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZKTMX6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 07:23:58 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I've tried to test noload/norecovery option of ext3 and I've found it
simply does not work. The filesystem does not even mount. There are two
problems:
  1) the code checking for NOLOAD in ext3_fill_super is simply wrong
     and ends up failing the mount whenever NOLOAD is set with a message
     "ext3: No journal on filesystem on <dev>"
  2) if one fixes the check, we end up oopsing a few lines below when
     calling journal_check_available_features() with journal == NULL.

  Given that nobody used the option (OK, some googling shows that somebody
tried to use it in *2.4.9* kernel and it didn't work even there - Stephen
Tweedie comments that it's an obsolete option meant for use during fs
development) and seeing how badly corrupted the filesystem is when you
don't replay the journal, I'd just remove the option. Any opinions?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
