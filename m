From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: fallocate creating fragmented files
Date: Thu, 31 Jan 2013 09:40:11 +1100
Message-ID: <1359585611.5124.140661184685613.5C09C3AB@webmail.messagingengine.com>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com> <20130130201412.GA32724@thunk.org>
 <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
 <20130130214359.GD32724@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Linux Ext4 mailing list <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Robert Mueller <robm@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38030 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216Ab3A3WkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 17:40:12 -0500
In-Reply-To: <20130130214359.GD32724@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013, at 08:43 AM, Theodore Ts'o wrote:
> On Thu, Jan 31, 2013 at 08:21:50AM +1100, Robert Mueller wrote:

(around now, was dropping the kids at school)

> > For that matter, one big question I have is why each of these results is
> > so different.
> > 
> > [robm@imap14 conf]$ for i in 1 2 3 4 5 6 7 8 9 10; do fallocate -l 20m
> > testfile3; filefrag testfile3; /bin/rm testfile3; done
> 
> The most likely reason is that it depends on transaction boundaries.
> After a block has been released, we can't reuse it until after the
> jbd2 transaction which contains the deletion of the inode has
> committed.  So even after you've deleted the file, we can't reuse the
> blocks right away.  The other thing which will influence the block
> allocation is which block group the last allocation was for that
> particular file.  So if blocks become available after a commit
> completes, if we've started allocating in another block group, we
> won't go back to the initial block group.

The particular directory we're doing this test in is a cyrus imapd "conf"
directory.  It contains mostly symlinks and sub directories (some of them
quite hot) but it also contains mailboxes.db, which is a very active
database file.  In this case it's twoskip, which is a skiplist-based file
format.

When any change is made to a twoskip file, the IO pattern is:

1) rewrite first 64 bytes (marking file dirty) and fdatasync
2) append new change/delete records and update back pointers (involves
   between 1 and 20 random rewrites of between 32 and 200ish bytes per
   change)
3) fsync
4) rewrite first 64 bytes (marking file clean again) and fdatasync

So we get two fdatasyncs, one fsync (to save the metadata about the
file being longer now) a bunch of random updates throughout the file,
and some amount of new data appended to the file.

Every so often the file contains too many obsolete records, and it gets
repacked.  This involves creating a new database file (mailboxes.db.NEW)
and walking through the original database copying each record to the new
database.  Finally, the new database is renamed over the old.

It uses flock on the entire file for serialisation, so there can only be
a single writer at a time.

Writes are done using seek and writev, reads are done by MMAPing the
entire file.

More detail about twoskip here if anyone cares:

http://opera.brong.fastmail.fm/talks/twoskip/

It's the twoskip files that we're particularly concerned about.  Not so
much that they fragment during use, that's kind of expected - but that a
repack doesn't result in a single contiguous file.  Apart from the header,
I can't see why it doesn't.

I could probably change the repack code to not do the two first fdatasyncs,
and just do a final fsync before renaming, if you think that initial fsync
of just a couple of hundred bytes (header plus initial dummy record) is
likely to mess up page allocation.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

