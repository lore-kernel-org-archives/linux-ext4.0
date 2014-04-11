From: Theodore Ts'o <tytso@mit.edu>
Subject: Pretty-printing file.f_mode and file.f_flags in trace points
Date: Fri, 11 Apr 2014 18:32:27 -0400
Message-ID: <nsxa9brqyys.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rostedt@goodmis.org, trond.myklebust@primarydata.com
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I want to add some trace points which display f_mode and f_flags from
struct file in a human way.   I found the following handy macros defined
in fs/nfs/nfstrace.h:

#define show_open_flags(flags) \
	__print_flags((unsigned long)flags, "|", \
		{ O_CREAT, "O_CREAT" }, \
		{ O_EXCL, "O_EXCL" }, \
		{ O_TRUNC, "O_TRUNC" }, \
		{ O_APPEND, "O_APPEND" }, \
		{ O_DSYNC, "O_DSYNC" }, \
		{ O_DIRECT, "O_DIRECT" }, \
		{ O_DIRECTORY, "O_DIRECTORY" })

#define show_fmode_flags(mode) \
	__print_flags(mode, "|", \
		{ ((__force unsigned long)FMODE_READ), "READ" }, \
		{ ((__force unsigned long)FMODE_WRITE), "WRITE" }, \
		{ ((__force unsigned long)FMODE_EXEC), "EXEC" })

I could just cut and paste these and drop them in
include/trace/events/ext4.h, but it would probably be better to have a
common header file.  The question is where to put them.  Does
include/trace/fs.h make sense to everyone?   Or should put them
somewhere else, such as linux/fs.h?

Cheers,

                                                - Ted
