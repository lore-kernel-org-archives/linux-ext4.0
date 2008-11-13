From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 unlink performance
Date: Thu, 13 Nov 2008 14:46:28 -0500
Message-ID: <20081113194628.GB21652@mit.edu>
References: <20081113185712.GB11204@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bruce Guenter <bruce@untroubled.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44406 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756326AbYKMTqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 14:46:32 -0500
Content-Disposition: inline
In-Reply-To: <20081113185712.GB11204@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 12:57:12PM -0600, Bruce Guenter wrote:
> 
> Ouch.  Why is ext4 so much slower than ext3 here, and why is there such
> a huge discrepancy between the different inode sizes?  The filesystems
> were created with the stock options except for inode size and ^huge_file
> (for historical reasons when I was testing with older kernels).
> 

I'm assuming that ext3 filesystem was created with htree enabled
(possibly not true on older versions of e2fsprogs), but if you're
creating ext4 filesystems, I'm assuming that you have been using an
1.41.x version of e2fsprogs.

If this the the case, the most likely explanation is that that ext4
defaults to barriers enabled, and ext3 defaults to barriers disabled.
So try mounting ext3 with "-o barriers=1", or ext4 with "-o
barriers=0", so that the comparison is between apples and apples.

Regards,

						- Ted

