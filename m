From: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [PATCH] Make some ext3 kernel messages useful by showing device
Date: Mon, 09 Jun 2008 15:38:10 +0200
Message-ID: <1213018690.10545.7.camel@localhost>
References: <1212951761.32756.4.camel@localhost>
	 <20080609025926.0ecb6aea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:48643 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYFINjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2008 09:39:12 -0400
In-Reply-To: <20080609025926.0ecb6aea.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-06-09 at 02:59 -0700, Andrew Morton wrote:
> On Sun, 08 Jun 2008 21:02:41 +0200 Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > Hello.
> > 
> > Some of the ext3 warnings in super.c are not really as useful as they
> > can be, for instance the "EXT3-fs warning: maximal mount count reached,
> > running e2fsck is recommended" message, does not tell which device it
> > actually is.
> 
> Seems sensible.
> 
> > Below is patch(both inlined, and in attached form, since i dont trust my
> > mailer),
> 
> That really tricks me.  Because the resulting file applies nicely with
> `patch --dry-run' but doesn't apply with plain old `patch'.  Inlined is
> preferred, attached is grumpily accepted, but please avoid duplicating
> the patch.

I do not know what happened, i did with diff -Naur. I attached because
of the fact that i _KNOW_ evolution is not to be trusted with inlined,
but i also know inlined is easier for review, even if it is not properly
accepted as input for patch.

> 
> > to a patch which fixes that particular message, and a few more.
> > I could look at the rest if anyones interrested?
> 
> We like to keep ext3 and ext4 in sync as much as poss, please.
Yes, i will do this soon, i have a few things to do first though.
> 
> > Oh, and i dont really know if this is nessecary, but:
> > Signed-off-by: Kasper Sandberg <lkml@metanurb.dk>
> 
> It is very much preferred, thanks.
> 
> (patch retained for linux-ext4 review)
> 
> > 
> > --- super.c.orig	2008-06-08 20:49:26.153047364 +0200
> > +++ super.c	2008-06-08 20:45:20.812047463 +0200
> > @@ -1188,31 +1188,31 @@
> >  	int res = 0;
> >  
> >  	if (le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV) {
> > -		printk (KERN_ERR "EXT3-fs warning: revision level too high, "
> > -			"forcing read-only mode\n");
> > +		printk (KERN_ERR "EXT3-fs on %s warning: revision level too high, "
> > +			"forcing read-only mode\n", sb->s_id);
> >  		res = MS_RDONLY;
> >  	}
> >  	if (read_only)
> >  		return res;
> >  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
> > -		printk (KERN_WARNING "EXT3-fs warning: mounting unchecked fs, "
> > -			"running e2fsck is recommended\n");
> > +		printk (KERN_WARNING "EXT3-fs on %s warning: mounting unchecked fs, "
> > +			"running e2fsck is recommended\n", sb->s_id);
> >  	else if ((sbi->s_mount_state & EXT3_ERROR_FS))
> >  		printk (KERN_WARNING
> > -			"EXT3-fs warning: mounting fs with errors, "
> > -			"running e2fsck is recommended\n");
> > +			"EXT3-fs on %s warning: mounting fs with errors, "
> > +			"running e2fsck is recommended\n", sb->s_id);
> >  	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
> >  		 le16_to_cpu(es->s_mnt_count) >=
> >  		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
> >  		printk (KERN_WARNING
> > -			"EXT3-fs warning: maximal mount count reached, "
> > -			"running e2fsck is recommended\n");
> > +			"EXT3-fs on %s warning: maximal mount count reached, "
> > +			"running e2fsck is recommended\n", sb->s_id);
> >  	else if (le32_to_cpu(es->s_checkinterval) &&
> >  		(le32_to_cpu(es->s_lastcheck) +
> >  			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
> >  		printk (KERN_WARNING
> > -			"EXT3-fs warning: checktime reached, "
> > -			"running e2fsck is recommended\n");
> > +			"EXT3-fs on %s warning: checktime reached, "
> > +			"running e2fsck is recommended\n", sb->s_id);
> >  #if 0
> >  		/* @@@ We _will_ want to clear the valid bit if we find
> >                     inconsistencies, to force a fsck at reboot.  But for
> > @@ -1339,8 +1339,8 @@
> >  	}
> >  
> >  	if (bdev_read_only(sb->s_bdev)) {
> > -		printk(KERN_ERR "EXT3-fs: write access "
> > -			"unavailable, skipping orphan cleanup.\n");
> > +		printk(KERN_ERR "EXT3-fs on %s: write access "
> > +			"unavailable, skipping orphan cleanup.\n", sb->s_id);
> >  		return;
> >  	}
> >  
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

