From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 15:12:09 +0200
Message-ID: <20080218131209.GB21080@cs181133002.pp.htv.fi>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Andreas Dilger <adilger@sun.com>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45596 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbYBRNMl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 08:12:41 -0500
Content-Disposition: inline
In-Reply-To: <20080218114936.GM8905@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 06:49:36AM -0500, Theodore Tso wrote:
> On Mon, Feb 18, 2008 at 08:12:29AM +0100, Ingo Molnar wrote:
> > > Nack.  I don't object to un-exporting journal_update_superblock(), 
> > > because that is pretty internal, but the other functions are intended 
> > > specifically for use by code outside of JBD.  For example, the journal 
> > > checksum patch for ext3/4 uses journal_set_features() to turn on 
> > > features in the JBD superblock.
> > > 
> > > Similarly, for 64-bit support in ext4 uses journal_set_features() to 
> > > set a 64-bit feature flag in the journal superblock.
> > 
> > that's an invalid excuse for the benefit of out-of-tree forks: reality 
> > is that you can export those functions in the "journal checksum patch" 
> > just fine. So you cannot 'nack' a sensible patch on that ground and no 
> > maintainer does it on that ground. Once you get your stuff upstream, you 
> > can re-add the export.
> 
> I'm going to NACK it as well.  This kind of code churn where we make
> symbols static only to make them non-static again in an existing ext4
> tree is exactly the sort of needless code churn that makes patches
> start to conflict and where we need different patches depending on
> whether it is intended for -mm or linux-next or mainline.
> 
> I think we really have gotten WAY to doctrinaire on the if there are
> no in-tree users, it MUST be static.  This is exactly the sort of
> mindless rules that cause the patch conflicts that have been causing
> us so much pain and grief.  In this case, it is an existing symbol
> which is already non-static, and for which we have code in a
> development tree that will be using it.  In the r/o bind case, it is
> the insistence that you can't push an existing patch to expose a new
> interface that must be used later in the r/o bind patchset and which
> sweeps across all trees changing stuff that causes pain and grief.
> 
> In both cases, if we expand "in-tree" development users to include
> known development trees that are intended for mainline, it makes all
> of our lives MUCH easier.  

The following was meant 100% seriously:

This patch has been sent on:
- 16 May 2006
- 1 May 2006
- 23 Apr 2006


If me resending this old patch collides with something finally getting a 
user this part of my patch shouldn't be applied now (but you might get 
it again in 6 months if it's still unused...).

But generally such conflicts would become visible if "known development 
trees that are intended for mainline" were in -mm.

> 					- Ted

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
