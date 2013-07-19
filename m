From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v1 0/5] ext4: Shut down block groups when damage is detected
Date: Fri, 19 Jul 2013 16:55:32 -0700
Message-ID: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36349 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3GSXzk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jul 2013 19:55:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Right now, ext4 doesn't do quite a good enough job shutting off allocation and
freeing activity in block groups when damage is detected, which means that ext4
can obliviously load a corrupt bitmap, base allocation decisions off of that,
and trash the filesystem.  We'd like to be able to freeze the block group when
this happens, so hopefully the next fsck can repair the damage.

The first patch fixes the behavior that a corrupt bitmap can be returned to
mballoc as if it was accurate.  The second patch is a trivial fix, and the two
after it provide for detecting damage in either the block bitmap or the inode
bitmap, and disabling all allocation/deallocation activity in the block group.
The final patch changes runtime block group descriptor validation failure
behavior to use the corruption flag to mark off the block group.

This patchset has been tested (albeit lightly) against 3.11-rc1 on x64.  I'm
wondering about a few things -- if we detect corrupt *inodes*, should we invoke
this mechanism as well?  Second, as I mentioned a few days ago, maybe it's time
for block_validity to be set always, since it seems to have a low speed impact?
Third, the block bitmap corruption flag patch is based off of Aditya Kali's
patch that you forwarded; can a proper Signed-off-by be attached since I mostly
just massaged that one into 3.11?

Comments and questions are, as always, welcome.

--D
