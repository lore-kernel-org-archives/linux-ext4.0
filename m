From: Ted Ts'o <tytso@mit.edu>
Subject: Re: mkfs'ing a 48-bit fs... or not.
Date: Tue, 4 Oct 2011 00:28:14 -0400
Message-ID: <20111004042814.GO6684@thunk.org>
References: <4E8A2F3F.30700@sandeen.net>
 <4E8A859C.2070501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@sandeen.net>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58237 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1JDE2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 00:28:17 -0400
Content-Disposition: inline
In-Reply-To: <4E8A859C.2070501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2011 at 11:03:40PM -0500, Eric Sandeen wrote:
> It comes up with too many inodes, then tries to reduce the count,
> but the "waste not want not" logic bumps it back up... ipg eventually
> goes "below" 0 but it's unsigned so it goes on in this loop forever.

Oh, this is because of the fact that we can't have more than 2**32
inodes, right?  Doh!

> Some of this is my fault... I put that retry logic in years ago.  :(
> 
> I'll see what I can do to fix it up.

Many thanks.  I've fixed the other issues you've pointed out.  Check
out the next branch on github...

					- Ted
