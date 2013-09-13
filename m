From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fwd: Fwd: strange e2fsck magic number behaviour
Date: Fri, 13 Sep 2013 15:46:15 -0400
Message-ID: <20130913194615.GD15366@thunk.org>
References: <CA+qGm=-0w+gTh6=ZJhns_=4LKksJueiaYF0gxogmj=TmFN7yQg@mail.gmail.com>
 <CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
 <5231EF7D.20501@redhat.com>
 <CA+qGm=-jHzxFmb1yHqoB9UC8c7nvJN-WVP2Bb67=G63OKE3_2Q@mail.gmail.com>
 <CA+qGm=99UEZpm4nvess8g3n4bO+iTwehVda1UY3xyTjdeMOhrA@mail.gmail.com>
 <52320EFB.6080100@redhat.com>
 <CA+qGm=-xi4SPeq6JXRqQf8fdyiE4fC27o9258_adUSqHY0jAQg@mail.gmail.com>
 <CA+qGm=8zwugE8VB3WdbTeYjxpmJP751k=wv=H=rrVmN4i6+J2Q@mail.gmail.com>
 <CA+qGm=-wZz1ZzTSxZ1U-7QkqFu-t9j=3BZZz+MFpZ=yL8=ec7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Alexander Harrowell <a.harrowell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59831 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3IMTqT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Sep 2013 15:46:19 -0400
Content-Disposition: inline
In-Reply-To: <CA+qGm=-wZz1ZzTSxZ1U-7QkqFu-t9j=3BZZz+MFpZ=yL8=ec7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 13, 2013 at 01:33:12PM +0000, Alexander Harrowell wrote:
> Hmm, coming back to this, block 16777215 with identical content is
> recurring at intervals of 8 inodes.

So you might want to check and see if there are overlapping metadata
blocks --- that is, a bitmap allocation block that is also part of the
inode table block, or multiple block groups that point at the same
place for their inode table block.

The other thing is before you do more experimentation, I hope you have
made an image backup of your disk.  The more you play games by running
clri and then re-running e2fsck, the more likely that you might
accidentally do damage that might cause less data to be recovered.

In general, especially when the file system is this small such that
it's relatively easy to do an image level backup, the moment that you
think something might have gone off the rails, the wisest thing to do
is to make an image-level backup of the partition before you try to
repair things.

The other thing that has to be asked here is how much do you care
about this 64GB worth of data?  How much is OS data that can be easily
reproduced via an install, and how much are things like your home
directory?  And how recent was your last backup?  It may be that it's
not worth doing a whole lot more work trying to figure out what was
going on.

The other thing is that if this file system is this small, would you
be willing to use e2image to send me a copy of the metadata blocks, so
I can take a look at it myself.  No guarantees that I will find
anything useful, but I'll probably get more information that way.

Regards,

							- Ted
