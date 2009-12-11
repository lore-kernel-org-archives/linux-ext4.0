From: tytso@mit.edu
Subject: Re: Potential data consistency issue with ASYNC_COMMIT feature
Date: Fri, 11 Dec 2009 15:52:54 -0500
Message-ID: <20091211205254.GH31139@thunk.org>
References: <FA695DF7-1D78-471A-A527-0079C045AF09@linuxhacker.ru>
 <6375EE02-90AB-442B-B079-E44D0D0FC346@linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>,
	Andreas Dilger <adilger@Sun.COM>
To: Oleg Drokin <green@linuxhacker.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34589 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbZLKUwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 15:52:51 -0500
Content-Disposition: inline
In-Reply-To: <6375EE02-90AB-442B-B079-E44D0D0FC346@linuxhacker.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 11, 2009 at 02:14:01AM -0500, Oleg Drokin wrote:
> Whoops, nevermind, it seems blkdev_issue_flush after commit does the
> barrier, I see it now.  It's just rhel5 kernel that is affected.

Yeah, the original ASYNC_COMMIT was totally unsafe, for the reason you
suggested; I was able to trivially induce fs corruption after a crash.
However, with the fixed async_commit code, in combination with journal
checksums, we can reduce the number of barrier ops per commit from two
to one, which increases the fs_mark by 50% (i.e., from 30 ops/sec to
45 ops/sec on a laptop hard drive).

However, journal checksums failed horribly when we tried to enable
them by default during the last merge window, because of bugs in ext4
where we were modifying certain metadata blocks (in particular
superblock and xattr's) without journalling them.  (Note to self; we
need to back port those fixes to ext3; the lack of journalling in
xattr in particular could mean that in some cases we could lose some
updates that could affect SELINUX after a crash.)

I think we fixed them all for 2.6.33, but we haven't had time to do
the necessary testing before we enable journal checksums by default,
and after additional testing, I'd like to enable async commit by
default as well, since it means we'll beat the pants off of all of the
other journalling file systems (XFS and JFS are doing two barrier ops
per commit, if I recall correctly; not sure about btrfs) at least on
that particular benchmark.  Unfortunately, we probably won't be able
to do that for 2.6.33; hopefully 2.6.34.

						- Ted
