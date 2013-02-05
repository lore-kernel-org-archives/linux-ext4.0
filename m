From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Maximum number of directories
Date: Tue, 5 Feb 2013 14:06:14 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302051309320.3225@localhost>
References: <17001225.1MS6YREEfJ@deuteros> <CAD6i1fKHDP3m8EQZVaY-3VQ+6kh5=Bv7SQhLozJJEb7UJ5q=VQ@mail.gmail.com> <3667261.Q2Z9h3nZ4l@deuteros>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3BENGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 08:06:24 -0500
In-Reply-To: <3667261.Q2Z9h3nZ4l@deuteros>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 4 Feb 2013, Tvrtko Ursulin wrote:

> Date: Mon, 04 Feb 2013 13:36:29 +0000
> From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> To: Prashant Shah <pshah.mumbai@gmail.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Maximum number of directories
> 
> On Monday 04 February 2013 18:49:54 Prashant Shah wrote:
> > Hi,
> > 
> > On Mon, Feb 4, 2013 at 4:25 PM, Tvrtko Ursulin
> > 
> > <tvrtko.ursulin@onelan.co.uk> wrote:
> > > I was creating such a (crazy?) tree and hit -ENOSPC at ~31 million
> > > directories created in total with df showing only 40% use:
> > > 
> > > Inode count:              29868032
> > > Free inodes:              29848131
> > 
> > Since, each directory will use a inode entry, there is some mismatch
> > with ~31 million directories and 19901 inodes in use. The inode usage
> > count should be much larger. You have max 29 million inodes available
> > - so max can be 29 million directories.
> 
> Yeah, I totally forgot about the inode situation on ext filesystems. So is 
> tune2fs giving wrong stats for live (mounted) filesystems?

Not sure what situation you're referring to. Directory as any other
file is represented by an inode and there is a limited number of
inodes in the file system.

Using tune2fs on live/mounted file system is bad idea and the
information might not be correct (exactly for this reason it is
_NOT_ recommended to run fsck on live file system). Use 'df -i' if
you want to get information about inode count.

And to answer your previous question, yes the number of directory
entries is limited. The number depends on the size of the directory
entries (the name of the file) and the size of the file system
block. From my calculation on 4k file system it can hold 3870945
files with 255B long filenames in the single directory in the ideal
case, please correct me if I am wrong.

Unfortunately the problem might appear as the directory hash tree
gets more fragmented which will limit the number of directory
entries it can hold - this can be fixed with e2fsck -D.

Thanks!
-Lukas
