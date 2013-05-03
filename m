From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: 2nd Attempt - FSCK Errors
Date: Fri, 3 May 2013 14:31:41 +0100
Message-ID: <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com> <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca> <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com> <20130503131421.GC32297@thunk.org>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56828 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762205Ab3ECNbf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 May 2013 09:31:35 -0400
Received: by mail-wi0-f176.google.com with SMTP id hq12so604400wib.15
        for <linux-ext4@vger.kernel.org>; Fri, 03 May 2013 06:31:34 -0700 (PDT)
In-Reply-To: <20130503131421.GC32297@thunk.org>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well... Funny enough, the device which I ran debugfs on was the other
ReadyNAS device, not the one with the issue anyway. I wanted to test it
first.

I suspect the underlying architecture supporting RAID in these devices
screws with the debugfs interface.

I just find it bizarre that I get the same message regarding multiply
assigned blocks in 0 files on every FSCK as in it never gets resolved.
But... No issues with file access or no bad logs etc. I do have a case open
with Netgear support, since this is basically an appliance.

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: 03 May 2013 14:14
To: Stephen Elliott
Cc: 'Andreas Dilger'; linux-ext4@vger.kernel.org
Subject: Re: 2nd Attempt - FSCK Errors

What you've shown us makes me suspicious about whether the hardware device
is sane or not.  In the previous e2fsck run, it set i_size to a non-zero
value.  Yet when debugfs tries to read the same inode, it's now seeing all
zero's.

So that implies the disk (or software raid device; you haven't been clear
what the underlying storage is for this file system) is not returning the
same information for a particular block as was previously written.

If the underlying block device is not stable, there really is nothing for
e2fsck to do.  You might want to check /var/log/messages for any error
messages relating to the underlying storage device(s).  If you're seeing I/O
errors in the log files, that would be another hint.

At this point, my recommendation to you is to find a separate disk (or RAID
array if necessary) which is as big as the underlying disk, and do an image
copy (via dd or ddrescue) to a known-good storage device, and then retry the
e2fsck on this copy of the file system.

Regards,

						- Ted

