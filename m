From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Tue, 5 Feb 2008 17:57:25 -0800
Message-ID: <20080205175725.e318d089.akpm@linux-foundation.org>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org>
	<20080203122551.6830370a.akpm@linux-foundation.org>
	<20080204013626.GE18392@mit.edu>
	<20080203191540.3cb2660b.akpm@linux-foundation.org>
	<20080204150044.GK18392@mit.edu>
	<1202246803.3935.6.camel@localhost.localdomain>
	<1202259740.3935.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, dhowells@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758526AbYBFB6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 20:58:14 -0500
In-Reply-To: <1202259740.3935.23.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 05 Feb 2008 17:02:20 -0800 Mingming Cao <cmm@us.ibm.com> wrote:

> On Tue, 2008-02-05 at 13:26 -0800, Mingming Cao wrote:
> > On Mon, 2008-02-04 at 10:00 -0500, Theodore Tso wrote:
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
> > > > They're about 1,000 patches back.
> > > 
> > > OK, if you're not planning on pushing David's changes to Linus right
> > > away, what if I pull in David's
> > > 
> > > 	iget-stop-ext4-from-using-iget-and-read_inode-try.patch 
> > > 
> > > and push it plus some other ext4 bug fixes directly to Linus, and let
> > > you know when that has happened so you can drop David's patch from
> > > your queue?
> > > 
> > > David's changes to ext4 can be applied standalone without the rest of
> > > his series, so it would be safe to push that to Linus independently
> > > and in advance of the rest of his series.  
> > 
> > I get compile error when builing ext4 patch queue with
> > iget-stop-ext4-from-using-iget-and-read_inode-try.patch applied, against
> > 2.6.24-git14.
> > 
> > It seems iget-stop-ext4-from-using-iget-and-read_inode-try.patch depends
> > on patches:  
> > [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and co.
> > [PATCH 03/32] IGET: Introduce a function to register iget failure
> 
> It seems to me the easiest way to bring ext4 patches back to mm tree, is
> to carry above two patches in ext4 patch queue, like we did for other
> ext4 patches that depend on generic code in the past.

It doesn't matter a lot because I won't be doing another -mm until all this
is merged up anyway.

> So I added above two patches to ext4 patch queue, now that ext4 patches
> could apply cleanly to linus git tree, and Andrew should able to easily
> pull ext4 patches after removing the duplicated patches. 
> 
> Ted, I have the ext4 patch queue updated for this. 

This means that I merge part of the iget patch series, then twiddle thumbs
until the ext4 tree merges, then merge the remainder of the iget series.

So unless Ted intends to merge RSN I think it'd be preferable if I were to
just merge the lot, sorry.
