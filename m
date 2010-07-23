From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Fri, 23 Jul 2010 14:47:33 +0900 (JST)
Message-ID: <20100723144549.88BA.A69D9226@jp.fujitsu.com>
References: <20100722054957.GA11670@infradead.org> <20100723011315.GC16373@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: kosaki.motohiro@jp.fujitsu.com
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60923 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0GWFrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 01:47:36 -0400
In-Reply-To: <20100723011315.GC16373@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Jul 22, 2010 at 01:49:57AM -0400, Christoph Hellwig wrote:
> > 
> > I think ext4 is simply using an incorrectly typed tracepoint here.
> > If you want it to be useful in any way it needs a sb paramter and
> > an optional inode paramter, not the allocation context.
> 
> I agree; this is the patch that I had whipped up to fix the problem.
> (See below)

I'm not familiar ext4 so much. but you patch seems very nice!
thank you :)

> 
> > Also the whole ext4_mb_release_group_pa function seems to be a bit
> > misdesigned.  The code using ac is a totally separate block at the
> > end of the function and does work that's unrelated to the rest
> > of the function.  Just making it a separate helper can calling it
> > only from those places that have the allocation context would make
> > the code more clear.
> 
> I need to look more closely at this.  If I had time there would be a
> lot of things that I'd be refactoring and cleaning up in mballoc.c....


