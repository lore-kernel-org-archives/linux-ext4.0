From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix oops / warning when allocation of symlink fails
Date: Mon, 13 Jul 2009 21:29:25 +0200
Message-ID: <1247513367-5609-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbZGMT33 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 15:29:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  the two patches in this series fix a problem for ext3/ext4 when we fail
to allocate blocks for a symlink. In ext3 this could lead to a memory
corruption (since freed inode could remain on in-memory orphan list), in
ext4 just to some warnings on the next mount (Sigh. Ted was maybe right
we should always do ext?_orphan_del() regardless of calling truncate ;)).
  Ted, would you please merge the patch (or both if you like)? Thanks.

								Honza
