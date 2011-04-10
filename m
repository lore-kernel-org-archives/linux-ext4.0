From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] New: EXT4 causes corrupt BitTorrent downloads
Date: Sun, 10 Apr 2011 13:44:39 GMT
Message-ID: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54107 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1DJNok (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 09:44:40 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3ADidh3020719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 10 Apr 2011 13:44:39 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32972

           Summary: EXT4 causes corrupt BitTorrent downloads
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39-rc2+
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: damien@grassart.com
                CC: feng.tang@intel.com
        Regression: Yes


Using the Transmission BitTorrent client (version 2.11) with the most recent
kernel (2.6.39-rc2+), any torrent I try to download is corrupt. By using
Transmission's "Verify Local Data" functionality, I am able to reproduce this
consistently. During verification, the percent complete will reverse itself as
the verification process invalidates pieces that were just downloaded.

I was able to bisect the issue and track it down to this commit:

commit 6de9843dab3f2a1d4d66d80aa9e5782f80977d20
Author: Feng Tang <feng.tang@intel.com>
Date:   Wed Mar 23 14:05:03 2011 -0400

    ext4: remove redundant set_buffer_mapped() in ext4_da_get_block_prep()

    The map_bh() call will have already set the buffer_head to mapped.

    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f44307a..dec10e2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2502,7 +2502,6 @@ static int ext4_da_get_block_prep(struct inode *inode,
sector_t iblock,
                 * for partial write.
                 */
                set_buffer_new(bh);
-               set_buffer_mapped(bh);
        }
        return 0;
 }


I confirmed that reverting this commit makes the problem go away.

Thanks,
-Damien

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
