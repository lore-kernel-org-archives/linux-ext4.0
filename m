From: tytso@mit.edu
Subject: Re: [PATCH] ext4: deprecate obsoleted mount options v2
Date: Tue, 23 Feb 2010 15:13:45 -0500
Message-ID: <20100223201345.GA5166@thunk.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
 <1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
 <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
 <20100218205218.GL5337@thunk.org>
 <87d401jnml.fsf_-_@openvz.org>
 <57C5D8FD-F729-4C01-8485-6E76E7D2BDE6@sun.com>
 <87bpffpxha.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53336 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab0BWUNs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2010 15:13:48 -0500
Content-Disposition: inline
In-Reply-To: <87bpffpxha.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 23, 2010 at 10:23:45PM +0300, Dmitry Monakhov wrote:
> >
> > I think deprecating an option is not the same as removing it entirely.
> Ohh.. I've hoped to reuse freed bits for new crap.

What "new crap" are you hoping to will need mount options?  One of the
things I want to do long term is to try to reduce/remove mount options
in general.

If we get general agreement that it's time to just turn on acl's and
xattr's by default, we can change the default, and in that case
removing the "noacl/noxattr" might be something that we might not need
to keep for as long, or maybe at all.  But for things like
bsddf/minixdf, we do need some kind of deprecation schedule.

The use of Opt_deprecated and Opt_disabled seems a little pointless;
nothing is using now, and nothing needs it.  All I'd probably do is
something like this:

static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
       "Contact linux-ext4@vger.kernel.org if you think we should keep it.\n"

And then in each option that we want to deprecate, just add:

    ext4_msg(sb, KERN_WARN, deprecated_msg, "bsddf", "2.6.39");

The extra opt_discard, and goto deprecated, etc., seems way more
complicated than what is necessary.

						- Ted
