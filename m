From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Random corruption test for e2fsck
Date: Tue, 10 Jul 2007 10:47:06 -0500
Message-ID: <4693A9FA.7040106@redhat.com>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbXGJPu6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 11:50:58 -0400
In-Reply-To: <1184072860.4440.39.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah wrote:
> Hi,
> 
> This is a random corruption test which can be included in the e2fsprogs
> regression tests. It does the following:
> 1) Create an test fs and format it with ext2/3/4 and random selection of
> features.
> 2) Mount it and copy data into it.
> 3) Move around the blocks of the filesystem randomly causing corruption.
> Also overwrite some random blocks with garbage from /dev/urandom. Create
> a copy of this corrupted filesystem.
> 4) Unmount and run e2fsck. If the first run of e2fsck produces any
> errors like uncorrected errors, library error, segfault, usage error,
> etc. then it is deemed a bug. But in any case, a second run of e2fsck is
> done to check if it renders the filesystem clean. 
> 5) If the test went by without any errors the test image is deleted and
> in case of any errors the user is notified that the log of this test run
> should be mailed to linux-ext4@ and the image should be preserved.
> 
> Any comments are welcome.

Seems like a pretty good idea.  I had played with such a thing using
fsfuzzer... fsfuzzer always seemed at least as useful useful as a fsck
tester than a kernel code tester anyway.  (OOC, did you look at fsfuzzer
when you did this?)

My only concern is that since it's introducing random corruption, new
things will probably pop up from time to time; when we do an rpm build
for Fedora/RHEL, it automatically runs make check:

%check
make check

which seems like a reasonably good idea to me.  However, I'd rather not
have last-minute build failures introduced by new random collection of
bits that have never been seen before.  Maybe "make RANDOM=0 check" as
an option would be a good idea for automated builds...?

Thanks,
-Eric
