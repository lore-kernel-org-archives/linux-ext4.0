From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11] ext4: Fix inode expansion code
Date: Wed,  3 Aug 2016 12:39:44 +0200
Message-ID: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbcHCKkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this patch series fixes code expanding size of inode. That code has been
seriously buggy and I think it has never worked for other case than expanding
legacy 128-byte inodes to larger ones. This patch series fixes all the issues
I have found and passes xfstest test I have written to excercise the code.

First four patches in the series fix the most serious issues leading to
crashes, memory, and possibly filesystem corruption. I have tagged these for
stable kernels since 4.4 (where the new inode field has been introduced
and started triggering issues in the inode expansion code).

The fifth patch also fixes a functional issue where we may unnecessarily fail
to expand inode, or may move too many xattrs but this issue is not so serious
and I don't expect it to happen too much in practice (since we usually expand
only by a couple of bytes) so I didn't tag it for stable.

Remaining patches in the series cleanup the code by removing bogus checks,
unused variables, and factoring out the large inode expanding function into
several smaller ones.

								Honza
