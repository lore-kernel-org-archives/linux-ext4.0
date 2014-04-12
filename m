From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Pretty-printing file.f_mode and file.f_flags in trace points
Date: Fri, 11 Apr 2014 21:42:59 -0400
Message-ID: <20140411214259.2de4e9fa@gandalf.local.home>
References: <nsxa9brqyys.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	trond.myklebust@primarydata.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <nsxa9brqyys.fsf@closure.thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 11 Apr 2014 18:32:27 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> 
> I want to add some trace points which display f_mode and f_flags from
> struct file in a human way.   I found the following handy macros defined
> in fs/nfs/nfstrace.h:
> 
> #define show_open_flags(flags) \
> 	__print_flags((unsigned long)flags, "|", \
> 		{ O_CREAT, "O_CREAT" }, \
> 		{ O_EXCL, "O_EXCL" }, \
> 		{ O_TRUNC, "O_TRUNC" }, \
> 		{ O_APPEND, "O_APPEND" }, \
> 		{ O_DSYNC, "O_DSYNC" }, \
> 		{ O_DIRECT, "O_DIRECT" }, \
> 		{ O_DIRECTORY, "O_DIRECTORY" })
> 
> #define show_fmode_flags(mode) \
> 	__print_flags(mode, "|", \
> 		{ ((__force unsigned long)FMODE_READ), "READ" }, \
> 		{ ((__force unsigned long)FMODE_WRITE), "WRITE" }, \
> 		{ ((__force unsigned long)FMODE_EXEC), "EXEC" })
> 
> I could just cut and paste these and drop them in
> include/trace/events/ext4.h, but it would probably be better to have a
> common header file.  The question is where to put them.  Does
> include/trace/fs.h make sense to everyone?   Or should put them
> somewhere else, such as linux/fs.h?
> 

An include file for headers that are only in the include/trace/event
directory is fine to be in include/trace. That is, if you have a macro
used by multiple include/trace/events/*.h files, just put it in
include/trace. I don't even think it needs to be in the events part.

Oh, and I'm fine if it is used by TRACE_EVENT files that are in other
locations like fs/nfs/nfstrace.h.

For adding a helper include/trace/fs.h file used by files in
include/trace/events/ and other trace headers...

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
