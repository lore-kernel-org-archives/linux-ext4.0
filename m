From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Fri, 21 May 2010 02:07:11 GMT
Message-ID: <201005210207.o4L27B7r004287@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59857 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0EUCHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2010 22:07:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4L27BCu004288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 May 2010 02:07:11 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #27 from Eric Sandeen <sandeen@redhat.com>  2010-05-21 02:07:01 ---
static int pin_sb_for_writeback(struct writeback_control *wbc,
                                struct inode *inode, struct super_block **psb)
{
        struct super_block *sb = inode->i_sb;

        /*
         * If this sb is already pinned, nothing more to do. If not and
         * *psb is non-NULL, unpin the old one first
         */
        if (sb == *psb)
                return 0;
        else if (*psb)
                unpin_sb_for_writeback(psb);

        /*
         * Caller must already hold the ref for this
         */
        if (wbc->sync_mode == WB_SYNC_ALL || wbc->sb_pinned) {
                WARN_ON(!rwsem_is_locked(&sb->s_umount));  <<----- here
                return 0;
        }    

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=e913fc825dc685a444cb4c1d0f9d32f372f5986

is what Jens had upstream, and I think 

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=30fd1e551a730d942e91109762c942786be0ef7c

is the fix for the issue you see here...

> Even if the writeout itself isn't a data integrity operation, we need
> to ensure that the caller doesn't drop the sb umount sem before we
> have actually done the writeback.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
