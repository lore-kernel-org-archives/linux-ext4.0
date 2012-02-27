From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v2] e2fsck: Discard only unused parts of inode
 table
Date: Mon, 27 Feb 2012 08:03:46 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202270759180.5597@dhcp-27-109.brq.redhat.com>
References: <1330014566-2020-1-git-send-email-lczerner@redhat.com> <20120227054227.GB9881@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	psusi@ubuntu.com, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab2B0HDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 02:03:52 -0500
In-Reply-To: <20120227054227.GB9881@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Feb 2012, Ted Ts'o wrote:

> On Thu, Feb 23, 2012 at 05:29:25PM +0100, Lukas Czerner wrote:
> > When calling e2fsck with '-E discard' option it might happen that
> > valid inodes are discarded accidentally. This is because we just
> > discard the part of inode table which lies past the highest used
> > inode. This is terribly wrong (sorry!).
> 
> Is this description accurate?  We *do* want to discard the part of the
> inode table past the highest used inode number.  By definition
> everything past that to the end of the bg's inode table is unsued,
> right?  The problem was before we were using the free inode count as I
> understand things.
> 
> 						- Ted
> 

Once again with my terrible English expressions. Yes, we were using free
inode count, which is wrong. Now we discard every free extent in the
inode table. I'll update the description.

Thanks!
-Lukas
