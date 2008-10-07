From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on 32
 bit architecture
Date: Tue, 7 Oct 2008 11:04:07 -0700
Message-ID: <20081007110407.f22b92e1.akpm@linux-foundation.org>
References: <E1KmetO-00053M-5u@closure.thunk.org>
	<20081006232322.c383fac5.akpm@linux-foundation.org>
	<1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753495AbYJGSEe@vger.kernel.org>
In-Reply-To: <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 07 Oct 2008 11:55:47 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-10-06 at 23:23 -0700, Andrew Morton wrote:
> > On Sun, 05 Oct 2008 21:28:10 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> > > The following patch has been sitting in the ext4 patch queue for about
> > > six weeks.  It was there it was a suspected cause for block allocation
> > > bug.  As I recall, it we found the true root cause since then, but this
> > > has stuck around since it's a potential problem.  Andrew has expressed
> > > concerns that this patch might have performance impacts.
> > 
> > Performace impacts I guess we'll just have to put up with.  iirc I was
> > thinking that this implementation should be pushed down to a kernel-wide
> > atomic64_t and then the percpu_counters would just use that type.
> 
> something like so?

We should think about and document the contexts in which these things
can be used.  Possibly add runtime checks too.  afaict they shouldn't be used in
hard IRQs, and that's pretty unusual for an atomic type.
