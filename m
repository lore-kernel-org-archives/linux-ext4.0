From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Thu, 24 Jan 2013 23:13:13 -0500
Message-ID: <20130125041313.GF28908@thunk.org>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45390 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3AYENS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 23:13:18 -0500
Content-Disposition: inline
In-Reply-To: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 11:21:56AM -0500, Phillip Susi wrote:
> ext2fs_llseek() was using lseek instead of lseek64.  The
> only time it would use lseek64 is if passed an offset that
> overflowed 32 bits.  This works for SEEK_SET, but not
> SEEK_CUR, which can apply a small offset to move the file
> pointer past the 32 bit limit.
> 
> The code has been changed to instead try lseek64 first, and
> fall back to lseek if that fails.  It also was doing a
> runtime check of the size of off_t.  This has been moved to
> compile time.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Applied, although I had to make a small change so that in the case
where llseek doesn't exist, we need to retry with lseek immediately.
Also, in the fallback case, we still need to make the runtime check to
assure that the requested offset is less than off_t.

On the 1.43 branch it probably makes sense to get rid of the whole
mess with my_llseek and just use llseek64 directly.  There's a bunch
of complexity here which because over a decade ago, glibc had a buggy
header files which caused llseek64 to malfunction (which is why I
didn't enable use of llseek64 and > 2GB file system support in the
first place), and the Debian developer at the time tried to be too
clever and shipped a patched version of e2fsprogs which tried to use
llseek64 without consulting me first, and then users started losing
data and having the file systems corrupted as a result.

So as a result, because I couldn't trust glibc to give me a non-buggy
version of llseek64, and Debian users were losing data in real time, I
had e2fsprogs call the system call directly.  It's been a long time
since systems with this particular glibc Fail have been around, so
eventually I should rip out a lot of this mess.

       	   				- Ted
