From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] ext4: Several simplifications
Date: Wed,  2 Jan 2013 18:45:39 +0100
Message-ID: <1357148744-4895-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3ABRpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 12:45:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  this patch series contains several simplifications of ext4 code I
came across when thinking how to simplify handling of uninitialized
extents. Since they are mostly independent, I'm submitting them now
for people to comment / merge them.

								Honza
