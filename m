From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: ext4_orphan_del() sleeps in non-journal mode
Date: Sat, 15 Sep 2012 15:51:21 -0700
Message-ID: <CAOMFOmVfm1mWTO3D58B-hPbkhuPL_tQ4WMT4fRwrb=2vGjuYMw@mail.gmail.com>
References: <CAOMFOmWB4yxj65N2x5+KREmiQBdPoWsTiA7EBW6ONPBOyFo11w@mail.gmail.com>
	<87zk4rwqg2.fsf@openvz.org>
	<CAOMFOmWh3CVdREk5uyPCxwFQBTopiqainfGYxC6HijieM1rEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38890 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2IOWvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Sep 2012 18:51:23 -0400
Received: by lbbgj3 with SMTP id gj3so3494367lbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Sep 2012 15:51:21 -0700 (PDT)
In-Reply-To: <CAOMFOmWh3CVdREk5uyPCxwFQBTopiqainfGYxC6HijieM1rEWA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

On Sat, Sep 15, 2012 at 3:28 PM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> D'oh, sorry.
>
> I did not realize that it is our local modification that calls
> ext4_orphan_del(NULL) from ext4_end_io_dio. So please ignore the issue
> "ext4_orphan_del sleeps in softirq context".
>
> But the other more general issue "ext4_orphan_del sleeps in no-journal
> mode" still applies. As Dmitry mentioned in this commit 3d287de3b828
> such sleep might degrade performance. In no-journal mode we do not
> need to manipulate with i_orphan list and no reason to take the mutex.
>
> I checked all ext4_orphan_del(NULL,...) usages and some of them look
> good for me, e.g.
>
>                 handle = ext4_journal_start(inode, 2);
>                 if (IS_ERR(handle)) {
>                         if (inode->i_nlink)
>                                 ext4_orphan_del(NULL, inode);
>
> In this example we take handle and important thing to note here is
> that IS_ERR(handle) can be true only in journal mode when starting
> journal failed. In non-journal mode ext4_journal_start() *always*
> returns a fake handle that is non-error (see ext4_get_nojournal). So
> the example above never sleeps in ext4_orphan_del().
>
> But there are other examples where sleep might happen (at current HEAD
> 3f0c3c8fe):
>
> inode.c:281
> inode.c:956
> inode.c:1069
> inode.c:1111
> inode.c:1177
>
> I think we need to fix these 5 places. In all other cases we check
> IS_ERR(handle) and thus do not call ext4_orphan_del() in no-journal
> mode.

Actually inode.c:1177 is also fine as we check ext4_handle_valid() in
this function above, thus this codepath can be never called in
no-journal mode. The other 4 places (and plus my local code) have
potential issues.

I am still trying to understand what is the semantics of
"ext4_orphand_del(NULL,...)". Does NULL mean

a) journaling is enabled, an error happened and we do not have a valid
handle anymore but we need to remove an added inode from orphan list.
In this case we should either check "EXT4_SB(sb)->s_journal" *before*
calling ext4_orphand_del, or introduce a flag that indicated the inode
was successfully added (like Dmitry made in 3d287de3).

b) and error happened and we need to remove inode from orphan list. In
this case ext4_orphand_del() is responsible for checking whether
journal is enabled.
