From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 00:05:06 -0700
Message-ID: <20080526000506.1d0fb047.akpm@linux-foundation.org>
References: <bug-421482-310856@https.bugzilla.mozilla.org/>
	<200805260513.m4Q5DAU8018498@mrapp54.mozilla.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbYEZHFj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 03:05:39 -0400
In-Reply-To: <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This:

On Sun, 25 May 2008 22:13:10 -0700 bugzilla-daemon@mozilla.org wrote:

> Do not reply to this email.  You can add comments to this bug at
> https://bugzilla.mozilla.org/show_bug.cgi?id=421482
> 
> 
> 
> 
> 
> --- Comment #152 from Karl Tomlinson (:karlt) <mozbugz@karlt.net>  2008-05-25 22:12:23 PDT ---
> Created an attachment (id=322475)
>  --> (https://bugzilla.mozilla.org/attachment.cgi?id=322475)
> fdatasync/sync_file_range test program
> 
> fdatasync/sync_file_range test program
> 
> This first creates a file of length 1 then does one fsync on the new file.
> Then the file is continually modified without changing the length and synced
> after each modification using one of three methods (somewhat randomly
> selected): fsync/fdatasync/sync_file_range.
> 
> The I/O load for the test results below was produced using dd with a small
> blocksize to limit the I/O some:
> 
> dd if=/dev/zero of=large bs=64 count=$((3*1024*1024*1024/64))
> 
> I used ltrace instead of strace as my strace didn't find sync_file_range (and
> my glibc-2.5 libraries don't seem to have a sync_file_range function), so
> sync_file_range appears below as "syscall(277".
> 
> rm -f datasync-test.tmp &&
> ltrace -t -T -e trace=,fsync,fdatasync,syscall ./a.out
> 
> 16:12:59 fsync(3) = 0                   <11.864858>
> 16:13:13 fdatasync(3) = 0               <14.706356>
> 16:13:30 fsync(3) = 0                   <12.832373>
> 16:13:45 syscall(277, 3, 0, 1, 7) = 0   <0.343116>
> 16:13:49 fdatasync(3) = 0               <8.231468>
> 16:14:01 syscall(277, 3, 0, 1, 7) = 0   <2.347144>
> 16:14:06 fsync(3) = 0                   <6.938656>
> 16:14:16 fdatasync(3) = 0               <8.359644>
> 16:14:27 fsync(3) = 0                   <5.928242>
> 16:14:35 syscall(277, 3, 0, 1, 7) = 0   <0.009531>
> 16:14:39 fdatasync(3) = 0               <7.356126>
> 16:14:50 fsync(3) = 0                   <6.402128>
> 16:14:59 syscall(277, 3, 0, 1, 7) = 0   <0.802706>
> 16:15:03 syscall(277, 3, 0, 1, 7) = 0   <2.985404>
> 16:15:08 fsync(3) = 0                   <4.722020>
> 16:15:15 fdatasync(3) = 0               <6.532945>
> 16:15:24 fdatasync(3) = 0               <2.294488>
> 16:15:30 fsync(3) = 0                   <7.986250>
> 16:15:40 syscall(277, 3, 0, 1, 7) = 0   <1.409809>
> 16:15:45 fdatasync(3) = 0               <5.404190>
> 
> The results are consistent with fdatasync being implemented as fsync on ext3.
> 
> They show the potential for considerable savings from growing (and shrinking)
> files in large hunks and using sync_file_range (which also should reduce the
> impact on the rest of the filesystem).

is wrong, isn't it?

It's purportedly showing that fdatasync() on ext3 is syncing the whole
world in fsync()-fashion even with an application which does not grow
the file size.

But fdatasync() shouldn't do that.  Even if the inode is dirty from
atime or mtime updates, that shouldn't cause fdatasync() to run an
ext3 commit?

