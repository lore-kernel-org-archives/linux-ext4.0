From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Sat, 7 May 2016 13:47:46 -0400
Message-ID: <20160507174746.GA2831@thunk.org>
References: <945936769.469311462626349850.JavaMail.weblogic@ep2mlwas09a>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?B?7J206riw7YOc?= <kitae87.lee@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56862 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbcEGRrx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2016 13:47:53 -0400
Content-Disposition: inline
In-Reply-To: <945936769.469311462626349850.JavaMail.weblogic@ep2mlwas09a>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 07, 2016 at 01:05:49PM +0000, Daeho Jeong wrote:
> 
> Actually, we had executed power on/off test repeatedly with 10 Android
> devices for a month. But, during the test, just this problem only happened
> repeatedly, even if it occurred very rarely. So we had concluded that we
> had to fix this problem certainly.
> 
> However, I can see the point now. Android have misused the emergency
> ro-remount and the filesystem crash by emergency ro-remount is not an issue.
> I can understand the purpose of the emergency ro-remount.
> 
> I heard that the next version of Android will do full scan of ext4 filesystems
> using e2fsck every boot-up, so the existing problem will be naturally resolved,
> even if it might not be the right solution.

I've sent an inquiry to contacts I have in the Google Android team, to
make sure they're aware of the potential issues, whether or not it
gets addressed (by accident) in the next version of Android.

Something to consider is that it's not clear (for example) whether or
not some other file system, such as f2fs, will do the right thing with
such a scheme (and what kind of application data loss you might have,
even if the file systrem checker is run at boot-up).  Or if you have a
process which is actively writing to a SD card containing a VFAT file
system at the time of the shutdown, whether or not it will do the
right thing.

So there are some bigger issues that probably need to be considered,
not just with ext4.

						- Ted
