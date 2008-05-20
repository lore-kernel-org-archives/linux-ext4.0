From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 16:36:58 +0100
Message-ID: <20080520153658.GH16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <87ej7zcrqv.fsf@basil.nowhere.org> <200805190926.41970.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200805190926.41970.chris.mason@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason wrote:
> On Sunday 18 May 2008, Andi Kleen wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > > On Fri, 16 May 2008 14:02:46 -0500
> > >
> > > Eric Sandeen <sandeen@redhat.com> wrote:
> > >> A collection of patches to make ext3 & 4 use barriers by
> > >> default, and to call blkdev_issue_flush on fsync if they
> > >> are enabled.
> > >
> > > Last time this came up lots of workloads slowed down by 30% so I
> > > dropped the patches in horror.
> >
> > Didn't ext4 have some new checksum trick to avoid them?
> 
> I didn't think checksumming avoided barriers completely.  Just the barrier 
> before the commit block, not the barrier after.

A little optimisation note.

You don't need the barrier after in some cases, or it can be deferred
until a better time.  E.g. when the disk write cache is probably empty
(some time after write-idle), barrier flushes may take the same time
as NOPs.

This sequence:

    #1 write metadata to journal
    #1 write commit block (checksummed)
  BARRIER
    #1 write metadata in place
  ... time passes ...
    #2 write metadata to journal
    #2 write commit block (checksummed)
  BARRIER
    #2 write metadata in place
  ... time passes ...
    #3 write metadata to journal
    #3 write commit block (checksummed)
  BARRIER
    #3 write metadata in place

Can be rewritten as:

    #1 write metadata to journal
    #1 write commit block (checksummed)
  ... time passes ...
    #2 write metadata to journal
    #2 write commit block (checksummed)
  ... time passes ...
    #3 write metadata to journal
    #3 write commit block (checksummed)
  ... time passes ...
  BARRIER (probably instant).
    #1 write metadata in place
    #2 write metadata in place
    #3 write metadata in place

Provided some conditions hold.  All the metadata and all the journal
writes being non-overlapping I/O ranges would be sufficient.

What's more, barriers can be deferred past data=ordered in-place data
writes, although that's not always an optimisation.

-- Jamie
