From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: 2nd Attempt - FSCK Errors
Date: Fri, 3 May 2013 19:42:55 +0100
Message-ID: <001601ce482e$07282510$15786f30$@ntlworld.com>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com> <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca> <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com> <20130503131421.GC32297@thunk.org> <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com> <20130503152914.GE32297@thunk.org>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:46321 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3ECSmt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 May 2013 14:42:49 -0400
Received: by mail-we0-f169.google.com with SMTP id x51so1585476wey.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 May 2013 11:42:48 -0700 (PDT)
In-Reply-To: <20130503152914.GE32297@thunk.org>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks very much... I do appreciate you guys are developers and not support
people :) The only thing is it is difficult to try and grasp an
understanding when troubleshooting FS problems, since they generally just
resolve themselves in my experience (Slackware linux user for 10+ years).

We have another NAS which acts as a warm standby. To be on the safe side, I
tested debugfs on that just to ensure it didn't crash the box etc. The
standby box is running totally clean.

One thing maybe you could explain (and Andreas gave me his take too) is how
you can multiply assigned blocks shared with "0" files. Andreas offered the
suggestion that they may be in the same file. If this were really the case,
I would suspect there to be some file corruption issues etc...

I think I am going to move the file off the device, run FSCK and then put it
back on and monitor.

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: 03 May 2013 16:29
To: Stephen Elliott
Cc: 'Andreas Dilger'; linux-ext4@vger.kernel.org
Subject: Re: 2nd Attempt - FSCK Errors

On Fri, May 03, 2013 at 02:31:41PM +0100, Stephen Elliott wrote:
> Well... Funny enough, the device which I ran debugfs on was the other 
> ReadyNAS device, not the one with the issue anyway. I wanted to test 
> it first.

Was the inode number from the other device as well?  Sorry, this is the
first I've heard that there are two ReadyNAS devices in play.
It's one of the reasons why it's really painful to try to be a help desk for
these sorts of questions over e-mail....

> I suspect the underlying architecture supporting RAID in these devices 
> screws with the debugfs interface.

Debugfs uses the standard Linux block device interface.  If that's not sane,
e2fsck isn't going to be sane either, and it's a kernel bug.  At that point,
you'll have to talk to ReadyNAS folks since they are providing the kernel
you are using (or the wonky non-standard hardware, or both....)

> I just find it bizarre that I get the same message regarding multiply 
> assigned blocks in 0 files on every FSCK as in it never gets resolved.
> But... No issues with file access or no bad logs etc. I do have a case 
> open with Netgear support, since this is basically an appliance.

There have been NAS boxes out there which have used non-standard, out of
tree kernel patches that have resulted in their devices using non-standard
file system formats.  So that's yet another thing which can't be ruled
out...

						- Ted

