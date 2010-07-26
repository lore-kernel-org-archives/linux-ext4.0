From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Mon, 26 Jul 2010 13:59:59 GMT
Message-ID: <201007261359.o6QDxxnl026714@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49829 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0GZOAA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jul 2010 10:00:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6QDxxii026715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 13:59:59 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #8 from Jan Kara <jack@suse.cz>  2010-07-26 13:59:55 ---
Hmm, looking at the original report referenced, my patches need not fix this
particular warning. This particular warning rather looks like a race when
udisks-part-id manages to read the device (and touch it's atime) before
sd_probe_async runs and registers the bdi (via add_disk()). That seems to be
possible as device_add() is run before we even schedule to run sd_async_probe()
in a separate thread.

Jens, any idea how this should be fixed? I believe we should avoid this race
because we should better have the device's queue fully set up before allowing
IO to it... But I'm far from fully understanding this area...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
