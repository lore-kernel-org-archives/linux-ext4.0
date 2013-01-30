From: Robert Mueller <robm@fastmail.fm>
Subject: Re: fallocate creating fragmented files
Date: Thu, 31 Jan 2013 09:51:22 +1100
Message-ID: <1359586282.5428.140661184689977.65F0D7DE@webmail.messagingengine.com>
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
	Bron Gondwana <brong@fastmail.fm>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50750 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757239Ab3A3WvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 17:51:23 -0500
In-Reply-To: <20130130214359.GD32724@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> The most likely reason is that it depends on transaction boundaries.
> After a block has been released, we can't reuse it until after the
> jbd2 transaction which contains the deletion of the inode has
> committed.  So even after you've deleted the file, we can't reuse the
> blocks right away.  The other thing which will influence the block
> allocation is which block group the last allocation was for that
> particular file.  So if blocks become available after a commit
> completes, if we've started allocating in another block group, we
> won't go back to the initial block group.

Ok, makes sense.

However it still doesn't answer the question about why the allocator is
choosing smaller extents over larger ones nearby.

For instance, looking at filefrag -v for testfile and testfile2 again.
Remember, these were created immediately one after another.

testfile:
...
 398   18841 44779580 44779043     26 unwritten
 399   18867 44780335 44779606     26 unwritten
 400   18893 44780658 44780361     26 unwritten

testfile2:
...
  13     814 44792388 44788982    189 unwritten
  14    1003 44792578 44792577    157 unwritten

Those look quite near each other. So when testfile1 was being allocated,
there were some bigger extents right nearby that were ignored, and ended
up being used when the next file testfile2 was allocated. Why?

Also, while e4defrag will try and defrag a file (or multiple files), is
there any way to actually defrag the entire filesystem to try and move
files around more intelligently to make larger extents? I guess running
e4defrag on the entire filesystem multiple times would help, but it
still would not move small files that are breaking up large extents. Is
there any way to do that?

Rob
