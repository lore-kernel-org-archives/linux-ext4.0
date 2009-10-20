From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Fix fsync bug in ext3 and ext4
Date: Tue, 20 Oct 2009 09:24:34 +0200
Message-ID: <1256023478-746-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, chris.mason@oracle.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZJTHZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 03:25:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  the patch series below fixes the problem ext3 and ext4 has that we
rely on inode dirty bits for correct fsync. This has two problems:
a) ext3 and ext4 often does not set them (as they call ext?_mark_inode_dirty)
   and thus only quota code sets the dirty bit as a sideeffect.
b) pdflush can come in and clear the dirty bit any time (thanks to Chris
   for pointing out this).

  The second and third patch in the series are just minor bug fixes to ext4.
I did some basic testing to verify that the code does what I'd expect it to
do but an extra pair of eyes checking the new code would be helpful...

                                                                Honza

