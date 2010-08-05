From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] Add batched discard support for ext3
Date: Thu, 5 Aug 2010 16:00:20 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008051559140.3063@localhost>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com> <1280929475-12823-2-git-send-email-lczerner@redhat.com> <6EE76C8F-765F-41F3-927E-BFC156A7D324@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760532Ab0HEOAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 10:00:30 -0400
In-Reply-To: <6EE76C8F-765F-41F3-927E-BFC156A7D324@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Aug 2010, Andreas Dilger wrote:

> On 2010-08-04, at 07:44, Lukas Czerner wrote:
> > +		/*
> > +		 * Clear bits in the bitmap
> > +		 */
> > +		for (bit = start; bit < next; bit++) {
> > +			BUFFER_TRACE(bitmap_bh, "clear bit");
> > +			if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, group),
> > +						bit, bitmap_bh->b_data)) {
> > +				ext3_error(sb, __func__,
> > +					"bit already cleared for block "E3FSBLK,
> > +					 (unsigned long)bit);
> > +				BUFFER_TRACE(bitmap_bh, "bit already cleared");
> > +			} else {
> > +				freed++;
> > +			}
> > +		}
> > +
> > +		/* Update couters */
> > +		spin_lock(sb_bgl_lock(sbi, group));
> > +		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
> > +		spin_unlock(sb_bgl_lock(sbi, group));
> > +		percpu_counter_add(&sbi->s_freeblocks_counter, next - start);
> 
> It wouldn't be a terrible idea to put this code into a helper function that is shared with ext3_free_blocks_sb() so that it is kept in sync.  There are a lot of places that need to be kept coordinated (disk bitmap, memory bitmap, group descriptor, percpu counter) so I'd like that to be localized to one part of the code.
> 
> 
> Cheers, Andreas
> 

Ok, I will see what I can do with that.

Thanks.

-Lukas
