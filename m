From: Pavel Machek <pavel@suse.cz>
Subject: Re: ext3 read only handling
Date: Tue, 27 Jan 2009 10:56:26 +0100
Message-ID: <20090127095626.GB18449@elf.ucw.cz>
References: <20080925150319.GA4344@elf.ucw.cz> <48DBAB0E.3090608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	jack@suse.cz, sct@redhat.com, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZA0J4k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2009 04:56:40 -0500
Content-Disposition: inline
In-Reply-To: <48DBAB0E.3090608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 2008-09-25 10:15:26, Eric Sandeen wrote:
> Pavel Machek wrote:
> > Inserting read-only ext3 SD card into a machine and trying to mount
> > ext3 volume on it is very unnice :-(.
> > 
> > Is there easy way to "fix" -oro so that it does not write to the
> > media?
> > 
> > (Machine died after I played with that SD card a bit more, but I can't
> > easily reproduce that...)
> 
> Is the block device recognized as readonly?
> 
> ext3_load_journal() does things like:
> 
>         really_read_only = bdev_read_only(sb->s_bdev);
> ...
>                         printk(KERN_INFO "EXT3-fs: INFO: recovery "
>                                         "required on readonly
> filesystem.\n");
>                         if (really_read_only) {
>                                 printk(KERN_ERR "EXT3-fs: write access "
>                                         "unavailable, cannot proceed.\n");
>                                 return -EROFS;
>                         }
> 
> so it shouldn't have tried to replay the log ...
> 
> (replaying the log & writing to the device on a read-only mount is
> another issue, but the behavior today is *supposed* to be such that if
> you cannot write to the device, then even a read-only mount with a dirty
> journal should fail gracefully, not explode ....)

Well, that card is so broken I'm afraid to insert it into machine any
more. I had hard time removing it on last attempt. But these days at
least "ro,noload" is documented, so... 

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
