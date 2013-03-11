From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Mon, 11 Mar 2013 15:18:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303111513030.24359@localhost>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost> <5138EEBD.5000705@wwwdotorg.org> <alpine.LFD.2.00.1303080818510.24359@localhost> <513A1D56.1010402@wwwdotorg.org> <20130308190019.GB12008@thunk.org>
 <513DE554.6020508@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-524109930-1363011522=:24359"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Stephen Warren <swarren@wwwdotorg.org>,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab3CKOSp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 10:18:45 -0400
In-Reply-To: <513DE554.6020508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-524109930-1363011522=:24359
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Mon, 11 Mar 2013, Eric Sandeen wrote:

> Date: Mon, 11 Mar 2013 09:08:20 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Stephen Warren <swarren@wwwdotorg.org>,
>     Lukáš Czerner <lczerner@redhat.com>, Chris Ball <cjb@laptop.org>,
>     linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
> Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
> 
> On 3/8/13 1:00 PM, Theodore Ts'o wrote:
> > I hate to suggest this, but there's so many crappy devices out there
> > that I'm wondering if we need to figure out some way of maintaining a
> > black list of devices that don't handle discard properly.  For
> > example, the Sandisk U100 advertises a max discard granularity of 512
> > bytes, but I've been advised that if you don't use a discard
> > granularity of 256k, aligned on 256k, you'll be very, very, sorry.
> 
> > It sounds like Stephen's device is probably an example of Yet Another
> > Busted Trim implementation.  The problem is that manufacturers will be
> > releasing more broken products faster than we can update a blacklist
> > in the kernel.  So any blacklist would have to be maintained online on
> > the web, and dynamically updated by distro installers.   :-(
> 
> Yeah I think it may be time for a blacklist.
> 
> TBH I think we should revisit discard-at-mkfs-time by default as well.
> 
> It seemed like a decent idea at the time, but now we have handy
> fstrim as well as online/dynamic/realtime trim, and trim at mkfs
> makes mke2fs completely un-doable in the event of fat fingers.

However that will make things even worse when someone uses it on
such device, than simply realising the problem on mkfs time. Sure,
there are buggy or crappy devices out there, but that's not we want
to optimize for right ?

Regarding the 'fat fingers' point I am starting to thing that
refusing to create the file system if we found any old signature
(like xfs does) would really be a good thing to have. In order not
to break scripts we can fall back to the old behaviour if we find
out that there is not any interactive input attached (we're running
from the script).

-Lukas

> 
> -Eric
> 
> 
> > 
> >     	     		 	    	   		 - Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
--571107329-524109930-1363011522=:24359--
