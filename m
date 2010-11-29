From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 01:29:30 -0600
Message-ID: <20101129072930.GA7213@burratino>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx>
 <20101126145327.GB19399@rivendell.home.ouaza.com>
 <20101126215254.GJ2767@thunk.org>
 <20101127075831.GC24433@burratino>
 <20101127085346.GD14011@rivendell.home.ouaza.com>
 <20101129041152.GQ2767@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f194.google.com ([209.85.160.194]:59021 "EHLO
	mail-gy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0K2IhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:37:23 -0500
Received: by gyd8 with SMTP id 8so3925350gyd.1
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:37:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20101129041152.GQ2767@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Ted Ts'o wrote:

> I did some experimenting, and I figured out what was going on.  You're
> right, (c) doesn't quite work, because delayed allocation meant that
> the writeout didn't take place until the fsync() for each file
> happened.  I didn't see this at first; my apologies.

Thanks for a clear analysis[1].  I am still confused about something,
though.  If the answer is "stop wasting my time, just read the source", I
can accept that.

>                        sync_file_range() is a Linux specific system
> call that has been around for a while.  It allows program to control
> when writeback happens in a very low-level fashion.  The first set of
> sync_file_range() system calls causes the system to start writing back
> each file once it has finished being extracted.  It doesn't actually
> wait for the write to finish; it just starts the writeback.

True, using sync_file_range(..., SYNC_FILE_RANGE_WRITE) for each file
makes later fsync() much faster.  But why?  Is this a matter of allowing
writeback to overlap with write() or is something else going on?

I'm thinking it has to be something else, since sync() is fast without the
sync_file_range().

> I've attached the program I used to test and prove this mechanism, as
> well as the kernel tracepoint script I used to debug why (c) wasn't
> working, which might be of interest to folks on debian-kernel.
> Basically it's a demonstration of how cool ftrace is.  :-)

Perhaps the answer can be phrased in terms of the output of this script.

> #!/bin/sh
> cd /sys/kernel/debug/tracing
> echo blk > current_tracer
> echo 1 > /sys/block/dm-5/trace/enable
> echo 1 > events/ext4/ext4_sync_file/enable
> echo 1 > events/ext4/ext4_da_writepages/enable
> echo 1 > events/ext4/ext4_mark_inode_dirty/enable
> echo 1 > events/jbd2/jbd2_run_stats/enable
> echo 1 > events/jbd2/jbd2_start_commit/enable
> echo 1 > events/jbd2/jbd2_end_commit/enable
> (cd /kbuild; /home/tytso/src/mass-sync-tester -n)
> cat trace > /tmp/trace
> echo 0 > events/jbd2/jbd2_start_commit/enable
> echo 0 > events/jbd2/jbd2_end_commit/enable
> echo 0 > events/jbd2/jbd2_run_stats/enable
> echo 0 > events/ext4/ext4_sync_file/enable
> echo 0 > events/ext4/ext4_da_writepages/enable
> echo 0 > events/ext4/ext4_mark_inode_dirty/enable
> echo 0 > /sys/block/dm-5/trace/enable
> echo nop > current_tracer

Jonathan

[1] http://lists.debian.org/debian-devel/2010/11/msg00577.html
