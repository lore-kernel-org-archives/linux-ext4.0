From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
 carefully
Date: Tue, 9 Sep 2008 11:29:02 -0700
Message-ID: <20080909112902.2fee86c0.akpm@linux-foundation.org>
References: <20080905210652.GE11569@x200.localdomain>
	<20080906075713.GM3086@webber.adilger.int>
	<20080907121557.GA3432@x200.localdomain>
	<20080907162447.GB32429@mit.edu>
	<20080907164130.GA3376@x200.localdomain>
	<20080908143951.GH8161@mit.edu>
	<20080909070630.GC5786@x200.localdomain>
	<20080909001203.7480549e.akpm@linux-foundation.org>
	<20080909130900.GS8161@mit.edu>
	<20080909111006.cc8aae89.akpm@linux-foundation.org>
	<20080909182457.GS21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756403AbYIIS37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 14:29:59 -0400
In-Reply-To: <20080909182457.GS21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Sep 2008 14:24:57 -0400 Theodore Tso <tytso@MIT.EDU> wrote:

> > I will usually attempt to verify that the subsystem tree merged
> > the correct patch.  Fairly often they didn't.
> 
> I've checked, and modulo some minor changelog comment fixups I had
> made to fix grammar and spelling that I had made to my version of the
> patch, and the fact that we didn't have your signed-off-by in your
> version of the patch, the patch we have is identical.  I'll reconcile
> the changelog comments headers on my end, and if you want to keep it
> in -mm, I'll send them back to you.  Otherwise I'll include it in ext4
> patches and you can drop it from yours if that's OK with you.
> Whatever's easier....

Nope, sounds good - please go ahead and merge it up.
