From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Thu, 30 Oct 2008 06:55:28 -0700
Message-ID: <20081030135528.GA7926@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081029210949.GA27274@mit.edu> <4909B8D6.7070206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([206.169.144.12]:5167 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbYJ3Nz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 09:55:29 -0400
Content-Disposition: inline
In-Reply-To: <4909B8D6.7070206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric, ...

On Thu, Oct 30, 2008 at 06:38:30AM -0700, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
> >> Sorry for the silence, this is a nice bug you've found :)
> >>
> >> I'll look into it ...
> >
> > You may want to take a quick look at this thread:
> >
> >     http://lkml.org/lkml/2008/10/28/413
> >
> >                                       - Ted
> 
> I thought about that, but at least at first glance I don't see how the
> gfp mask change would cause this behavior...?  At least, I don't think
> we're seeing recursion back into the filesystem... but I'll ponder that.

Back when I thought this was a 2.6.9 bug, I tried
that patch.  There was no change in behavior...

Arthur
