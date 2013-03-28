From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Failure of resize2fs past 4TB
Date: Thu, 28 Mar 2013 07:55:54 -0400
Message-ID: <20130328115554.GA5737@thunk.org>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
 <5153BFA5.9090404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Jolly <john.jolly@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56698 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab3C1MEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 08:04:21 -0400
Content-Disposition: inline
In-Reply-To: <5153BFA5.9090404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 10:57:25PM -0500, Eric Sandeen wrote:
> > I know it is unusual to start so small and expand like this, but I
> > doubt I am the only one to have experienced this. How could I have
> > prepared my small 1GB file system so that it would be able to handle
> > an expansion past 2TB? Any help would be appreciated.
> 
> not sure; you haven't done anything wrong, this simply looks like
> a resize bug, of which there have been a few lately I'm afraid.

Note that what might have corrupted your file system may be different
from the reproduction case which you've sent (which I've also
confirmed).  There was a number of off-line resize bugs fixed between
1.42.6 and 1.42.7.  In general, off-line resize has been a bit more
problematic recently than on-line resize.  (Although if you're using
an older kernel, online resize didn't work when starting with a
super-small file system and then grow it to something large.)

Thanks for sending this bug report; we'll get right on it.

Can you say a bit more about the resize2fs failure you had with your
production file system?  Was it a similar "start really small and grow
very big" pattern?  Or something else?

						- Ted
