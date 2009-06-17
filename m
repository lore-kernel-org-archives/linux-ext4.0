From: Theodore Tso <tytso@mit.edu>
Subject: Re: Something wrong with extent-based journal creation
Date: Wed, 17 Jun 2009 11:31:26 -0400
Message-ID: <20090617153126.GA25451@mit.edu>
References: <4A381EC8.4010202@redhat.com> <20090617080432.GC13073@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52349 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZFQPbo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 11:31:44 -0400
Content-Disposition: inline
In-Reply-To: <20090617080432.GC13073@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2009 at 02:04:32AM -0600, Andreas Dilger wrote:
> On Jun 16, 2009  17:38 -0500, Eric Sandeen wrote:
> > I've narrowed it down to the commit (961306d3) which creates the journal
> > with extent format; if that's commented out, it works fine.
> 
> Hmm, this seems like it might be a troublesome feature...  Are we sure
> that there is proper kernel/tool compatibility for an extent-mapped
> journal?  At least none of the Lustre code has any support for this,
> though they can handle the INCOMPAT_EXTENTS feature, and I don't think
> this was present in older kernels either.
> 
> I haven't looked at the code for this yet, so it may be that it will
> "just work", but if this is a new feature I would urge caution w.r.t.
> compatibility before this is merged upstream (in either e2fsprogs or
> the kernel).

Extent-based journals "just works", at least in the kernel; I didn't
need to make any changes to the kernel before I added support to using
an extent-mapped journal; if the kernel supports extents, it should
expert extent-mapped journals without any difficults.  The patch to
add this was merged in before e2fsprogs 1.41.1 was released, so mke2fs
has been creating extent-based journals for a while.

    	 	  	       		      - Ted
