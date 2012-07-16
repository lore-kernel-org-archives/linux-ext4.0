From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add support for DragonFly BSD operating system.
Date: Sun, 15 Jul 2012 22:03:28 -0400
Message-ID: <20120716020328.GA29544@thunk.org>
References: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
 <20120713003026.GA30092@thunk.org>
 <op.whiji7pcf7p71t@sixfeet.quantumachine.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Antonio Huete =?iso-8859-1?Q?Jim=E9nez?= <ahuete.devel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39245 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2GPCDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jul 2012 22:03:36 -0400
Content-Disposition: inline
In-Reply-To: <op.whiji7pcf7p71t@sixfeet.quantumachine.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 16, 2012 at 02:26:57AM +0200, Antonio Huete Jim=E9nez wrote=
:
> I've pasted both new patches in this email with the intention of
> producing less traffic in the mailing list, but I'm unsure if this
> is the correct thing to do, opposed to sending one mail per patch.

It's better to send one mail per patch.  The reason for that is we
have automated tools that do the right thing with patches sent one per
e-mail.  This includes patchwork (which tracks patches sent to the
mailing list; see
http://patchwork.ozlabs.org/project/linux-ext4/list/) and "git am".

Just use the git send-email tool; it will do the right thing.

There are places where you are using #if defined(__DragonFly__) and
there are other places where you are using #ifdef DIOCGPART.  Is there
a reason for this?

In general, it's better to avoid using explicit feature tests rather
things like defined(__Dragonfly__) or defined(__solaris__).  What if
an OS changes names or forks (i.e., like Open Solaris, Nextensa,
Illumos, etc.).

And the combination of an #ifdef based on HAVE_SYS_DISKLABEL_H,
DIOCGPART, and defined(__DragonFly__) raises red flags that the
combinatorics may be very brittle in the long run.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
