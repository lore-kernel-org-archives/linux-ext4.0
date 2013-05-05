From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: 2nd Attempt - FSCK Errors
Date: Sun, 5 May 2013 12:19:30 +0100
Message-ID: <002001ce4982$6a392870$3eab7950$@ntlworld.com>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com> <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca> <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com> <20130503131421.GC32297@thunk.org> <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com> <20130503152914.GE32297@thunk.org> <001601ce482e$07282510$15786f30$@ntlworld.com> <20130503213132.GA6032@thunk.org>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47697 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3EELTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 07:19:24 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so1778830wiv.13
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 04:19:23 -0700 (PDT)
In-Reply-To: <20130503213132.GA6032@thunk.org>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Understood... When I can get a debugfs dump from the device (following
advice from Netgear) I will post but this may be in 2 or 3 weeks time.

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: 03 May 2013 22:32
To: Stephen Elliott
Cc: 'Andreas Dilger'; linux-ext4@vger.kernel.org
Subject: Re: 2nd Attempt - FSCK Errors

On Fri, May 03, 2013 at 07:42:55PM +0100, Stephen Elliott wrote:
> One thing maybe you could explain (and Andreas gave me his take too) 
> is how you can multiply assigned blocks shared with "0" files. Andreas 
> offered the suggestion that they may be in the same file. If this were 
> really the case, I would suspect there to be some file corruption issues
etc...

It could be that the blocks appear multiple times in the file; or it could
be the storage system is returning different data on subsequent reads from
the device.

What we need is a debugfs dump of the inode on the file system that is
having trouble.  A debugfs dump of the inode from a completely underlated
file system is not useful....

						- Ted

