From: Jan Kara <jack@suse.cz>
Subject: Journal async commit broken for data=ordered?
Date: Tue, 14 Feb 2012 16:55:36 +0100
Message-ID: <20120214155536.GA16561@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2BNPzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Feb 2012 10:55:39 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I've just realized that JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT breaks
guarantees of data=ordered mode in ext4. The problem is that async commit
code assumes that when a checksum of a transaction in the journal matches,
all necessary data is on disk. This is true for metadata but need not be so
for data - the whole transaction may be correctly on pernament storage
while some data is still sitting in drive's caches. Thus if a power failure
happens at that moment, we have broken guarantees of data=ordered mode.
Seeing that async commit code isn't used by default anyway (I remember
there used to be some problems with it), shouldn't we just rip it out?

								Honza
