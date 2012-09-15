From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: ext4_orphan_del() sleeps in non-journal mode
Date: Sat, 15 Sep 2012 15:28:19 -0700
Message-ID: <CAOMFOmWh3CVdREk5uyPCxwFQBTopiqainfGYxC6HijieM1rEWA@mail.gmail.com>
References: <CAOMFOmWB4yxj65N2x5+KREmiQBdPoWsTiA7EBW6ONPBOyFo11w@mail.gmail.com>
	<87zk4rwqg2.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63604 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2IOW2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Sep 2012 18:28:21 -0400
Received: by lbbgj3 with SMTP id gj3so3489728lbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Sep 2012 15:28:19 -0700 (PDT)
In-Reply-To: <87zk4rwqg2.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

D'oh, sorry.

I did not realize that it is our local modification that calls
ext4_orphan_del(NULL) from ext4_end_io_dio. So please ignore the issue
"ext4_orphan_del sleeps in softirq context".

But the other more general issue "ext4_orphan_del sleeps in no-journal
mode" still applies. As Dmitry mentioned in this commit 3d287de3b828
such sleep might degrade performance. In no-journal mode we do not
need to manipulate with i_orphan list and no reason to take the mutex.

I checked all ext4_orphan_del(NULL,...) usages and some of them look
good for me, e.g.

		handle = ext4_journal_start(inode, 2);
		if (IS_ERR(handle)) {
			if (inode->i_nlink)
				ext4_orphan_del(NULL, inode);

In this example we take handle and important thing to note here is
that IS_ERR(handle) can be true only in journal mode when starting
journal failed. In non-journal mode ext4_journal_start() *always*
returns a fake handle that is non-error (see ext4_get_nojournal). So
the example above never sleeps in ext4_orphan_del().

But there are other examples where sleep might happen (at current HEAD
3f0c3c8fe):

inode.c:281
inode.c:956
inode.c:1069
inode.c:1111
inode.c:1177

I think we need to fix these 5 places. In all other cases we check
IS_ERR(handle) and thus do not call ext4_orphan_del() in no-journal
mode.
