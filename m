From: Joseph Fannin <jfannin@gmail.com>
Subject: Re: Re: Autoremoval of test_fs flag kinda sucks
Date: Thu, 12 Feb 2009 11:43:49 -0500
Message-ID: <20090212164349.GA32508@nineveh.local>
References: <20081221134326.GA26216@nineveh.local> <20081222022815.GD23723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:5229 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbZBLQn5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 11:43:57 -0500
Received: by ey-out-2122.google.com with SMTP id 25so94339eya.37
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 08:43:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20081222022815.GD23723@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 21, 2008 at 09:28:15PM -0500, Theodore Tso wrote:
> On Sun, Dec 21, 2008 at 08:43:27AM -0500, Joseph Fannin wrote:
> > This is mostly me blowing off a little steam here, so yeah.  But maybe
> > it won't hurt to send out a heads up and get this in the archives:
> >
> > Booting a 2.6.28-pre kernel will cause e2fsck to remove the test_fs
> > flag from any filesystem it checks, presumably because "ext4dev" has
> > become "ext4" in 2.6.28.  If your root fs is on ext4, this makes it
> > impossible to reboot back into a older kernel (i.e. < 2.6.28) since it
> > will refuse to mount an ext4dev fs without the "test_fs" flag set --
> > unless you chase after e2fsck and set the flag back.
>
> Yeah, Sorry I guess I didn't think it was going to be *that* common
> for people to be going back and forth between the boundary.  It is
> possible to disable this, BTW, via /etc/e2fsck.conf:
>
> [options]
> 	clear_test_fs_flag = false
>
> The assumption I made was that the number of pre-2.6.28 ext4 users
> would be small, and so it would be safe to default the option to true.

I wanted to thank you for the reply to this (old) mail; due to the
vagaries of Gmail I didn't see this until yesterday when I went
searching the linux-ext4 archives.  I need to bone up on my
procmail-foo, but I keep putting it off.

It sounds like I should have mentioned this issue when it first came
up; I might not only have saved myself some trouble, but had something
more productive "for the archives".

Of course, I only went looking at the linux-ext4 archives because I
have another problem:  I have a damaged ext4 filesystem that fsck
can't fix.  I've been making preparations to zap it with a new mkfs,
but before I take the plunge it might be best to ask for a bit of
help.

I don't suppose there's a .deb of e2fsprogs v1.41.4 around somewhere,
is there?  I'm guessing the Debian freeze is the reason why it's not
in unstable yet.  I can build it myself if not, no worries.

Also, would there be any value in an image of this broken fs before I
blow it away?  I'm not comfortable sharing the whole thing, but I
understand it's possible to create an image with no data and scrambled
filenames.

I'm currently running the FS without a journal, because it won't mount
with the "has_journal" flag set; the kernel complains "no journal
found" IIRC.  I tried recreating the journal (removing the
"has_journal" flag, then doing a `tune2fs -j`) but it still doesn't
work.

I'm taking my time with this, copying data to wherever I can find
space, because I don't have a backup.  Both pieces, yes.  I'm batshit,
yes.  Once I get over half the data copied off, I intend to try to
shrink the FS, create a new LVM volume with the freed disks, copy the
data over, then grow the FS to encompass the new (old) disks.  It took
me longer than it probably should to realize that resize2fs might
choke on the filesystem, broken as it is.  Oh well.

If any of this info could be useful, or if there's something obvious
I'm missing, please let me know.  Thanks.

--
Joseph Fannin
jfannin@gmail.com

