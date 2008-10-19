From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] ext3: sreadahead hooks
Date: Sun, 19 Oct 2008 23:42:05 +0200
Message-ID: <20081019214204.GA11865@nb.net.home>
References: <20081014101735.04107779@infradead.org> <20081014151329.GA17926@infradead.org> <48F4BFF6.8060404@redhat.com> <48F513FF.8020306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYJSVmX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Oct 2008 17:42:23 -0400
Content-Disposition: inline
In-Reply-To: <48F513FF.8020306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2008 at 04:49:51PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Christoph Hellwig wrote:
> >> On Tue, Oct 14, 2008 at 10:17:35AM -0400, Arjan van de Ven wrote:
> >>> >From 3d7a0ca0ee8a755251251bd9ddca0866c25acdc2 Mon Sep 17 00:00:00 2001
> >>> From: Arjan van de Ven <arjan@linux.intel.com>
> >>> Date: Tue, 14 Oct 2008 10:12:08 -0400
> >>> Subject: [PATCH] ext3: sreadahead hooks
> >>>
> >>> The sreadahead program, used to make the OS boot faster, needs to know in
> >>> the approximate order in files are used during the boot process. This patch
> >>> adds the ext3 hook for this functionality, basically it stores "jiffies"
> >>> into the inode at allocation time, and exposes it via an EXT3 ioctl (yes I
> >>> know but ioctl seems fitting for this).
> >> Even if it's an ioctl there's absolutely no point in making this
> >> fileystem specific.  Also the name is rather dumb and non-descriptive.
> > 
> > I have to agree, both the ioctl name and the new field are not very
> > descriptive - created_when sounds an awful lot like ctime but it's not.
> > 
> > and INODE_JIFFIES really doesn't mean anything at all w/o extra context.
> >  But I'm trying to think of some nice names.  :)
> > 
> > What about making a new struct inode field and doing this update in
> > new_inode(), and making it a generic ioctl.  Are we ready to go that far?
> 
> Or, as I thought about/mentioned to hch, and I guess he and Arjan
> already discussed... :)  why not just use tracing infrastructure to get

 What do you mean by "tracing infrastructure"? Audit?

 I had the same question (especially when I'm an author of the
 readahead-collector that uses the audit subsystem for this task :-).
 The problem is that audit stuff is difficult to use (you have to
 disable auditd, and it's not simple to integrate it to the
 distribution).

 Arjan's solution is extremely simple and useful without invasive
 changes in distributions.

> this info, rather than adding new members to every inode on the system?

 #ifdef CONFIG_INODE_JIFFIES

 ('n' for servers which don't need to boot in 5 secs ;-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
