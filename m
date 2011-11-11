From: Jan Kara <jack@suse.cz>
Subject: Re: ext3/4: BUGS in changing journal mode in flight
Date: Fri, 11 Nov 2011 16:26:51 +0100
Message-ID: <20111111152651.GD5050@quack.suse.cz>
References: <CAGBYx2YaJZqCgC6akmUm-NF7RgXGZJSyZxeWpW1KYeh09egkbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1KKP1S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Nov 2011 10:27:18 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2YaJZqCgC6akmUm-NF7RgXGZJSyZxeWpW1KYeh09egkbw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 11-11-11 16:20:21, Yongqiang Yang wrote:
> Both ext3 and ext4 have an attribute 'j', thus users can change
> journal mode of a file in flight.  However, neither ext3 or ext4
> supports the feature rightly, specifically file systems will be
> mounted RO due to I/O error in journal.  The error happens like this:
  I suppose you have tested this, right?

> when the journal mode of a file is changed from ordered to journaled,
> then data blocks will be revoked in truncate, if the revoked block was
> allocated as meta blocks last time, then its revoked flag is not
> cleared, so revoke on a revoked buffer happens, then journal report an
> I/O error.
  So let me check whether I understand the problem: We have a buffer that
has been previously used for metadata, then truncated (BH_Revoked set),
allocated as data, switched the inode to journal mode, and then deletion of
the inode causes error because we try to revoke a buffer with BH_Revoked
set. Nasty.

> Now revoked flag is cleared in get_access, actually it can be cleared
> immediately after the transaction is closed(non-current transaction).
  I'm not sure what you mean by closed but there is a difference between a
BH_Revoked flag and the fact whether the buffer is recorded as revoked in
the journal. If we concentrate on the flag, which is the problem here, then
the flag seems to be used as "is buffer revoked in the running trasaction".
Which means we can clear the flag as soon as we are done with adding
buffers to the transation.

> I can think of 3 solutions addressing the problem.
> 
> 1. clear revoked flag on a buffer when allocating a block.
>     This solution introduces overhead to ordered mode, because we have
> to look up dev's buffer every time. So I think the solution can be
> ignored.
>
> 2. clear revoked flag in commit_call_back function.
>    This solution has some overhead too.  in ext3 commit_call_back is
> not used at all, so changing to ext3 is not trivial.
> 
> 3. clear revoked flag in write_revoke_table.
>    IMHO, this solution is the best one.  We just need to add a field
> in in-memory journal super block pointing to the super block of host
> file system.
> 
> What's your opinions?
  Hum, maybe journal_switch_revoke_table() would be a better place than
write_revoke_table() to do the clearing. Or we could just add a separate
call just before journal_switch_revoke_table() which will also get a
superblock as a parameter so that we don't have to store it in the journal
structure.

  Thanks for spotting the problem!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
