From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Thu, 18 Dec 2008 15:02:51 -0800 (PST)
Message-ID: <20081218230251.8C3C011D108@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbYLRXCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 18:02:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBIN2pu8030682
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 15:02:52 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #12 from sandeen@redhat.com  2008-12-18 15:02 -------
In a nutshell, with laptop mode on, we go down this path:

static void laptop_timer_fn(unsigned long unused)
{
        pdflush_operation(laptop_flush, 0);
}

static void laptop_flush(unsigned long unused)
{
        sys_sync();
}

which gets us to the new 

static int ext3_sync_fs(struct super_block *sb, int wait)
{
        sb->s_dirt = 0;
        if (wait)
                ext3_force_commit(sb);
...

which is then committing empty transactions.  Seems like we should be smart
enough to skip committing transactions w/ nothing in them...?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
