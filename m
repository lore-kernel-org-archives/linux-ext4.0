From: Chris Mason <chris.mason@oracle.com>
Subject: ext4 writepages is making tiny bios?
Date: Tue, 1 Sep 2009 14:44:50 -0400
Message-ID: <20090901184450.GB7885@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:46675 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZIASox (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 14:44:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

I've been doing some benchmark runs to speed up btrfs and look at Jens'
new writeback work.  One thing that really surprised me is that ext4
seems to be making 4k bios pretty much all the time.

The test I did was:

dd if=/dev/zero of=/mnt/foo bs=1M count=32768

It was done under seekwatcher, so blktrace was running.  The blktrace
files for xfs and btrfs were about 60MB, but ext4 was almost 700MB.  A
looks at the trace shows it is because ext4 is doing everything in 4k writes,
and I'm tracing on top of dm so the traces don't reflect any kind of
merging done by the elevator.

This graph shows the difference:

http://oss.oracle.com/~mason/seekwatcher/trace-buffered.png

When tracing on dm, seekwatcher uses the completion events for IOPs, so
the huge io rate for ext4 just comes from using smaller ios to write the
same data.  Note the ext4 performance in this test is quite good, but I
think it would probably be better if it were making bigger bios.

A quick look at the code makes me think its trying to make big bios, so
I wanted to report it here in case things aren't working the way they
should.

(this version of seekwatcher isn't released yet, but you can grab it out
of the hg repo on linked from http://oss.oracle.com/~mason/seekwatcher)

-chris

