From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Tue, 22 Feb 2011 12:30:05 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102221225300.3499@dhcp-27-109.brq.redhat.com>
References: <bug-29402-13602@https.bugzilla.kernel.org/> <201102220410.p1M4AYr4019669@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab1BVLae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 06:30:34 -0500
In-Reply-To: <201102220410.p1M4AYr4019669@demeter2.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Feb 2011, bugzilla-daemon@bugzilla.kernel.org wrote:

> Unfortunately, I omitted the argument, and that's what's confusing you.

That's what I was afraid of. Fortunately we know where to look now. It
seems that the problem is really in the lazy init code in ext4. It is
possible that due some locking problem we might be zeroing existing
inode. Did you tried to run fsck on that filesystem after the crash ?

Thanks!
-Lukas
