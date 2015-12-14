From: Jan Kara <jack@suse.cz>
Subject: Reserved inodes
Date: Mon, 14 Dec 2015 11:50:40 +0100
Message-ID: <20151214105040.GE8474@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbbLNKuo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 05:50:44 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted,

could you please decide which way do we solve the problem of running out of
reserved inodes? Whether we raise the number of reserved inodes in the
superblock or whether we go down via the path of dedicated system
directory. I somewhat prefer the first solution and have submitted patches
[1] which enable (IMHO rather smooth) move in that direction. If you decide
for the second solution, so be it, I will support it anyway but we need a
final word to be said. Current situation only complicates the situation
with project quota patches and my orphan scalability series is blocked by
that as well for several months already...

								Honza

[1] http://lists.openwall.net/linux-ext4/2015/08/26/27

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
