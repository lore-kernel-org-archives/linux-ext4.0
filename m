From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Mon, 16 Aug 2010 19:26:47 GMT
Message-ID: <201008161926.o7GJQls0011992@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48513 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab0HPT0s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Aug 2010 15:26:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7GJQlth011993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Aug 2010 19:26:47 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #24 from Eric Sandeen <sandeen@redhat.com>  2010-08-16 14:53:20 ---
Michael, if you can come up with any testcase (not including oracle) that shows
the problem, that'd be great.

However, I'd really suggest trying a current upstream kernel if possible just
to be sure you're not hitting an old bug.

It sounds very odd that writing into sparse space on file B would corrupt
writes to non-sparse file A...

There is an outstanding bug where non-fs-block aligned AIO to a sparse file can
cause corruption (related to partial zeroing of the block which is outside the
range of the IO, and this is not coordinated across multiple AIOs...) but this
corrupts the sparse file being written to, not other files in the filesystem.

I wonder if it's possible that oracle is using the tempfile as a data source,
somehow mis-reading 0s out of it, and writing those 0s to the main files?

Anyway, I think the current bug is well-understood and fixed, so if your
problem persists upstream I'd suggest opening a new bug.

You asked about XFS, do you see the same problem there?

Thanks,
-Eric

--- Comment #25 from Michael Tokarev <mjt@tls.msk.ru>  2010-08-16 19:26:39 ---
Well, it already was too difficult weekend (I had to migrate some large amount
of data but hit the issue which means the job isn't done still, at the end of
Monday)...

2.6.32 is current long-term-support kernel, and the patches mentioned in this
bug weren't applied to the version I'm using now.  So I'm not saying the bug is
present in current git version.

Yes, it is quite possible that 'orrible is reading corrupt data from tmp
filesystem - I didn't thought about that.

So I'll try to reproduce it later, when the thing will be done.

But the things seems to be quite clear now, this bug plus your explanation
(reading zeros from tmp) -- the zero pieces are all 64-blocks long, which is a
typical allocation unit in the data files.

Speaking of XFS.  I tried a few different things (just a few, because the whole
procedure takes large amount of time).  I used ext4 on raid0 just to load data
(to move the db off to another, final machine later) in a hope to speed things
up, usually we use XFS.  And finally I tried to switch to XFS and raid10 -
configuration which is used since ages on other machines - tried that before
finding this bugreport (I thought about the correlation between gaps and
corruption on ext4 later).  I'm not seeing problems with XFS so far (the load
is still ongoing), but I also tried hard to avoid the problematic case with
gapful files after reading this bugreport.  So I don't know if it were
problematic with XFS if I were not to avoid gaps.  But remember, I need to
complete the job... ;)

I asked about XFS because it is mentioned in this bugreport, with clear
indication that it has the problem as well as ext4.  So I wonder since when
that problem were present, well, just.. curious.

And by the way, what's the final patch for ext4 case for this?

Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
