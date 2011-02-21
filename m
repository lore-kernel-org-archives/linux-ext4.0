From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Mon, 21 Feb 2011 16:52:15 GMT
Message-ID: <201102211652.p1LGqFvH010194@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40816 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1BUQwQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 11:52:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1LGqFfa010195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 16:52:15 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402





--- Comment #2 from Lukas Czerner <lczerner@redhat.com>  2011-02-21 16:52:14 ---
On Fri, 18 Feb 2011, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> These panics can be suppressed by using -E lazy_itable_init at mkfs time.  The
> test system survived two series of 10 ffsb tests beginning with a single mkfs
> each.  Subsequently, the system survived a run of about 16 hours in which a
> complete scalability measurement pass was made
> 

Hi Eric,

Are you saying that it works fine (without panic) with lazy_itable_init
feature enabled ? I am confused now, because in the first trace
"spinlock bad magic: ext4lazyinit" the ext4lazyinit thread is obviously
running. When the ext4lazyinit thread is running, it means that inode
table was not zeroed, hence kernel thread (ext4lazyinit) is trying to do
the job. Am I missing something ?

Note that on the kernel which supports lazy itable initialization
(/sys/fs/ext4/features/lazy_itable_init exists) the mke2fs (since
v1.41.12-50-g210fd2c) will skip inode table initialization
automatically (it is the same as you would specify -E lazy_itable_init).

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
