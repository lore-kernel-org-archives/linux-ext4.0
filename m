From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: Fix deadlock during page writeback
Date: Thu, 16 Jun 2016 12:42:12 +0200
Message-ID: <1466073736-30447-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbcFPKmX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 06:42:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

the first patch in the series fixes the deadlock during page writeback
spotted by Eryu. Other three patches somewhat improve the lockdep
instrumentations of transactions in JBD2. Originally I though we would
be able to catch the writeback deadlock with them but sadly that is not
the case as page locks / page writeback bits are not tracked by lockdep.
But still the result looks nicer and has more coverage so I think it is
worth it.

								Honza
