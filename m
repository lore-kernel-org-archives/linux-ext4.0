From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64 and powerpc
Date: Mon, 21 May 2007 01:38:31 -0400
Message-ID: <20070521053831.GA10269@thunk.org>
References: <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070514142820.GA31468@amitarora.in.ibm.com> <20070514144524.GA31748@amitarora.in.ibm.com> <20070515094436.d441098f.sfr@canb.auug.org.au> <20070515132353.GB12964@amitarora.in.ibm.com> <20070518213621.GA10655@thunk.org> <1179529845.3768.20.camel@dyn9047017103.beaverton.ibm.com> <1179664772.30468.3.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55546 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXEUFi5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 May 2007 01:38:57 -0400
Content-Disposition: inline
In-Reply-To: <1179664772.30468.3.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 20, 2007 at 07:39:32AM -0500, Dave Kleikamp wrote:
> On Fri, 2007-05-18 at 16:10 -0700, Mingming Cao wrote:
> > On Fri, 2007-05-18 at 17:36 -0400, Theodore Tso wrote:
> 
> > > We've missed the -rc1 merge window, so the goal should be to make sure
> > > that everything in the series file before the "unstable patches" is
> > > ready for merging.
> > > 
> > I tend to agree.  But there are some bug-fix type or mount option
> > patches that can try to target for rc2, what do you think?
> 
> I agree with Mingming.  There's no reason for these patches not to be in
> mainline.  I am curious why the fallocate patches were put at the top of
> the series file in the first place.  The older patches shouldn't be held
> up by fallocate (which should wait until the next merge window).

I've rebased the ext4 patch queue for 2.6.22-rc2, and moved the
obvious bug fixes to the top of the queue.  There's one patch which I
missed (ext4-free-blocks-on-insert-extent-failure.patch) which is also
a bug fixed, that should be moved up.

It's true that some of the older patches are below fallocate in the
queue, but they are still new features that probably shouldn't be
pushed at this point.  But yes, I agree that the bug fixes should be
pushed to Linus before 2.6.22 ships.

Regards,

						- Ted
