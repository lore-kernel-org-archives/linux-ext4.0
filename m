From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Fri, 25 Jan 2013 10:25:14 +0800
Message-ID: <20130125022514.GA10883@gmail.com>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
 <20130124195158.GC9477@thunk.org>
 <5101980D.30904@ubuntu.com>
 <20130124203230.GA20776@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:38513 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3AYCLQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 21:11:16 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so4539314dak.6
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 18:11:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130124203230.GA20776@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 03:32:30PM -0500, Theodore Ts'o wrote:
> On Thu, Jan 24, 2013 at 03:22:37PM -0500, Phillip Susi wrote:
> > 
> > On 1/24/2013 2:51 PM, Theodore Ts'o wrote:
> > > How did you find this?  I've done a quick search for SEEK_CUR, and
> > > it looks like only place where this could cause a problem is with 
> > > e2image.  And a quick test of a i386 version of e2image with a
> > > large file system is that it does indeed blow up with an
> > > "Inappropriate ioctl for device" error.
> > 
> > That's where I found it, but the error should be "seek: Value too
> > large for defined data type"
> 
> Well, I did my testing using an i386 debian/testing chroot running
> under a x86-64 3.8.0-rc3 kernel.  I'm guessing it was the use of a
> 32-bit userspace / 64-bit kernel that probably explains the
> difference.
> 
> > > Is there any other potential problems that are caused by this bug?
> > > I like to explain the impacts of bug fixes in libext2fs for folks
> > > who are doing bug fix / code archeology.
> > 
> > If e2image is the only internal user of the call with SEEK_CUR, then I
> > guess it only affects any external users of the library who were doing
> > this ( I am not aware of any ).
> 
> Well, there are some binaries that aren't usually built by most
> distributions (make-sparse and copy-sparse), but in terms of primary
> e2fsprogs programs (mke2fs, e2fskc, tune2fs, chattr, lsattr, etc.)
> nope, none of them use SEEK_CUR.
> 
> The lib/ext2fs/fileio.c file does use SEEK_CUR, which means it might
> impact 3rd party packages such as e2tools and ext2fuse (although
> that's generally only used on Mac and Windows systems).

Hi Ted,

This patch makes me consider my patches that dump a sparse file in
debugfs.  In my patch [1] llseek64(2) is called to seek to the next
data in target file.  So I believe ext2fs_llseek() is a better choice.
I am happy to send a newer patch to fix it.  What do you think?

1. http://www.spinics.net/lists/linux-ext4/msg36134.html

Thanks,
                                                - Zheng
