From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible bug ?
Date: Wed, 19 Sep 2012 12:26:00 -0400
Message-ID: <20120919162600.GA21210@thunk.org>
References: <CAEG-z2-5=hYOZ+ZwUAE5ULQPJ2kjZ5WMv9EoTpx=c+Mik6_9ug@mail.gmail.com>
 <5059E12A.9000306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Sandu <dexter@d3xt3r01.tk>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51525 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab2ISQ0L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 12:26:11 -0400
Content-Disposition: inline
In-Reply-To: <5059E12A.9000306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 19, 2012 at 10:13:46AM -0500, Eric Sandeen wrote:
> On 9/19/12 9:44 AM, Adrian Sandu wrote:
> > Hi people,
> > 
> > While trying to delete a couple of files today, I got into this lil'
> > thingy. It first happened in mc, then at a reboot.
> 
> Did you cut off a few lines before this?  Like one that said NULL pointer
> dereference, or BUG() at .... or something similar?
> 
> I think we have a few reports of this in the fedora bugzilla, I don't
> think we've gotten to the bottom of it yet.

The fix is in mainline, and backported to v3.5.3.  If Fedora's kernel
hasn't been updated to v3.5.3, it would be great if you could
encourage an update to get pushed out.

Thanks,

						- Ted
