From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: FIEMAP patches
Date: Mon, 25 Aug 2008 23:22:42 -0700
Message-ID: <20080826062241.GL4563@wotan.suse.de>
References: <20080825202250.GY3392@webber.adilger.int>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYHZGWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 02:22:43 -0400
Content-Disposition: inline
In-Reply-To: <20080825202250.GY3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 25, 2008 at 02:22:50PM -0600, Andreas Dilger wrote:
> I read through the entire previous FIEMAP thread (phew!) and it boils
> down mostly to:
> 
> s/FIEMAP_FLAG_NO_DIRECT/FIEMAP_FLAG_NO_BYPASS/

Yeah, there's a few like that. I'll have to go back through the thread.


> > * FIEMAP_EXTENT_UNWRITTEN                                                    
> > Unwritten extent - the extent is allocated but it's data has not been        
> > initialized.  This indicates the extent's data will be all zero.             
>                                                                                
> This should say "will be all zero if read through the filesystem              
> but the contents are undefined if read directly from the device."
> 
> There was also an update to the ext4 patch from Kalpak for handling
> EA-in-inode at the same time as an external inode.
> 
> Eric, Mark,
> could one of you please just submit the patches to Andrew for inclusion.
> I think there was plenty of debate already, with very little significant
> benefit except suggesting different names for some of the flags.

Agreed. I'll go ahead and spin another set of patches this week.
	--Mark

--
Mark Fasheh
