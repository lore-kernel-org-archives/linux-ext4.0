From: Frank Mayhar <fmayhar@google.com>
Subject: Data loss/corruption when using fallocate/ftruncate.
Date: Mon, 10 Aug 2009 11:59:30 -0700
Message-ID: <1249930770.22656.14.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:12830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZHJS7d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 14:59:33 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n7AIxXdO003110
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 11:59:33 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again, folks.  We've got an app that needs to use O_DIRECT for
performance and is using fallocate() to make sure the files are all in
one extent.  Unfortunately the end size isn't always the fallocated size
so it has to do a truncate when it's done; the sequence is generally:

	create(file)
	fallocate(file, KEEP_SIZE, 0, maxlen)
	write/write/write/write...
	fallocate(file, 0, 0. maxlen-minus a bit)
	ftruncate(file, actual-len)

We've been seeing some of these files end up all or partly zero after
(but not before) the truncate.  After further analysis, it's clear that
the last extent (possibly the only extent) is being marked uninit for
some reason.  The actual blocks on disk are nonzero but due to the
extent being marked uninit they are being read as zero.

Note that this isn't easy to reproduce; lots of other stuff is going on
when this happens.  Our feeling is that there's a race somewhere, quite
possibly between fallocate and ftruncate, but it's not clear.  Certainly
a single-threaded application doesn't see this, nor does an application
that uses mutexes to serialize access to the file.

This is a heads-up to point out a real problem.  We're still analyzing
and trying to track down the bug but it may take a little while.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

