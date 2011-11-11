From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: ext3/4: BUGS in changing journal mode in flight
Date: Fri, 11 Nov 2011 16:20:21 +0800
Message-ID: <CAGBYx2YaJZqCgC6akmUm-NF7RgXGZJSyZxeWpW1KYeh09egkbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53435 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1KKIUW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Nov 2011 03:20:22 -0500
Received: by vcbf1 with SMTP id f1so3193506vcb.19
        for <linux-ext4@vger.kernel.org>; Fri, 11 Nov 2011 00:20:21 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan and Ted,

Both ext3 and ext4 have an attribute 'j', thus users can change
journal mode of a file in flight.  However, neither ext3 or ext4
supports the feature rightly, specifically file systems will be
mounted RO due to I/O error in journal.  The error happens like this:
when the journal mode of a file is changed from ordered to journaled,
then data blocks will be revoked in truncate, if the revoked block was
allocated as meta blocks last time, then its revoked flag is not
cleared, so revoke on a revoked buffer happens, then journal report an
I/O error.

Now revoked flag is cleared in get_access, actually it can be cleared
immediately after the transaction is closed(non-current transaction).

I can think of 3 solutions addressing the problem.

1. clear revoked flag on a buffer when allocating a block.
    This solution introduces overhead to ordered mode, because we have
to look up dev's buffer every time. So I think the solution can be
ignored.

2. clear revoked flag in commit_call_back function.
   This solution has some overhead too.  in ext3 commit_call_back is
not used at all, so changing to ext3 is not trivial.

3. clear revoked flag in write_revoke_table.
   IMHO, this solution is the best one.  We just need to add a field
in in-memory journal super block pointing to the super block of host
file system.

What's your opinions?

There are some other problems in ext4 when changing journal mode, such
as allocating dealloc blocks, but they can be addressed easily.

Yongqiang.
-- 
Best Wishes
Yongqiang Yang
