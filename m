From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 12:02:53 -0400
Message-ID: <200805201202.54420.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <200805190926.41970.chris.mason@oracle.com> <20080520153658.GH16676@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934161AbYETQEd@vger.kernel.org>
In-Reply-To: <20080520153658.GH16676@shareable.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 20 May 2008, Jamie Lokier wrote:
> Chris Mason wrote:
> > On Sunday 18 May 2008, Andi Kleen wrote:
> > > Andrew Morton <akpm@linux-foundation.org> writes:
> > > > On Fri, 16 May 2008 14:02:46 -0500
> > > >
> > > > Eric Sandeen <sandeen@redhat.com> wrote:
> > > >> A collection of patches to make ext3 & 4 use barriers by
> > > >> default, and to call blkdev_issue_flush on fsync if they
> > > >> are enabled.
> > > >
> > > > Last time this came up lots of workloads slowed down by 30% so I
> > > > dropped the patches in horror.
> > >
> > > Didn't ext4 have some new checksum trick to avoid them?
> >
> > I didn't think checksumming avoided barriers completely.  Just the
> > barrier before the commit block, not the barrier after.
>
> A little optimisation note.
>
> You don't need the barrier after in some cases, or it can be deferred
> until a better time.  E.g. when the disk write cache is probably empty
> (some time after write-idle), barrier flushes may take the same time
> as NOPs.

I hesitate to get too fancy here, if the disk is idle we probably won't notice 
the performance gain.

>
> This sequence:
>
>     #1 write metadata to journal
>     #1 write commit block (checksummed)
>   BARRIER
>     #1 write metadata in place
>   ... time passes ...
>     #2 write metadata to journal
>     #2 write commit block (checksummed)
>   BARRIER
>     #2 write metadata in place
>   ... time passes ...
>     #3 write metadata to journal
>     #3 write commit block (checksummed)
>   BARRIER
>     #3 write metadata in place
>
> Can be rewritten as:
>
>     #1 write metadata to journal
>     #1 write commit block (checksummed)
>   ... time passes ...
>     #2 write metadata to journal
>     #2 write commit block (checksummed)
>   ... time passes ...
>     #3 write metadata to journal
>     #3 write commit block (checksummed)
>   ... time passes ...
>   BARRIER (probably instant).
>     #1 write metadata in place
>     #2 write metadata in place
>     #3 write metadata in place
>
> Provided some conditions hold.  All the metadata and all the journal
> writes being non-overlapping I/O ranges would be sufficient.

This is true, and would be a fairly good performance boost.  It fits nicely 
with the jbd trick of avoiding writes of a metadata block if a later 
transaction has logged it.

But, it complicates the decision about when you're allowed to dirty a metadata 
block for writeback.  It used to be dirty-after-commit and it would change to 
dirty-after-barrier.  I suspect that is some significant surgery into jbd.

Also, since a commit isn't really done until the barrier is done, you can't 
reuse blocks freed by the committing transaction until after the barrier, 
which means changes in the deletion handling code.  

Maybe I'm a wimp, but these are the two parts of write ahead logging I always 
found the most difficult.

>
> What's more, barriers can be deferred past data=ordered in-place data
> writes, although that's not always an optimisation.
>

It might be really interesting to have a 
i'm-about-to-barrier-find-some-io-to-run call.  Something along the lines of 
draining the dirty pages when the drive is woken up in laptop mode.  There's 
lots of fun with page lock vs journal lock ordering, but Jan has a handle on 
that I think.

-chris
