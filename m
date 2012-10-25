From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/2] Patch to address the ext4 corruption problem
Date: Thu, 25 Oct 2012 16:00:59 -0400
Message-ID: <1351195261-31258-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57598 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935352Ab2JYUBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 16:01:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the patch series I propose to send to Linus after I get
confirmation from either Toralf or Nix that this fixes the increased
incidence rate of this problem to pre-3.6.2 levels.  (Nix has found a
way to reproduce the problem with 3.6.1, but it seems that it's much
more easy with 3.6.2 and 3.6.3.)

The second patch fixes the problem which the original commit is
attempting to address, but in a way which does not change jbd2's
behavior in the case where the journal block device is not read/only.

Please review/comment/test; thanks!!

Theodore Ts'o (2):
  ext4: revert "jbd2: don't write superblock when if its empty"
  ext4: fix I/O error when unmounting an ro file system

 fs/jbd2/journal.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

