From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 14:43:22 +0200
Message-ID: <20110509124322.GB306@bitwizard.nl>
References: <031c613316176c32f09748706a086be2@imap.dd24.net> <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca> <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net> <20110509120608.GK4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, amir73il@users.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:52105 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752881Ab1EIMuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 08:50:04 -0400
Content-Disposition: inline
In-Reply-To: <20110509120608.GK4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 02:06:08PM +0200, Jan Kara wrote:
> > e2fsprogs' mkfs is really missing a check whether any known
> > filesystem/partition type/container (luks, lvm, mdadm, etc.) is already on
> > device (and a -force switch),... IIRC xfsprogs already do this more or
> > less.

>   Yes, that would be reasonable although it might break some
>   people's scripts. But probably worth it anyway.

This is a difficult change.... 

Some GUI install things already perform this check and after asking
confirmation from the user will just execute:

	mkfs.ext3 /dev/....

and expect it to make the filesystem. 

So you could add an option: 
	--check _for_existing_filesystem

But then it is quite likely that people running it manually will
forget to add the option....

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
