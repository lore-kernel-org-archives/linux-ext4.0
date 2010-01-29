From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Possible ext4 data corruption with large files and async I/O
Date: Fri, 29 Jan 2010 10:49:27 -0500
Message-ID: <9721.1264780167@gamaville.dokosmarshall.org>
References: <4B62F688.70404@vectorwise.com>
 <9347.1264779008@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: Giel de Nijs <giel@vectorwise.com>, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:56193 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0A2Pt2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jan 2010 10:49:28 -0500
Received: from gamaville.dokosmarshall.org ([unknown] [173.76.32.106])
 by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0KX000629MMFVBE0@vms173007.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Fri, 29 Jan 2010 09:49:28 -0600 (CST)
In-reply-to: Message from Nick Dokos <nicholas.dokos@hp.com> of
 "Fri, 29 Jan 2010 10:30:08 EST." <9347.1264779008@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > 
> > Dear ext4 devs,
> > 
> > Today I hit a situation where seemingly blocks did not get written to 
> > disk. I've narrowed it down to the following test case.
> > 
> > Running Fedora Core 12 with kernel 2.6.31.9-174.fc12.x86_64, both on an 
> > i7 920 and a Core2 Q6600, I executed the following steps:
> > 
> > - create a file
> > - with kernel async i/o, write a 512kb (haven't tried other sizes) block 
> > to an offset >4GB, effectively creating a large sparse file
> > - again with async i/o, write a 512kb block to an offset smaller than 
> > the previous write, but >4GB
> > - wait for the kernel async i/o to tell you the writes have succeeded
> > 
> > Now, looking at the file, the second write never seems to have happened. 
> > When doing this on the same machines on ext3, the behavior is as expected.
> > 
> > As far as I can tell (from the bigger program that triggered this), all 
> > writes >4GB but < EOF to a sparse file with async i/o aren't executed. 
> > When creating a large file first (i.e., with dd), everything does work 
> > as expected.
> > 
> > Attached is some C code that triggers this bug for me.
> > 
> > If you need more information or want me to test some more things, please 
> > do ask.
> > 
> 
> I ran your program on FC-11 with a 2.6.33-rc4 upstream kernel: it worked fine.
> Both dd's gave the expected output.
> 

Scratch that: I goofed. I can reproduce it too.

Sorry for the confusion.

Nick
