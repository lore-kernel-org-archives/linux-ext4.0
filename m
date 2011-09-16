From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Fri, 16 Sep 2011 05:17:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109160512290.5628@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz> <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
 <20110910200414.GA6709@quack.suse.cz> <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org> <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org> <CAOQ4uxgvUsV7Qee6URzWvAkoV5VwLQWVLJWQ3VEpyVh3qbJXVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@zeniv.linux.org.uk>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:52367 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1IPMRl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 08:17:41 -0400
In-Reply-To: <CAOQ4uxgvUsV7Qee6URzWvAkoV5VwLQWVLJWQ3VEpyVh3qbJXVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Sep 2011 at 15:04, Amir Goldstein wrote:
> This is just a shot in the dark, but are you using Ubuntu on your
> production machine by any chance?

No, I'm using Debian/stable on the "production" machine (the powerpc32 
box, where the error occurs). I was trying to reproduce this in a x86 
Ubuntu/10.04 VM, but could not.

> The reason I am asking is becasue I have been getting failures to 
> umount fs, while running xfstests on ext4
> with Ubuntu for a long time and nobody else seems to share this problem.

Is there a bug open for that?

> I always suspected Ubuntu has some service that keeps open handles on
> mounted fs, but I never got to examine this.

Yeah...their "server" version needs major surgery to disable all the 
bells and whistles before it's becoming usable.

Christian.
-- 
BOFH excuse #92:

Stale file handle (next time use Tupperware(tm)!)
