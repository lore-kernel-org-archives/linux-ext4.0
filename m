From: Theodore Ts'o <tytso@mit.edu>
Subject: Some jbd2 philosophy about credits estimation and other things
Date: Tue, 4 Jul 2017 13:54:41 -0400
Message-ID: <20170704175441.ljipnhmgli6npdt6@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com, ebiggers3@gmail.com,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        tahsin@google.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46884 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbdGDRyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Jul 2017 13:54:49 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm going to be making some changes to two recent feature patches (the
largedir feature patch and the xattr duplication patch) to fix up some
potential bugs caused by under-estimating the number of credits needed
which can cause ext4 to get quite unhappy:

EXT4-fs: ext4_xattr_block_set:2023: aborting transaction: error 28 in __ext4_handle_dirty_metadata
EXT4-fs error (device dm-2): ext4_xattr_block_set:2023: inode #131078: block 589866: comm fsstress: journal_dirty_metadata failed: handle type 10 started at line 2411, credits 5/0, errcode -28

While I was looking into this, I realized that there are some
implementation details about how the jbd2 layer works that haven't
written down, and it might be useful to document it for everyone.
(This probably needs to go into the ext4 wiki, with some editing.)

In general, under-estimating of the number of credits needed is far
worse than over-estimating.  Under-estimating can cause the above,
which will end up marking the file system corrupt.  We can actually do
better; in fact, we probably ought to do is to try to see if we can
extend the transaction, print an ext4 warning plus a WARN_ON(1) to get
a stack dump.  If we can't continue, we will have to force an
ext4-error and abort the journal, since if we run out of space, we can
end up in a deadlock: in order to free space in the journal, we need
to do a commit, but we can't do a commit because handles are open and
we can't complete them because we're out of space.

Also, a typical transaction has room for thousands of blocks, and a
handle is usually only open for a very short time.  Once a handle is
stopped, any unused credits are released back to the journal.  For
this reason, if we estimate that we need to modify 20 blocks
(credits), but we only need to modify 8 blocks, 4 of which have
already been modify in the current transaction --- this is not a
tragedy.  We only used up 4 new blocks in the journal by the time the
handle is stopped, but that's OK.  Once the handle is stopped the
"cost" of the over-estimation is gone.

What is the "cost" of the over-estimation?  Well, we need to make sure
that there will be enough room in the journal to write the current
transaction (plus have some slack space for the next transaction).  So
if we vastly over-estimate the number of blocks needed when we start a
handle, and the sum of all of the credits of currently started handles
is greater than free space in the journal minus some slack space,
instead of starting the new handle, the thread will block, and all
attempts to start new handles will block, until all of the currently
running handles have completed and a current transaction can start
committing.

So over-estimating by a few 10's of credits is probably not noticeable
at all.  Over-estimating by hundreds of credits can start causing
performance impacts.  How?  By forcing transaction to close earlier
than the normal 5 second timeout due of a perceived lack of space,
when the journal is almost full due to a credit over-estimation.  Even
so, the performance impact is not necessarily that great, and
typically only shows up under heavy load --- and we or the system
administrator can mitigate this problem fairly easily by increasing
the journal size.

So while there may be a desire out of professional pride to make the
credit estimation be as accurate as possible, getting the credit
estimation exactly write is not really critical.  It's for this reason
that we always add EXT4_INDEX_EXTRA_TRANS_BLOCKS to the credits
without testing to see if the HTree feature is enabled.  An extra 8
(soon to be 12) blocks doesn't really matter all that much.

The reason why we do try to do conditionalized credits based on quotas
is because when quota is enabled, some of the calculations for the
number of credits that are needed were extremely high.  This was
partially addressed by Jan Kara's change to move the call to
dquot_initialize to a separate transaction.  (eb9cc7e16b3: ext4: move
quota initialization out of inode allocation transaction)

The inode allocation path is still one where if we can reduce number
of credits needed, it can be a win.  (It currently has a worst case of
around 200 blocks, per Jan's comments in eb9cc7e16b3.)  Fortunately,
there are some assumptions we can make about inode allocation to
simplify things: (a) the acl will be a duplicate of the directory's
default acl; (b) the SELinux label is generally not that huge, and (c)
the encryption metadata is also fairly small, and (d) there is no
pre-existing inline data to worry about.  All of this means that we
don't need to worry about the inline data or EA-in-inode features, and
so we can probably rely on EXT4_XATTR_TRANS_BLOCKS estimate instead of
using more complex calculations found in __ext4_xattr_set_credits().

Cheers,

						- Ted
