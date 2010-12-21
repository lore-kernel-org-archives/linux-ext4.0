From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 04:05:21 GMT
Message-ID: <201012210405.oBL45LrG021745@demeter2.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54063 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933493Ab0LUEFW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 23:05:22 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBL45Lag021746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 04:05:21 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2010-12-21 04:05:20 ---
On Mon, Dec 20, 2010 at 08:56:46PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> 
> Using resize2fs on an ext4 will result in a corrupted filesystem. This is a
> regression (obviously).

Yes, this is a regression new to 2.6.37-rc1, which was introduced by
commit a31437b85: ext4: use sb_issue_zeroout in setup_new_group_blocks.

When we replaced the loop zero'ing the inode table blocks with
sb_issue_zeroout, we accidentally also removed this little tidbit:

-               ext4_set_bit(bit, bh->b_data);

... which was responsible for setting the block allocation bitmap to
reserve the block descriptor blocks and inode table blocks.  Oops...

I believe this patch should fix things.

                        - Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
