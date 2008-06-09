From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make some ext3 kernel messages useful by showing device
Date: Mon, 9 Jun 2008 13:48:04 -0700
Message-ID: <20080609134804.a5553e81.akpm@linux-foundation.org>
References: <1212951761.32756.4.camel@localhost>
	<20080609025926.0ecb6aea.akpm@linux-foundation.org>
	<1213018690.10545.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kasper Sandberg <lkml@metanurb.dk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754062AbYFIUs1@vger.kernel.org>
In-Reply-To: <1213018690.10545.7.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 09 Jun 2008 15:38:10 +0200
Kasper Sandberg <lkml@metanurb.dk> wrote:

> On Mon, 2008-06-09 at 02:59 -0700, Andrew Morton wrote:
> > On Sun, 08 Jun 2008 21:02:41 +0200 Kasper Sandberg <lkml@metanurb.dk> wrote:
> > 
> > > Hello.
> > > 
> > > Some of the ext3 warnings in super.c are not really as useful as they
> > > can be, for instance the "EXT3-fs warning: maximal mount count reached,
> > > running e2fsck is recommended" message, does not tell which device it
> > > actually is.
> > 
> > Seems sensible.
> > 
> > > Below is patch(both inlined, and in attached form, since i dont trust my
> > > mailer),
> > 
> > That really tricks me.  Because the resulting file applies nicely with
> > `patch --dry-run' but doesn't apply with plain old `patch'.  Inlined is
> > preferred, attached is grumpily accepted, but please avoid duplicating
> > the patch.
> 
> I do not know what happened, i did with diff -Naur. I attached because
> of the fact that i _KNOW_ evolution is not to be trusted with inlined,
> but i also know inlined is easier for review, even if it is not properly
> accepted as input for patch.

What happened was that you inlined the patch and also attached it.  So
when my email client does save-to-file, I get two copies of the same
patch in the one local file.  This causes me problems.

I suggest that you try to inline the patches.  Email yourself a patch,
check that it still applies.  If this ends up being too hard then sure,
use attachments, but please don't also inline the patch.

> > 
> > > to a patch which fixes that particular message, and a few more.
> > > I could look at the rest if anyones interrested?
> > 
> > We like to keep ext3 and ext4 in sync as much as poss, please.
> Yes, i will do this soon, i have a few things to do first though.

No probs, thanks.

> > 
> > > Oh, and i dont really know if this is nessecary, but:
> > > Signed-off-by: Kasper Sandberg <lkml@metanurb.dk>
> > 
> > It is very much preferred, thanks.
> > 
> > (patch retained for linux-ext4 review)
> > 
> > > 
> > > --- super.c.orig	2008-06-08 20:49:26.153047364 +0200
> > > +++ super.c	2008-06-08 20:45:20.812047463 +0200

btw, please prepare patches in `patch -p1' form.  The headers here should have
been

--- a/fs/ext3/super.c
+++ a/fs/ext3/super.c

So the patch will apply with `patch -p1' when run from the root of the
kernel tree.
