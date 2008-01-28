From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [3/18] BKL-removal: Convert ext3 to use unlocked_ioctl
Date: Mon, 28 Jan 2008 07:02:15 +0100
Message-ID: <200801280702.15484.ak@suse.de>
References: <20080127317.043953000@suse.de> <20080127021709.55F0814D2E@wotan.suse.de> <20080127213347.5bf5c324.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:60598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYA1GDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 01:03:52 -0500
In-Reply-To: <20080127213347.5bf5c324.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 28 January 2008 06:33, Andrew Morton wrote:
> On Sun, 27 Jan 2008 03:17:09 +0100 (CET) Andi Kleen <ak@suse.de> wrote:
> > I checked ext3_ioctl and it looked largely safe to not be used
> > without BKL.  So convert it over to unlocked_ioctl.
> >
> > The only case where I wasn't quite sure was for the
> > dynamic fs grow ioctls versus umounting -- I kept the BKL for those.
>
> Please cpoy linux-ext4 on ext2/3/4 material.

Ok I'll resubmit those to tytso/ext4-devel (or perhaps he has already seen 
them) 

>
> I skippped a lot of these patches because I just got bored of fixing
> rejects.  Now is a very optimistic time to be raising patches against
> mainline.

JFS and CIFS are already taken care of by the maintainers. This leaves
remote_llseek which touches a couple of file systems. Could you
perhaps take that one only please? And perhaps Nick's minix 
patchkit which looks safe to me and is unlikely to cause conflicts.

> > +		/* AK: not sure the BKL is needed, but this might prevent
> > +		 * races against umount */
> > +		lock_kernel();
> >  		err = ext3_group_add(sb, &input);
> >  		journal_lock_updates(EXT3_SB(sb)->s_journal);
> >  		journal_flush(EXT3_SB(sb)->s_journal);
> >  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
> > +		unlock_kernel();
>
> The ext3_ioctl() caller has an open fd against the fs - should be
> sufficient to keep unmount away?

True. I am still conservative because group_add is a lot of code
which I didn't fully check. But with the open fd it's likely safe
to not take the BKL because there is nothing else (except
readdir?) in ext* that takes it.

> It's all reached the stage of stupid.

I'll resubmit ->fasync_unlocked against -mm.

Also I wanted to recheck the ->f_flags locking. I found one bug in those 
already and I can extract the bug fix for that one. 

-Andi
