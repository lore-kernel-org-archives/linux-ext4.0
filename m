From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - detect LVM2 PVs in libblkid
Date: Tue, 19 Feb 2008 10:42:46 -0500
Message-ID: <20080219154246.GY25098@mit.edu>
References: <47A1074F.8090909@redhat.com> <20080219112731.GV25098@mit.edu> <47BAEF86.8080601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38122 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbYBSPmx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 10:42:53 -0500
Content-Disposition: inline
In-Reply-To: <47BAEF86.8080601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 09:02:30AM -0600, Eric Sandeen wrote:
> Theodore Tso wrote:
> 
> > The patch works for me, but it would seem the right thing would be
> > print the UUID without the hyphens, i.e.:
> > 
> >         guOQGdcOE3IafCm0190XkPZTy5fCEanQ
> > 
> > instead of
> > 
> > 	guOQGd-cOE3-IafC-m019-0XkP-ZTy5-fCEanQ
> 
> But it already does print it without the hyphens.
> 
> Or did you mean to say "print the UUID *with* the hyphens?"

Sorry, I meant print it with the hyphens, like pvscan does and all of
the other filesystem UUID's returned by blkid.

						- Ted
