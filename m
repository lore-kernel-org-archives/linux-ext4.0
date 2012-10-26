From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 17:10:33 -0400
Message-ID: <20121026211033.GD8614@thunk.org>
References: <jXNl8-5m5-13@gated-at.bofh.it>
 <jXNOa-5MR-23@gated-at.bofh.it>
 <jXPGh-87s-5@gated-at.bofh.it>
 <jXTJW-4CH-55@gated-at.bofh.it>
 <jXUZj-6mo-13@gated-at.bofh.it>
 <jXVLH-7kO-5@gated-at.bofh.it>
 <jXW53-7CC-5@gated-at.bofh.it>
 <jXWeJ-7Lk-1@gated-at.bofh.it>
 <50882787.3030504@onlinehome.de>
 <508AEEF7.8060301@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org, gregkh@linuxfoundation.org
To: Martin <marogge@onlinehome.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57867 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123Ab2JZVKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2012 17:10:41 -0400
Content-Disposition: inline
In-Reply-To: <508AEEF7.8060301@onlinehome.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This looks very different.  The symptoms are quite different, and it's
most likely that an unclean shutdown is involved.  In your case,
you're doing clean shutdowns, with some suspend/resume cycles thrown
in.  Also, kernel version 3.5.5 doesn't have the commits that were
added between 3.6.1 and 3.6.3.

Are you running e2fsck to fix the file system consistency problems;
what is e2fsck reporting?

Do you need to have a suspend/resume in order to trigger the problem?

This could very be some kind of hardware problem or kernel bug related
to suspend/resume.  Unfortunately, many different problems get noticed
by the file system, but the root cause is can often be something else;
a hardware problem, or a bug somewhere else in the kernel.

Regards,

						- Ted

P.S.  Can you do us a favor and start a separate mail thread with the
information reposted?  It's can get hard to track different cases when
a lot of people assume that their random failure (some of which are
hardware problems) are related to the issue we are trying to track
down in this mail thread and then they all pile onto the same mail
thread or the same web forum --- one of the reasons why I detest
Ubuntu Launchpad.  Thanks!!
