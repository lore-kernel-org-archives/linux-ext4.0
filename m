From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't give the "disabling delalloc" if not
 explicitly specified
Date: Mon, 15 Aug 2011 13:54:26 -0400
Message-ID: <20110815175426.GB5948@thunk.org>
References: <1313290358-12611-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1108151134280.3695@dhcp-27-109.brq.redhat.com>
 <4E494246.2050609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34674 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HORy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 13:54:29 -0400
Content-Disposition: inline
In-Reply-To: <4E494246.2050609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 15, 2011 at 10:59:02AM -0500, Eric Sandeen wrote:
> 
> The giant behavior-options switch in ext4 is confusing enough; if enabling
> one option disables another default option, I think that explicitly stating
> it in the logs is useful.  Doing so silently just covers up the behavior.
> 
> If users are unhappy with the message, it's probably more because of 
> the fact of the matter, and not because of the presentation of the fact.  :)

Most users probably have no idea what "delalloc" actually means.  So
when they get a message that saying that data=journalled has disabled
delalloc, it could easily be seen as noise.  I was moved to do it
because I got tired of seeing the message over, and over, and over
again when running xfstests.

Maybe an improvement would be (1) to document what data=journal
implies in the Documentation/filesystems/ext4.txt, (2) change the
message to explicitly say "delayed allocation" instead of "delalloc"
(although many people won't have any idea what "delayed allocation"
means either), and (3) make it a printk_once thing.

I guess I don't agree with the fundamental presumption which is that
users should be looking at the dmesg output to understand what various
things mean, and if they didn't explicitly specify delalloc, why
should we complain about the fact that both delalloc and data=journal
were specified (when in fact it wasn't specified).

						- Ted
