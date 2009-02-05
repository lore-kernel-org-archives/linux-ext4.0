From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 5 Feb 2009 17:18:09 -0500
Message-ID: <20090205221809.GD9814@mit.edu>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu> <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com> <498B084F.2060608@redhat.com> <20090205164803.GM8945@mit.edu> <87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44489 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZBEWSR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 17:18:17 -0500
Content-Disposition: inline
In-Reply-To: <87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 05:01:01PM -0500, Greg Freemyer wrote:
> > It also has absolutely nothing to do with the original thread, which
> > was block numbers which are far outside the range of valid block
> > numbers given the size of the block device.  :-)
> 
> The subject was "return blocks outside filesystem".

Yes, it's clear you didn't read the e-mail thread, but rather just
keyed off the subject line.  :-)

> In a thin-provisioning environment I'd argue that unmapped sectors are
> "outside the filesystem". :)
> 
> Unfortunately, I can't get anyone else to see the world from my
> apparently unique perspective. :(

If you don't like this, don't use thin-provisioned devices.  Again, I
don't see the likely scenario where your fears are likely to be a
factor in a real world scenario.  If there are bugs in the
thin-provisioned devices, people shouldn't use them.  Given that we
are conservative about when we tell thin-provisioned devices that
blocks are no longer in use (i.e., on journal commits, and if we
crash, just don't tell the device the blocks can be reused), what's
the problem that you're worried about?  How does it occur in real
life?

It's hard to defend against a theoretical problem when you only give
vague fears about how it might be triggered...

						- Ted


