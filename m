From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29492] kernel BUG at
 /home/kernel-ppa/COD/linux/fs/inode.c:1421!
Date: Sun, 20 Feb 2011 01:14:40 GMT
Message-ID: <201102200114.p1K1EepX029889@demeter1.kernel.org>
References: <bug-29492-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:57550 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1BTBOl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 20:14:41 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1K1Efqx029890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Feb 2011 01:14:41 GMT
In-Reply-To: <bug-29492-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29492


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #2 from Eric Sandeen <sandeen@redhat.com>  2011-02-20 01:14:37 ---
void iput(struct inode *inode)
{
        if (inode) {
                BUG_ON(inode->i_state & I_CLEAR); <<<<<<<<<

but this doesn't look like an ext3 bug to me; fuse is in the backtrace, not
ext3.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
