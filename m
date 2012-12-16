From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sun, 16 Dec 2012 21:52:49 -0200
Message-ID: <50ce5ed5.8991ec0a.0f36.4b12@mx.google.com>
References: <kainf9$btc$1@ger.gmane.org>
	<20121216022753.GD9016@thunk.org>
	<50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
	<20121216035150.GA6104@thunk.org>
	<50cd5e9b.0839650a.221f.ffffc460@mx.google.com>
	<75A902DB-8A60-4CF5-982A-C32C5AB83C27@dilger.ca>
	<20121216145013.GA5098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52351 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2LPXwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Dec 2012 18:52:55 -0500
Received: by mail-yh0-f52.google.com with SMTP id o22so1096701yho.11
        for <linux-ext4@vger.kernel.org>; Sun, 16 Dec 2012 15:52:55 -0800 (PST)
In-Reply-To: <20121216145013.GA5098@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 16 Dec 2012 09:50:13 -0500
Theodore Ts'o <tytso@mit.edu> wrote:

> A fix for this was added to e2fsprogs in v1.42.2 in March 2012, by
> commit 26c09eb8145a1 ("e2fsck: check for zero length extent").  There
> was a regression which this commit would sometimes trigger which was
> fixed in v1.42.4 (commit 9c40d14841f0, "e2fsck: only check for
> zero-length leaf extents").  So e2fsck 1.42.4 or newer is recommended
> to repair this sort of file system corruption.

	Ok Ted. An easier way was to use Systemrescuecd beta which
provides e2fsck 1.42.6. Now the problem has gone ;)

> I'm not entirely sure how the inode had gotten corrupted in the first
> place, but I would be surprised if it was due to upgrading the kernel
> from 3.6 to 3.7.  If you do see this corruption again, please let us
> know, and hopefully we can try to figure out what the root cause of
> the issue might be.

	No problem. I always compile my software, so the first time I
notice it was after upgrading to 3.7.0 kernel. Anyway I'm not sure if
it appeared after the upgrade to 3.7.0 kernel.

	But ok. If I have some more of these issues, I will report here.

	Thanks for the great support!

-- 
Linux 3.7.0: Terrified Chipmunk
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br
