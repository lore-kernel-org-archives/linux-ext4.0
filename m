From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: Query FSCK Errors on ext4
Date: Wed, 20 Nov 2013 12:46:53 -0000
Message-ID: <000d01cee5ee$96eb8e40$c4c2aac0$@ntlworld.com>
References: <008701cecc19$14734370$3d59ca50$@ntlworld.com> <F81EF3B4-CEBF-43FD-BD38-0AFFF56014C6@dilger.ca> <20131028063905.GA9017@gmail.com> <000e01ced3bc$2af03220$80d09660$@ntlworld.com> <13AE0AAC-F9F6-404F-B55E-F38C2015864B@dilger.ca> <001f01cee525$0be60e20$23b22a60$@ntlworld.com> <AB177EF8-199A-4A6D-A08F-2A6951F5F100@dilger.ca> <002901cee54d$b7d2efa0$2778cee0$@ntlworld.com> <93E08C0E-E398-4C7C-B7E7-C0591F6AA722@dilger.ca> <002a01cee568$c588cf00$509a6d00$@ntlworld.com> <C8263588-E5AD-4C23-81E3-5852DE3B1FC5@dilger.ca> <002e01cee56f$46f8e3d0$d4eaab70$@ntlworld.com> <528CAC89.1040405@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "'Zheng Liu'" <gnehzuil.liu@gmail.com>,
	"'David Jeffery'" <djeffery@redhat.com>,
	<linux-ext4@vger.kernel.org>, "'Eric Whitney'" <enwlinux@gmail.com>
To: "'Bernd Schubert'" <bernd.schubert@itwm.fraunhofer.de>,
	"'Andreas Dilger'" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:47489
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3KTMq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Nov 2013 07:46:56 -0500
In-Reply-To: <528CAC89.1040405@itwm.fraunhofer.de>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Bernd,

Appreciate the follow up... My issue with the ReadyNAS appliance is I don't have control of what releases etc they use.

At some point in the future, if I have a system where I can carry out this testing then I will. However, from my side this really isn't a problem, now I know about it. I came to this forum out of curiosity and wanting to ensure that there isn't a whole in the Linux Kernel / e2fsprogs which you guys would be passionate about fixing.

>From a developers perspective I imagine a simple attempt to reproduce this would be fairly simplistic and would probably be no more than an evening's work. Basically having multiple connections to a substantial MS Access DB from clients over SMB and then reloading the server. Although agree there is little point in fixing an old Kernel.

I guess we can close this discussion point now.

Many Thanks
Stephen Elliott

-----Original Message-----
From: Bernd Schubert [mailto:bernd.schubert@itwm.fraunhofer.de] 
Sent: 20 November 2013 12:35
To: Stephen Elliott; 'Andreas Dilger'
Cc: 'Zheng Liu'; 'David Jeffery'; linux-ext4@vger.kernel.org; 'Eric Whitney'
Subject: Re: Query FSCK Errors on ext4

Hello Stephen,

can you reproduce this on a fresh filesystem and on a system that you can easily update? If you can, can you update the kernel to a stable/recent version (i.e. longterm 3.10) and e2fsprogs to a current version, re-create a fresh file system and try to reproduce again? If you still can, can you try to figure out which order of syscalls is causing the corruption? Or anything else that might help to figure out the root cause?
In general, using a rather old kernel and user space tools and pointing to an issue isn't going to help you much.


Cheers,
Bernd





