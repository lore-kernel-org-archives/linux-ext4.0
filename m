From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Thu, 24 Aug 2017 14:20:57 -0400
Message-ID: <20170824182057.amdirlrbugezrahy@thunk.org>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51278 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752751AbdHXSVB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 14:21:01 -0400
Content-Disposition: inline
In-Reply-To: <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 11, 2017 at 03:41:30PM +0200, Lukas Czerner wrote:
> > > That said, it seems to me that there can be some user choice involved in
> > > this at least based on the fact that when DAX is used system memory is not
> > > used.
> > 
> > All of the above are charateristics of the medium, not of the
> > application.

So it seems that Cristoph's primary object to using a per-inode DAX
flag is that it is a not-very-well-defined hint to the file system
about how to treat writes for a class of storage devices which do not
yet have (and perhaps may never have) a standard set of performance
characteristics.  So if we encode this into the file system format,
we'll be stuck with a "do something different" set of semantics that
xfs (and ext4 if we pick up this patch) will have to support forever.

Or, at least, if we make changes that cause performance impact to
userspace applications, this may cause application programmers to
kvetch --- not that they never done *that* before.  :-)

The counter-argument is that system administrators do need to have a
way to signal that they would like the file system to "do something
different" on a per-file basis, and no one else has come up with
another way of doing things.  Furthermore, it would be highly
desirable if the system adminisator can provide this per-file system
hint with requiring changes to the application.  (For example, by
adding madvise/fadvise hints.)

Is that a fair summary of the argument?

I have two additional questions I'd like to ask at this point.

1)  Has there been any other difficulty that XFS has had due to the
fact that they have this DAX flag added?  e.g., are there any
operational, or practical code maintainability issues at stake here?
Or is this mostly an design philosophy debate?

2) Are there any users using the DAX flag with XFS such that, if XFS
were to remove the DAX flag support, those users would complain
bitterly?

Thanks,

					- Ted
