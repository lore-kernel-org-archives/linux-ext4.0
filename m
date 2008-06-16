From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 21:40:58 +0200
Message-ID: <20080616194058.GF31567@duck.suse.cz>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616150533.GB3279@atrey.karlin.mff.cuni.cz> <20080616185524.GR3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36478 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbYFPTlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2008 15:41:00 -0400
Content-Disposition: inline
In-Reply-To: <20080616185524.GR3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-06-08 12:55:24, Andreas Dilger wrote:
> On Jun 16, 2008  17:05 +0200, Jan Kara wrote:
> >   First, I'd like to see some short comment on what semantics
> > delalloc,data=ordered is going to have. At least I can imagine at least
> > two sensible approaches:
> >   1) All we guarantee is that user is not going to see uninitialized data.
> > We send writes to disk (and allocate blocks) whenever it fits our needs
> > (usually when pdflush finds them).
> >   2) We guarantee that when transaction commits, your data is on disk -
> > i.e., we allocate actual blocks on transaction commit.
> > 
> >   Both these possibilities have their pros and cons. Most importantly,
> > 1) gives better disk layout while 2) gives higher consistency
> > guarantees. Note that with 1), it can under some circumstances happen,
> > that after a crash you see block 1 and 3 of your 3-block-write on disk,
> > while block 2 is still a hole. 1) is easy to implement (you mostly did
> > it below), 2) is harder. I think there should be broader consensus on
> > what the semantics should be (changed subject to catch more attention ;).
> 
> IMHO, the semantic should be (1) and not (2).  Applications don't understand
> "when the transaction commits" so it doesn't provide any useful guarantee
> to userspace, and if they actually need the data on disk (e.g. MTA) then
> they need to call fsync to ensure this.
  Well, in principle I agree with you. But let's take example of firefox /
konqueror. They call fsync() on each modification to their "browsing
history" file. And when I asked one Konqueror developer why do they do such
a stupid thing, he told me that XFS used to zero-out portions of the file
on crash (because of delalloc) and this broke the browser in funny ways.
  Now the point I wanted to make is that if the filesystem behaves
"reasonably" apps often do not need to call fsync (Konquerror is fine with
how current ext3 in data=ordered mode behaves without using fsync, I'm not
sure if it would be fine with delalloc,data=ordered of ext4).
  So I'm not really decided whether the additional performance is worth the
decreased data consistency guarantees...

> While I agree it is theoretically possible to have the "hole in data
> where there shouldn't be one" scenario, in real life these blocks would be
> allocated together by delalloc+mballoc and this situation should not happen.
> 
> As for "sync with heavy IO causing slowness" problem of Firefox, I think
> that delalloc will help this noticably, but I agree we can still get into
> cases where a lot of dirty data was just allocated and now needs to be
> flushed to disk to commit the transaction.
> 
> In the short term I don't think this can be completely fixed, but in the
> long term I think it can be fixed by having mballoc do "reservations" of
> space on disk, in which the dirty pages can be written.  Only after the
> data is on disk does the "reservation" turn into an "allocation" in the
> journal (i.e. filesystem buffers added to transaction and modified).
> At that point a sync operation only has to write out the journal blocks,
> because all of the data is on disk already.
  Interesting idea, this seems like a viable way to fix the problem.

> I don't think it is a huge difference from what we have today, but I
> also don't think it should be in the first implementation.  We would
> need to split up handling of the in-memory block bitmaps so that only
> the in-memory ones are updated first, then the on-disk bitmaps are
> later marked in use in a transaction after the data blocks are on disk.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
