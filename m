From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Fri, 9 Sep 2011 18:10:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109091808030.22382-100000@netrider.rowland.org>
References: <20110909191354.GC3818@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: bugzilla-daemon@bugzilla.kernel.org, <linux-ext4@vger.kernel.org>,
	<rockorequin@hotmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39098 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758006Ab1IIWK2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 18:10:28 -0400
In-Reply-To: <20110909191354.GC3818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 9 Sep 2011, Ted Ts'o wrote:

> Rocko, Alan, could you try this patch and see what happens.  It may be
> that we'll crash somewhere else; the problem is that Linux that the
> low-level generic hd routines doesn't have a formal way of informing
> the VFS and layers below that the disk has disappeared.  It just yanks
> it out from under the file system, and we've been manually patching
> around kernel crashes....

I confirm that this patch fixes the issue on with my test script.  The 
unmounts occurred with no apparent problems.

However you probably should make the same change to the ext3 driver, 
because it has exactly the same issue and some people may still be 
using it.

Alan Stern

