From: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Fri, 17 Apr 2009 23:39:06 +0530
Message-ID: <20090417180906.GA8363@amit-x200.pnq.redhat.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbZDQSKf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 14:10:35 -0400
Content-Disposition: inline
In-Reply-To: <1239910921.21233.98.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On (Thu) Apr 16 2009 [15:42:01], Chris Mason wrote:
> Hello everyone,
> 
> Here's an updated (v4) patch for ext3 data=guarded mode.  The first two
> patches in the series are unchanged, and it looks like Linus pulled them
> in this morning.

I had written a small program that calculates the time needed to allocate
a file and zero it using various methods (posix_fallocate, mmap, 4k-chunk
writes, 8k-chunk writes). I did this on a 20G partition with each method
creating a file 4G in size. The system has 3G RAM. The program that does
this is at

http://fedorapeople.org/gitweb?p=amitshah/public_git/alloc-perf.git;a=blob;f=test-file-zero-alloc-speed.c;hb=HEAD

with the script to run it for the multiple filesystems at

http://fedorapeople.org/gitweb?p=amitshah/public_git/alloc-perf.git;a=blob;f=run_test.sh;hb=HEAD

I have a few results from those runs, time in seconds:

# 4GiB file, kernel b0cbc861a3c05e634520b049b5cc27ad6febb51f

filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
ext2		74		96	761		81
ext3-writeback	87		97	202		93
ext3-ordered	86		94	134		104
ext4		0		84	120		91
xfs		0		84	274		81
reiserfs	85		84	187		98
btrfs		0		86	121		85

# 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded

filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
ext3-guarded	85		97	459		90
ext3-writeback	86		95	140		94
ext3-ordered	86		96	277		95
btrfs		0		81	499		93
xfs		0		79	184		84

These were with a desktop running with a few terminal sessions and one
konqueror session (to gauge the times a user will actually see while
working on her desktop).

Running the test in single user mode, I get the following results:

# 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded

filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
ext3-guarded	84		86	163		91
ext3-writeback	84		88	217		91
ext3-ordered	84		86	226		91
btrfs		0		76	86		79
ext4		0		73	195		76

		Amit
