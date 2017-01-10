From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: 10 Jan 2017 02:25:01 -0500
Message-ID: <20170110072501.1271.qmail@ns.sciencehorizons.net>
References: <20170110034050.do5q5d4feuqqhgj3@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@sciencehorizons.net, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:10624 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751430AbdAJHZE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2017 02:25:04 -0500
In-Reply-To: <20170110034050.do5q5d4feuqqhgj3@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Thanks for the bug report!  I'm able to reproduce this, so it's a
> matter of my tracking down the bug.

Hooray!  And thank you; I don't know why I hit so many ext4 bugs.

> In the meantime, do you need a workaround?  If you're not using the
> new project quota feature, I can send you a quick patch to disable
> attempts to move the extended attributes to resereve space for the
> project ID --- this is what is causing the deadlock.

If it's very little bother, I'd appreciate it, but if you expect to
have something more complete by the end of the week, I can wait
that long.

I didn't think I was using extended attributes at all, so the
limitation is fine.
