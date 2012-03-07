From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching
 holes
Date: Wed, 7 Mar 2012 08:05:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203070804210.5117@dhcp-27-109.brq.redhat.com>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com> <4F4DDE8D.6020203@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com>
 <20120305235430.GA12796@thunk.org> <alpine.LFD.2.00.1203060810430.5085@dhcp-27-109.brq.redhat.com> <20120306164412.GD32282@thunk.org> <4F565962.1020604@linux.vnet.ibm.com> <4F565A8D.90009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2CGHFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 02:05:39 -0500
In-Reply-To: <4F565A8D.90009@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Mar 2012, Allison Henderson wrote:

> On 03/06/2012 11:37 AM, Allison Henderson wrote:
> > On 03/06/2012 09:44 AM, Ted Ts'o wrote:
> > > On Tue, Mar 06, 2012 at 08:11:37AM +0100, Lukas Czerner wrote:
> > > > 
> > > > you're right my patches solves this problem (as I wrote in the commit
> > > > description) just because we now use a different code paths, which do
> > > > not have this problem.
> > > 
> > > Ok, thanks. I'll look at them before the end of this week.
> > > 
> > > Just to be clear, have the problematic code paths been removed in your
> > > patches, or are they not just being used in the problem scenario?
> > > Basically, is there any other time where we might need the additional
> > > logic which Allison added?
> > > 
> > > - Ted
> > > 
> > 
> > Hi Ted,
> > 
> > I think we will be ok with out this patch if we pick up Lukas's patches.
> > Since the new implementation is seated inside ext4_ext_remove_space,
> > Lukas can take advantage of the existing code there.
> > 
> > In the current solution, we are seated inside map blocks, and then call
> > ext4_ext_rm_leaf from there. The bug in the current solution was that we
> > needed to free index blocks in the path to the extent we just removed,
> > but ext4_ext_remove_space will do this as it walks over the tree.
> > 
> > There are some things in the new implementation that Lukas and I are
> > looking at, but once we get it straightened out, I think it will be ok
> > to let this patch go. Thx!
> > 
> > Allison Henderson
> > 
> 
> forgot to reply to all.  Resending to keep everyone posted :)
> 

I second that. The previous codepaths are removed from map blocks, so
this bug is not there anymore.

Thanks!
-Lukas
