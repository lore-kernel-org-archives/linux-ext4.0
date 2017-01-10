From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: Mon, 9 Jan 2017 22:40:50 -0500
Message-ID: <20170110034050.do5q5d4feuqqhgj3@thunk.org>
References: <20170108224114.27157.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56696 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755084AbdAJDkw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Jan 2017 22:40:52 -0500
Content-Disposition: inline
In-Reply-To: <20170108224114.27157.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 08, 2017 at 05:41:14PM -0500, George Spelvin wrote:
> After replacing a drive in a RAID array, I tried to bring some things
> up to date with rsync and ran into an annoyingly repeatable deadlock.

Thanks for the bug report!  I'm able to reproduce this, so it's a
matter of my tracking down the bug.

In the meantime, do you need a workaround?  If you're not using the
new project quota feature, I can send you a quick patch to disable
attempts to move the extended attributes to resereve space for the
project ID --- this is what is causing the deadlock.

	       	       	       	       - Ted
