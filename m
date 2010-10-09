From: Jan Kara <jack@suse.cz>
Subject: [PATCH RFC 0/3] Block reservation for ext3
Date: Sat,  9 Oct 2010 02:12:24 +0200
Message-ID: <1286583147-14760-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925Ab0JIANm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Oct 2010 20:13:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  currently, when mmapped write is done to a file backed by ext3, the
filesystem does nothing to make sure blocks will be available when we need
to write them out. This has two nasty consequences:
  1) When flusher thread does writeback of the mmapped data, allocation
     happens in the context of flusher thread (i.e., as root). Thus user
     can effectively arbitrarily exceed quota limits or use space reserved
     only for sysadmin.
  2) When a filesystem runs out of space, we just silently drop data on the
     floor (the same happens when writeout is performed in the context of
     the user and he hits his quota limit).

  I think these problems are serious enough (especially (1) about which I was
notified lately) so that we try to fix them in ext3. The trouble is that the
fix in non-trivial. We have to basically implement delayed allocation for ext3
- block reservation happens on page_mkwrite() time and we convert the
reservation into a real allocation during writeout. Note: Of course, we could
use a much simpler solution and just do block allocation directly at
page_mkwrite() time but that really cripples performance for loads that do
random writes via mmap - I've tried that some time ago.
  The patches in this series (against 2.6.26-rc7) implement this. They
survived some testing with fsx-linux, I'll do more and also some performance
testing.
  So I'd like to hear what other people think about this. Reviews or
testing are welcome ;)

								Honza
