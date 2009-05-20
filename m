From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Wed, 20 May 2009 07:21:08 -0400
Message-ID: <20090520112108.GA24836@mit.edu>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu> <4A130022.6090807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47537 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006AbZETLVN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 07:21:13 -0400
Content-Disposition: inline
In-Reply-To: <4A130022.6090807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 19, 2009 at 01:53:22PM -0500, Eric Sandeen wrote:
> > No, I didn't but thanks for reminding me; I agree it's a good cleanup.
> > We should get it ported over to ext4, too.
> 
> I'll do that, unless anyone's already started.

If you would, that would be great.

> There's a bit of inconsistency in the patch between:
> 
> ext3_msg(sb, KERN_ERR "message");
> and
> ext3_msg(sb, KERN_ERR, "message");

Obviously the second is what is preferred.  :-)

If you have a chance, could you clean up Andi's patch and resend it?
I have one or two minor ext3 fixups in the ext4 tree, but we should
check and make sure Andrew isn't carrying anything major in his mmotm
tree, so as to avoid patch collisions.

							- Ted
