From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: fallocate creating fragmented files
Date: Fri, 01 Feb 2013 22:33:21 +1100
Message-ID: <1359718401.21008.140661185473973.37F5D749@webmail.messagingengine.com>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com> <20130130201412.GA32724@thunk.org>
 <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
 <20130130214359.GD32724@thunk.org>
 <1359586282.5428.140661184689977.65F0D7DE@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Linux Ext4 mailing list <linux-ext4@vger.kernel.org>
To: Robert Mueller <robm@fastmail.fm>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52542 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab3BALdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2013 06:33:22 -0500
In-Reply-To: <1359586282.5428.140661184689977.65F0D7DE@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013, at 09:51 AM, Robert Mueller wrote:
> Also, while e4defrag will try and defrag a file (or multiple files), is
> there any way to actually defrag the entire filesystem to try and move
> files around more intelligently to make larger extents? I guess running
> e4defrag on the entire filesystem multiple times would help, but it
> still would not move small files that are breaking up large extents. Is
> there any way to do that?

In particular, the way that Cyrus works seems entirely suboptimal for ext4.
The index and database files receive very small appends (108 byte per message
for the index, and probably just a few hundred per write for most of the the
twoskip databases), and they happen pretty much randomly to one of tens of
thousands of these little files, depending which mailbox received the message.

This causes allocation patterns which result in tons of tiny holes over time
as files get deleted, so the filesystem is kind of evenly scattered all over.

Here's the same experiment on a "fresh" filesystem.  I created this by taking
a server down, copying the entire contents of the SSD to a spare piece of rust,
reformatting, and copying it all back (cp -a).  So the data on there is the
same, just the allocations have changed.

[brong@imap15 conf]$ fallocate -l 20m testfile
[brong@imap15 conf]$ filefrag -v testfile
Filesystem type is: ef53
File size of testfile is 20971520 (20480 blocks, blocksize 1024)
 ext logical physical expected length flags
   0       0 22913025            8182 unwritten
   1    8182 22921217 22921207   8182 unwritten
   2   16364 22929409 22929399   4116 unwritten,eof
testfile: 3 extents found

As you can see, that's slightly more optimal.  I'm assuming 8182 is the
maximum number of contiguous blocks before you hit an assigned metadata
location and have to skip over it.

So in other words, our 2 year old filesystems are shot.  We need to do
this sort of "defrag" on a semi-regular basis.  Joy.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

