From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: merge plans, was Re: - disable-ext4.patch removed from -mm tree
Date: Tue, 5 Feb 2008 01:53:04 -0800
Message-ID: <20080205015304.65a1c798.akpm@linux-foundation.org>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org>
	<20080203122551.6830370a.akpm@linux-foundation.org>
	<20080204013626.GE18392@mit.edu>
	<20080203191540.3cb2660b.akpm@linux-foundation.org>
	<20080204202418.GA1649@lst.de>
	<20080204143529.7b99932d.akpm@linux-foundation.org>
	<20080205094454.GA2847@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, dhowells@redhat.com, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbYBEJxf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 04:53:35 -0500
In-Reply-To: <20080205094454.GA2847@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 5 Feb 2008 10:44:54 +0100 Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Feb 04, 2008 at 02:35:29PM -0800, Andrew Morton wrote:
> > On Mon, 4 Feb 2008 15:24:18 -0500
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Sun, Feb 03, 2008 at 07:15:40PM -0800, Andrew Morton wrote:
> > > > On Sun, 3 Feb 2008 20:36:26 -0500 Theodore Tso <tytso@mit.edu> wrote:
> > > > 
> > > > > On Sun, Feb 03, 2008 at 12:25:51PM -0800, Andrew Morton wrote:
> > > > > > When I merge David's iget coversion patches this will instead wreck the
> > > > > > ext4 patchset.
> > > > > 
> > > > > That's ok, it shouldn't be hard for me to fix this up.  How quickly
> > > > > will you be able to merge David's iget converstion patches?
> > > > 
> > > > They're about 1,000 patches back
> > > 
> > > Care to post a merge plan so we have a slight chance to make sure not
> > > too much crap is hiding in these 1000 patches?
> > 
> > Pretty much everything up to
> > 
> > #
> > # end
> > #
> > reiser4-sb_sync_inodes.patch
> 
> That includes the git trees?

No, I don't merge git trees.

>  Defintive NACK to unionfs.

Agree, but it'd be nice to get some movement and resolution here.  The
thing's actively and enthusiastically maintained and is apparently useful. 
There's not much point in allowing developers to expend cycles on something
which doesn't have a future.
