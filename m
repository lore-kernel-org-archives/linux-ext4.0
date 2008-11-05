From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Patch collision: 64-bit quota changes and ext4 delalloc quota
 changs
Date: Wed, 5 Nov 2008 11:16:04 -0800
Message-ID: <20081105111604.2ed6d354.akpm@linux-foundation.org>
References: <E1Kxkwt-0007Np-O4@closure.thunk.org>
	<20081105084303.ed0c53d5.akpm@linux-foundation.org>
	<20081105174026.GB29880@mit.edu>
	<1225911578.6333.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbYKETQj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 14:16:39 -0500
In-Reply-To: <1225911578.6333.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 05 Nov 2008 10:59:38 -0800
Mingming Cao <cmm@us.ibm.com> wrote:

> > If you are willing to carry the
> > ext4-quota-handling-for-delayed-allocation.patch, that would be great.
> > 
> 
> I saw Andrew already picked up the ext4 quota changes. I will address
> Andrew's comments soon. I assume I will working on incremental fixes to
> address the comments? Or should I send new version of the series?

A new series would probably be easier for reviewers.  I'd turn them
into incrementals here so I can eyeball what changed, but that's pretty
quick.

