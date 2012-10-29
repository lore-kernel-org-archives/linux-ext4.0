From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v4 03/15] vfs,hot_track: add the function for collecting
 I/O frequency
Date: Mon, 29 Oct 2012 13:01:24 +1100
Message-ID: <20121029020124.GP29378@dastard>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
 <1351177747-19389-4-git-send-email-zwu.kernel@gmail.com>
 <20121028075520.GA14554@gmail.com>
 <CAEH94LidECTUHb0_Wujyg=zH18+dzxMPTUUpiYBeUSiG7MpSKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8006 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504Ab2J2CBi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 22:01:38 -0400
Content-Disposition: inline
In-Reply-To: <CAEH94LidECTUHb0_Wujyg=zH18+dzxMPTUUpiYBeUSiG7MpSKQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 28, 2012 at 09:51:48PM +0800, Zhi Yong Wu wrote:
> On Sun, Oct 28, 2012 at 3:55 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > Hi Zhiyong,
> >
> > On Thu, Oct 25, 2012 at 11:08:55PM +0800, zwu.kernel@gmail.com wrote:
> > [snip]
> >> @@ -199,6 +342,54 @@ err:
> >>  }
> >>
> >>  /*
> >> + * Main function to update access frequency from read/writepage(s) hooks
> >> + */
> >> +inline void hot_update_freqs(struct inode *inode, u64 start,
> >> +                     u64 len, int rw)
> >
> > This function seems too big.  So we really need to inline this function?
> As Dave said in his comments, it will add a function call
> overhead even when tracking is not enabled. a static inline function
> will just result in no extra overhead other than the if
> statement....

I don't think I said that with respect to this code. I think I said
it w.r.t. a define or a small wrapper that decides to call
hot_update_freqs().  A static inline fucntion should only be a
couple of lines of code at most.

A static function, OTOH, can be inlined by the compiler if the
compiler thinks that is a win. But....

.....

> >> +EXPORT_SYMBOL_GPL(hot_update_freqs);

... it's an exported function, so it can't be inline or static, so
using "inline" is wrong whatever way you look at it. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
