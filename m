From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 10 Apr 2017 09:19:56 -0400
Message-ID: <1491830396.2732.3.camel@redhat.com>
References: <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
         <1491308268.20445.4.camel@redhat.com>
         <20170404161247.GJ30811@bombadil.infradead.org>
         <1491323146.309.1.camel@redhat.com>
         <20170404170909.GK30811@bombadil.infradead.org>
         <1491421792.18658.20.camel@redhat.com>
         <87efx6tnbr.fsf@notabene.neil.brown.name>
         <1491506092.9621.2.camel@redhat.com>
         <20170406200543.GE31725@bombadil.infradead.org>
         <1491570740.2745.12.camel@redhat.com>
         <8760idyxy8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: NeilBrown <neilb@suse.com>, Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8760idyxy8.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-04-10 at 09:15 +1000, NeilBrown wrote:
> On Fri, Apr 07 2017, Jeff Layton wrote:
> 
> > 
> > > ... and then there's no need to update if it's the same errno and nobody's
> > > seen it:
> > > 
> > > 		if (old == new)
> > > 			break;
> > > 
> > 
> > No, we can't do this. The thing could have just been updated by a task
> > that is setting the "seen" bit. We don't want to lose the error here. We
> > always have to do the cmpxchg on the set_wb_error side, I think.
> 
> I don't follow your logic.
> If (old == new) then there was a moment since this function started when
> performing the cmpxchg() would not have changed the contents of memory.
> So let's pretend it did actually happen at that moment, and not change
> memory.
> 
> If we race with a task setting the "seen" bit, then it will have seen
> the error *after* the new error, that this thread is reporting, actually
> happened.  So the result is still correct.
> 

Ok, that does make sense. I'll plan to do that.

There's also a bug in the last patch that I sent. We need to mark the
SEEN bit when we sample the value at open time, so we need a
filemap_sample_wb_error function to grab the current wb_err_t and mark
it SEEN if necessary.

That also gives us a way to handle something like filemap_write_and_wait
(which doesn't take a struct file). We can sample the wb_err_t prior to
starting writeback, and then return an error if anything failed after
that point.

I think that's probably close enough to how the current code works that
we can use it to make drop-in replacements for filemap_write_and_wait*
which should keep us from having to change so much existing code here.

filemap_check_errors would need to take a previously-sampled wb_err_t
argument, but only the lowest-level callers of that and
filemap_fdatawait* would need to deal with them directly.
-- 
Jeff Layton <jlayton@redhat.com>
