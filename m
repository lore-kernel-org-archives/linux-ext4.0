From: Theodore Tso <tytso@mit.edu>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 20:13:40 -0400
Message-ID: <20081028001340.GB9797@mit.edu>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57905 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912AbYJ1ANn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 20:13:43 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2008 at 07:32:11PM -0400, Steven Rostedt wrote:
> Attached is a patch that I used for counting.
> 
> Here's my results:
> # cat /debug/tracing/ftrace_null 
> 45
> # cat /debug/tracing/ftrace_nonnull 
> 7
> 
> Ah, seems that there is cases where it is nonnull more often. Anyway, it 
> obviously is not a fast path (total of 52). Even if it was all null, it is 
> not big enough to call for the confusion.

Silly question --- what was your test workload?

							- Ted
