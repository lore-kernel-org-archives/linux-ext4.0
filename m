From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: - disable-ext4.patch removed from -mm tree
Date: Tue, 05 Feb 2008 17:02:20 -0800
Message-ID: <1202259740.3935.23.camel@localhost.localdomain>
References: <200802032018.m13KIGoC029855@imap1.linux-foundation.org>
	 <20080203122551.6830370a.akpm@linux-foundation.org>
	 <20080204013626.GE18392@mit.edu>
	 <20080203191540.3cb2660b.akpm@linux-foundation.org>
	 <20080204150044.GK18392@mit.edu>
	 <1202246803.3935.6.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60196 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYBFBCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 20:02:19 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1612JHe027068
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 20:02:19 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1612JwA218602
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 20:02:19 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1612IDA014004
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 20:02:18 -0500
In-Reply-To: <1202246803.3935.6.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-02-05 at 13:26 -0800, Mingming Cao wrote:
> On Mon, 2008-02-04 at 10:00 -0500, Theodore Tso wrote:
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
> > > They're about 1,000 patches back.
> > 
> > OK, if you're not planning on pushing David's changes to Linus right
> > away, what if I pull in David's
> > 
> > 	iget-stop-ext4-from-using-iget-and-read_inode-try.patch 
> > 
> > and push it plus some other ext4 bug fixes directly to Linus, and let
> > you know when that has happened so you can drop David's patch from
> > your queue?
> > 
> > David's changes to ext4 can be applied standalone without the rest of
> > his series, so it would be safe to push that to Linus independently
> > and in advance of the rest of his series.  
> 
> I get compile error when builing ext4 patch queue with
> iget-stop-ext4-from-using-iget-and-read_inode-try.patch applied, against
> 2.6.24-git14.
> 
> It seems iget-stop-ext4-from-using-iget-and-read_inode-try.patch depends
> on patches:  
> [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and co.
> [PATCH 03/32] IGET: Introduce a function to register iget failure

It seems to me the easiest way to bring ext4 patches back to mm tree, is
to carry above two patches in ext4 patch queue, like we did for other
ext4 patches that depend on generic code in the past.

So I added above two patches to ext4 patch queue, now that ext4 patches
could apply cleanly to linus git tree, and Andrew should able to easily
pull ext4 patches after removing the duplicated patches. 

Ted, I have the ext4 patch queue updated for this. 

Regards,
Mingming
