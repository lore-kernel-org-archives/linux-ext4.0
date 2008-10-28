From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 20:21:58 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810272021010.20353@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mike Snitzer <snitzer@gmail.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYJ1AWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 20:22:48 -0400
In-Reply-To: <20081028001340.GB9797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 27 Oct 2008, Theodore Tso wrote:

> On Mon, Oct 27, 2008 at 07:32:11PM -0400, Steven Rostedt wrote:
> > Attached is a patch that I used for counting.
> > 
> > Here's my results:
> > # cat /debug/tracing/ftrace_null 
> > 45
> > # cat /debug/tracing/ftrace_nonnull 
> > 7
> > 
> > Ah, seems that there is cases where it is nonnull more often. Anyway, it 
> > obviously is not a fast path (total of 52). Even if it was all null, it is 
> > not big enough to call for the confusion.
> 
> Silly question --- what was your test workload?


Hehe, I just booted the box. The counting started right away, so I just 
looked at the work load.

Anyway, I'm writing a generic "unlikely" profiler that should make Andrew 
happy. And this will also catch this case as well.

-- Steve

