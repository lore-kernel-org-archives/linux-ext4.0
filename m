From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fallocate creating fragmented files
Date: Wed, 30 Jan 2013 15:14:12 -0500
Message-ID: <20130130201412.GA32724@thunk.org>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>, linux-ext4@vger.kernel.org,
	Rob Mueller <robm@fastmail.fm>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46239 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3A3UOS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 15:14:18 -0500
Content-Disposition: inline
In-Reply-To: <510942C3.1070503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2013 at 09:56:51AM -0600, Eric Sandeen wrote:
> Ok, TBH I'd not certain why the allocator is doing just what it's doing.
> There are quite a lot of larger-than-3-block free spaces. OTOH, it might be
> trying for some kind of locality.

Yeah, I'll bet that's what's going on.

Can you show us the the inode number for each of the test files along
with the filefrag -v output?  What I suspect is going on is that the
kernel is trying too hard to start the block allocation in the same
block group which was used for the inode number.

What we probably need to do is to have some hueristic where if we know
there are plenty of block groups with lots of large contiguous free
space, and the block group which we are preferring either because it's
the same one as the inode number, or because it's where we had
previously done the last block allocation for the file, and we the
user requests a large fallocated region, that it's better to switch
over to one of the other block groups with lots and lots of free
space.

						- Ted
