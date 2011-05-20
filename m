From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Page allocation error during mount with 2.6.39
Date: Fri, 20 May 2011 21:33:15 +0200
Message-ID: <20110520213216@it-loops.com>
References: <20110520111728@it-loops.com>
 <18683DA2-44FC-4417-9BBB-9627B54D8F8A@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:55788
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050Ab1ETTdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 15:33:23 -0400
Content-Disposition: inline
In-Reply-To: <18683DA2-44FC-4417-9BBB-9627B54D8F8A@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20 May 11 08:56, Theodore Tso wrote:
> 
> On May 20, 2011, at 5:22 AM, Michael Guntsche wrote:
> 
> > Hello list,
> > 
> > After upgrading to 2.6.39 I reformatted one of my partitions to ext4 to
> > do some testing. During a simple mount I got the following page
> > allocation failure, the mount succeeded though.
> > The problem is not really reproducible (I tried mounting several times
> > afterwards) but I thought I might mention it nevertheless.
> 
> The mount failure is harmless; if we can't allocate that much space via kmalloc(), we fall back to vmalloc().  In newer versions of the kernel we suppress the warning so as to avoid people thinking something serious had gone wrong.

Ok, thanks for the info. I saw this happening with kerberised nfs mounts
as well so I thought it might be a similar issue.

/Mike
