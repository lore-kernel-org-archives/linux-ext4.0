From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 10:01:24 -0400
Message-ID: <4D7F7134.7080209@cfl.rr.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com> <20110314215249.GE8120@thunk.org> <4D7EA83D.20400@cfl.rr.com> <20110315001448.GG8120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:37604 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1COOB3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 10:01:29 -0400
In-Reply-To: <20110315001448.GG8120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/14/2011 8:14 PM, Ted Ts'o wrote:
> The reason why we have to traverse the directory tree in htree order
> is because the POSIX requirements of how readdir() works in the face
> of file deletes and creations, and what needs to happen if a leaf
> block needs to be split.  Even if the readdir() started three months
> ago, if in the intervening time, leaf nodes have been split, readdir()
> is not allowed to return the same file twice.

This would also be fixed by having readdir() traverse the linear
directory entries rather than the htree.

> Well, if the file system has been around for a long time, and there
> are lots of "holes" in the inode allocation bitmap, it can happen that
> even without indexing.

Why is that?  Sure, if the inode table is full of small holes I can see
them not being allocated sequentially, but why don't they tend to at
least be allocated in ascending order?

> As another example, if you have a large maildir directory w/o
> indexing, and files get removed, deleted, etc., over time the order of
> the directory entries will have very little to do with the inode
> number.  That's why programs like mutt sort the directory entries by
> inode number.

Is this what e2fsck -D fixes?  Does it rewrite the directory entries in
inode order?  I've been toying with the idea of adding directory
optimization support to e2defrag.

To try and clarify this point a bit, are you saying that applications
like tar and rsync should be patched to sort the directory by inode
number, rather than it being the job of the fs to return entries in a
good order?

