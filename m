From: "kaefert@gmail.com" <kaefert@gmail.com>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Fri, 9 Nov 2012 07:05:02 +0100
Message-ID: <CACDumsRP6+AMZdCPgyH03_NBrCWY8m_1Gp2DD9aMwqh9DtpEhA@mail.gmail.com>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63880 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2KIGFX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Nov 2012 01:05:23 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1332432eaa.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Nov 2012 22:05:22 -0800 (PST)
In-Reply-To: <20121109000156.GQ19977@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/11/9 Theodore Ts'o <tytso@mit.edu>
>
> Can you please run e2fsck from the command line, and capture the
> output (i.e., using "script").  I really need the e2fsck output to
> understand what is going on.  The strace output is really not helpful.
>
> In general, you may be better off simply not trusting gparted to run
> e2fsck and resize2fs for you.  If there are no problems I'm sure it's
> fine, but it's really hard to debug things if you insist on letting
> gparted swallon all of the useful debugging output....
>
>                                             - Ted

Hi there Ted!

Thanks for the answer! Of course I understand that when you want to
debug something you really gotta run it from the console, It's just
when I started to run this, I did not think anything would go wrong,
you never think it hits you ;)

After e2fsck failed for the first time (where I don't know why, since
gparted crashed after I tried to save the details), I started to run
e2fsck manually, and since the -p option made him cancel the run I
started a third run in interactive mode. I've posted the console
output of this second and third run as an update to my question at
serverfault.com (see
http://serverfault.com/questions/446074/e2fsck-extremely-slow-although-enough-memory-exists
- start reading at "UPDATE4")

The 3rd run is still running (since about 20 hours now) and showing
the same pattern as the first run that failed after 78 hours.


Thanks for looking at this,

Thomas K.
