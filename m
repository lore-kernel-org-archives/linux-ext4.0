From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Tue, 4 Aug 2009 16:41:22 -0400
Message-ID: <20090804204122.GL28678@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090804182811.GG9324@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54913 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbZHDUlb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 16:41:31 -0400
Content-Disposition: inline
In-Reply-To: <20090804182811.GG9324@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2009 at 02:28:11PM -0400, Valerie Aurora wrote:
> On Sat, Aug 01, 2009 at 10:22:09PM -0400, Theodore Tso wrote:
> > In case people are wondering why it's taking so long to merge the
> > 64-bit patch series, let me show one patch as exhibit 'A' about how
> > not to submit patches to me (or Linus, or any other upstream
> > maintainer):
> 
> Oh, geez, those are an old patch set!  I did go back and fix the
> temporary commits and dangly semi-colons, plus reimplemented progress
> meters the way you wanted:
> 
> http://osdir.com/ml/linux-ext4/2009-02/msg00591.html

Oh, I see what happened.  It looks like you fixed some of that up in
the "shared-64bit-handover" branch, but I didn't see that one, since
you checked in the bug fixes and patches which Nick Dokus submitted
into the "shared-64bit" branch.  Hence, the shared-64bit branch had
commits in it dating from May, 2009, while the shared-64bit-handover
branch had commits dating from February, 2009.  Hence, I started work
using the shared-64bit branch instead of the shared-64bit-handover
branch.

This is, by the way, why I believe using a patch queue is a
****much**** better way of working, instead of using multiple git
branches.  I'm guessing that when Nick started submitting patches, you
got confused and applied his patches onto the wrong branch, and so of
course I used the latest, new version of the 64-bit branch --- which
meant that I got Nick's fixes, but not your cleanups.   Argh....

I wish I had figured this out much earlier, since at this point, I've
done so much work using the non-cleaned-up patches, including merging
around a third of the patches into e2fsprogs mainline, that it's
probably not worth it to go back.

						- Ted
