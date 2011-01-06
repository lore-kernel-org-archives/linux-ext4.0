From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: Problems with e4defrag -c
Date: Thu, 06 Jan 2011 16:24:08 +0900
Message-ID: <4D256E18.3010708@sx.jp.nec.com>
References: <E1PWFc1-0002cm-QV@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48302 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1AFH1j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jan 2011 02:27:39 -0500
In-Reply-To: <E1PWFc1-0002cm-QV@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thanks for your comments.

> First of all, explicit comparisons against the current uid is bad.  A
> non-root user might have read/write access to the raw device where a
> file sysem is located.  It's bad to encode an assumption one way or
> another into a userspace program.  Secondly, whenever a userspace progam
> is explicitly trying to encode permission checking, that's a red flag.

I will fix it.

> I'm not sure why checking to see if a file's st_uid matches the
> current_uid has any validity at all.

e4defrag tries to change the location of data blocks, so I assumed that
non-root users should execute e4defrag only to their file. It would be better
that users who have read/write permission can e4defrag to the file.

> What really matters are the number of extents which are non-tail
> extents, and smaller than some threshold (probably around 256 MB for
> most HDD's), and not forced by skips in the logical block numbering
> (i.e., caused by a file being sparse).  The basic idea here is to go
> back to why fragments are bad, which is that they slow down file access.
> If every few hundred megabytes, you need to seek to another part of the
> disk, it's really not the end of the world.

What does 256MB mean? If "some threshold" means the maximum size of one extent,
I think the size is 128MB.

> There's a more general question which is I'm not sure how much the
> functionality of e4dfrag -c really belongs in e4defrag.  I'm thinking
> perhaps that perhaps this functionality should instead go in filefrag,
> and/or in e2fsck, which can do the job much more efficiently since it by
> definition has direct access to the file system, so it can scan the
> inode tables in order.

Currently, e2fsprogs has two commands that report how badly fragmented
a file might be. So, it is smart for e2fsprogs to drop -c option from e4defrag.
e4defrag -c shows whether we need to execute e4defrag or not. For this, I think
we should add "fragmentation score" included in e4defrag -c to the output of
filefrag.

However, sometimes we want to check the fragmentation not only for a single file
but also for many files in the same directory. e4defrag -c gets the extent
information of all files in a directory, and calculates the fragmentation score
based on this information. But I'm not sure that I should add this feature
to filefrag by adding new option or some other way.

Regards,
Kazuya Mio

