From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Two JBD cleanups
Date: Mon,  3 Aug 2009 23:06:54 +0200
Message-ID: <1249333616-23442-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbZHCVG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 17:06:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  below come two cleanups to ext3/JBD. The first patch removes Stephen Tweedie
from Maintainers entry of JBD and ext3. The second patch makes JBD use unsigned
int to store block numbers instead of unsigned long and thus saves a few bytes
on stack / in memory on 64-bit archs as Andrew and Ted suggested.
  I'll push these changes to linux-next if nobody objects. I'd welcome review
especially on the second patch.

									Honza
