From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Mon, 28 Feb 2011 10:44:44 +0100
Message-ID: <20110228094444.GD4834@bitwizard.nl>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com> <1298638173-25050-4-git-send-email-lczerner@redhat.com> <20110226164442.GD2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:48341 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752677Ab1B1Joq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 04:44:46 -0500
Content-Disposition: inline
In-Reply-To: <20110226164442.GD2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 11:44:42AM -0500, Ted Ts'o wrote:
> ext2/3/4's 2TB maximum file size limit.  The qcow2 image might be only
> a few hundreds of megabytes, so being able to have e2fsck operate on
> that image directly would be a huge win. 

driepoot:~> ls -ls /mnt/md3.img 
61558920 -rw------- 1 root root 2937535070208 Feb 26 00:36 /mnt/md3.img

61 Gigabytes in my case... (and my system finished counting: I have
8.9M directories on there...)

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
