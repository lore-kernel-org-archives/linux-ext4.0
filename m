From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Maximum number of directories
Date: Tue, 5 Feb 2013 15:43:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302051538270.3225@localhost>
References: <17001225.1MS6YREEfJ@deuteros> <3667261.Q2Z9h3nZ4l@deuteros> <alpine.LFD.2.00.1302051309320.3225@localhost> <2743619.5F0TAJAmZW@deuteros>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-164296617-1360075433=:3225"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Prashant Shah <pshah.mumbai@gmail.com>,
	linux-ext4@vger.kernel.org
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3BEOn7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2013 09:43:59 -0500
In-Reply-To: <2743619.5F0TAJAmZW@deuteros>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-164296617-1360075433=:3225
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 5 Feb 2013, Tvrtko Ursulin wrote:

> Date: Tue, 05 Feb 2013 14:30:24 +0000
> From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
> Subject: Re: Maximum number of directories
> 
> 
> Hi,
> 
> On Tuesday 05 February 2013 14:06:14 Lukáš Czerner wrote:
> > On Mon, 4 Feb 2013, Tvrtko Ursulin wrote:
> > > Date: Mon, 04 Feb 2013 13:36:29 +0000
> > > From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> > > To: Prashant Shah <pshah.mumbai@gmail.com>
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: Re: Maximum number of directories
> > > 
> > > On Monday 04 February 2013 18:49:54 Prashant Shah wrote:
> > > > Hi,
> > > > 
> > > > On Mon, Feb 4, 2013 at 4:25 PM, Tvrtko Ursulin
> > > > 
> > > > <tvrtko.ursulin@onelan.co.uk> wrote:
> > > > > I was creating such a (crazy?) tree and hit -ENOSPC at ~31 million
> > > > > directories created in total with df showing only 40% use:
> > > > > 
> > > > > Inode count:              29868032
> > > > > Free inodes:              29848131
> > > > 
> > > > Since, each directory will use a inode entry, there is some mismatch
> > > > with ~31 million directories and 19901 inodes in use. The inode usage
> > > > count should be much larger. You have max 29 million inodes available
> > > > - so max can be 29 million directories.
> > > 
> > > Yeah, I totally forgot about the inode situation on ext filesystems. So is
> > > tune2fs giving wrong stats for live (mounted) filesystems?
> > 
> > Not sure what situation you're referring to. Directory as any other
> > file is represented by an inode and there is a limited number of
> > inodes in the file system.
> 
> The situation that inode blocks are statically allocated at mkfs time.

Yes, that is true.

> 
> > Using tune2fs on live/mounted file system is bad idea and the
> > information might not be correct (exactly for this reason it is
> > _NOT_ recommended to run fsck on live file system). Use 'df -i' if
> > you want to get information about inode count.
> 
> Yes, later I figured out that tune2fs -l does not give current stats for live 
> filesystems. I did not expect that to be dangerous though. And I also forgot 
> about 'df -i'. Thing is, I did not hit this limit since the previous century 
> so guess I subconsciously assumed inode limits are an outdated concept. :) 

Running tune2fs -l on live file system is not dangerous, I did not
said that. Running fsck on live file system on the other hand _is_
dangerous.

-Lukas

>  
> Regards,
> 
> Tvrtko
> 
> 
--571107329-164296617-1360075433=:3225--
