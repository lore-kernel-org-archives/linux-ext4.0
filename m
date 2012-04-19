From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 3/3] ext4: use the O_HOT and O_COLD open flags to
 influence inode allocation
Date: Thu, 19 Apr 2012 15:59:09 -0400
Message-ID: <20120419195909.GG6317@thunk.org>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <1334863211-19504-4-git-send-email-tytso@mit.edu>
 <4F906B58.604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45674 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2DST7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 15:59:14 -0400
Content-Disposition: inline
In-Reply-To: <4F906B58.604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 02:45:28PM -0500, Eric Sandeen wrote:
> 
> I'm curious to know how this will work for example on a linear device
> make up of rotational devices (possibly a concat of raids, etc).
> 
> At least for dm, it will be still marked as rotational,
> but the relative speed of regions of the linear device can't be inferred
> from the offset within the device.

Hmm, good point.  We need a way to determine whether this is some kind
of glued-together dm thing versus a plain-old HDD.

> Do we really have enough information about the storage under us to
> know what parts are "fast" and what parts are "slow?"

Well, plain and simple HDD's are still quite common; not everyone
drops in an intermediate dm layer.  I view dm as being similar to
enterprise storage arrays where we will need to pass down an explicit
hint with block ranges down to the storage device.  However, it's
going to be a long time before we get that part of the interface
plumbed in.

In the meantime, it would be nice if we had something that worked in
the common case of plain old stupid HDD's --- we just need a way of
determining that's what we are dealing with.

					- Ted
