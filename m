From: Christoph Hellwig <hch@lst.de>
Subject: Re: merge plans, was Re: - disable-ext4.patch removed from -mm tree
Date: Tue, 5 Feb 2008 10:44:54 +0100
Message-ID: <20080205094454.GA2847@lst.de>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org> <20080203122551.6830370a.akpm@linux-foundation.org> <20080204013626.GE18392@mit.edu> <20080203191540.3cb2660b.akpm@linux-foundation.org> <20080204202418.GA1649@lst.de> <20080204143529.7b99932d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, tytso@mit.edu, dhowells@redhat.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34910 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYBEJpr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 04:45:47 -0500
Content-Disposition: inline
In-Reply-To: <20080204143529.7b99932d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 04, 2008 at 02:35:29PM -0800, Andrew Morton wrote:
> On Mon, 4 Feb 2008 15:24:18 -0500
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Sun, Feb 03, 2008 at 07:15:40PM -0800, Andrew Morton wrote:
> > > On Sun, 3 Feb 2008 20:36:26 -0500 Theodore Tso <tytso@mit.edu> wrote:
> > > 
> > > > On Sun, Feb 03, 2008 at 12:25:51PM -0800, Andrew Morton wrote:
> > > > > When I merge David's iget coversion patches this will instead wreck the
> > > > > ext4 patchset.
> > > > 
> > > > That's ok, it shouldn't be hard for me to fix this up.  How quickly
> > > > will you be able to merge David's iget converstion patches?
> > > 
> > > They're about 1,000 patches back
> > 
> > Care to post a merge plan so we have a slight chance to make sure not
> > too much crap is hiding in these 1000 patches?
> 
> Pretty much everything up to
> 
> #
> # end
> #
> reiser4-sb_sync_inodes.patch

That includes the git trees?  Defintive NACK to unionfs.
