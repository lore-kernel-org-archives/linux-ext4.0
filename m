From: Theodore Tso <tytso@mit.edu>
Subject: The changes I made to the undo-mgr (Re: What's cooking in
	e2fsprogs.git (topics))
Date: Mon, 28 Apr 2008 15:44:34 -0400
Message-ID: <20080428194434.GA9399@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu> <20080423185801.GC21899@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57648 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765519AbYD1Tor (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 15:44:47 -0400
Content-Disposition: inline
In-Reply-To: <20080423185801.GC21899@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So let me talk about what were some of the last couple of things that
I did before I folded the undo-mgr into the tree, since it might be
helpful for other people who are into hacking e2fsprogs.

1) I used "make gcc-wall" (or if you only want to scan for changes in
e2undo.c, you can use the command; "rm e2undo.o; make gcc-wall-new")
to scan for warnings; this turned up some interesting bugs.  Please,
make sure your code is gcc-Wall clean.  In some cases the pre-existing
code isn't, due to folks being lazy or gcc -Wall becoming more strict.
But your patch shouldn't make things worse.

2) Compiling with the --enable-testio-debug configure option, I used
the command "export TEST_IO_FLAGS=0xffff" to set the environment
variable to see the I/O pattern of various programs like "mke2fs" with
the config option defaults.force_undo=1 set.  This is how I discovered
that we were using a pathetically small tdb_data_size, and changing it
to 32768 cut the mke2fs time in half.  Some more investigation showed
that part of the problem was we were initializing the journal one
block at a time, causing significant overhead.  When I changed
lib/ext2fs/mkjournal.c to zero out the journal 8 blocks at a time,
aligned on 8 block boundary to make life easier for the undo manager,
and made a similar change when zero'ing out the inode table so it
would also be issue writes aligned on 8 block boundaries, I was able
to cut the mke2fs time in half again.  

So for everyone who had been complaining about mke2fs taking too much
time with the undo option --- we do have tools in e2fsprogs that can
be used to help profile its operation and speed things up.  You can
also use seekwatcher/blktrace, of course, but there are also other
userspace tools that can be used. 

3) I also changed the name of the files created by the undo manager to
include an .e2undo suffix.  This makes it much more likely that system
administrators will understand what the file is and what it is used
for.

If people are looking for things to do with the undo manager --- it
would be good to wire up e2fsck and resize2fs to use it --- and at
this point, it would probably make sense to factor out common code for
setting up the undo manager into undo_mgr.c itself (although remember
the rules, nothing in libext2fs should try to write to stdout; library
routines must return error codes, and leave the printing of any status
or error messages to the application).

						- Ted
