From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [Bug 29402] New: kernel panics while running ffsb scalability
 workloads on 2.6.38-rc1 through -rc5
Date: Mon, 21 Feb 2011 16:52:45 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102211640350.5715@dhcp-27-109.brq.redhat.com>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab1BUPxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 10:53:10 -0500
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
