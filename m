From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Ping.
Date: Sat, 15 May 2010 10:34:41 +0100
Message-ID: <20100515093441.GA20809@ZenIV.linux.org.uk>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
 <87ljd1vtth.fsf@openvz.org>
 <20100413181450.GA5720@infradead.org>
 <87y6gp2brh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	jack@suse.cz, david@fromorbit.com, xemul@openvz.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0EOJev (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 May 2010 05:34:51 -0400
Content-Disposition: inline
In-Reply-To: <87y6gp2brh.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 15, 2010 at 03:30:58PM +0400, Dmitry Monakhov wrote:

> > As long as you still have the awkward ifdefs and different semantics for
> About ifdefs style:
> How can i avoid CONFIG_PROJECT_ID without bloating inode size?
> embedded people will kill me for this.
> I just act similar quota code, or you want protect prjid logic 
> via quota config option?
> I don't remember, are we already talk about this?
> If so please remind me your vision.

You have way more ifdefs than just that.

E.g. struct iattr ones are pure junk; it's not kept around for long
time.  Moreover, since ATTR_... is not userland-reachable, you can
bloody well #define ATTR_PRJID to 0 and get rid of more ifdefs.
Ifdefs due to accesses to i_prjid can be reduced to just two inlined
helpers (get_prjid/set_prjid) and there you go...

As for the ->i_prjid itself, I'd buy ifdef there, but _not_ in that
place within structure.  You are shoving it between two pointers;
think of alignment.

As for the isolation...  Why do we care about link/rename at all?
All stuff with the same project ID gets counted together, wherever
in the tree it might be.  It's not as if we'd been scanning a subtree
and calculate the sum over it, after all.  So what is the problem?
Some bastard DoSing you by creating links from places you can't write
to?  Then you want as much isolation as possible anyway, TYVM, and
bind-as-link-barrier is entirely appropriate there.

> > "isolation" vs "not"  there's still a NACK from me.  But in the end Al
> > will have to decide if he wants to take your patches or not.

I want details on use cases and semantics for isolation stuff; as it is,
it looks rather odd.  Why move towards "neutral" part of the tree is
allowed and links over there are not, for example?
