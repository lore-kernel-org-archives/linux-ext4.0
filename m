From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errorsx
Date: Wed, 30 Jul 2014 09:47:41 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407300946320.2071@localhost.localdomain>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com> <20140506174301.GQ8434@birch.djwong.org> <20140506192325.GB5012@thunk.org> <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain> <20140520094741.GG11499@pcnci.linuxbox.cz>
 <alpine.LFD.2.00.1405201150180.2162@localhost.localdomain> <20140729144903.GD2256@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-785089812-1406706465=:2071"
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaG3IEm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2014 04:04:42 -0400
In-Reply-To: <20140729144903.GD2256@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-785089812-1406706465=:2071
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 29 Jul 2014, Theodore Ts'o wrote:

> Date: Tue, 29 Jul 2014 10:49:03 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
>     Darrick J. Wong <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
>     errors
> 
> On Tue, May 20, 2014 at 11:56:53AM +0200, Lukáš Czerner wrote:
> > On Tue, 20 May 2014, Nikola Ciprich wrote:
> > 
> > > Date: Tue, 20 May 2014 11:47:41 +0200
> > > From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> > > To: Lukáš Czerner <lczerner@redhat.com>
> > > Cc: Theodore Ts'o <tytso@mit.edu>, Darrick J. Wong <darrick.wong@oracle.com>,
> > >     linux-ext4@vger.kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> > > Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
> > >     errors
> > > 
> > > Hello Lukáš,
> > > 
> > > just wanted to ask about the status of this patch.. it didn't make it
> > > to git yet, did it? Do you plan to make some changes to it? I'm eager
> > > to test it ;-)
> > 
> > No it did not and it would not given that there was not a merge
> > window since then. I've been distracted by other work, but I'll put
> > you in cc when I have a new patch - yes I plan to change the format
> > of the output to be more compliant with sysfs rules.
> 
> Hey Lukas,
> 
> I've been looking at old patches still in the ext4 patchwork queue,
> and I came across this.  Just a quick reminder you were planning on
> updating this patch at some point when you have time.
> 
> Cheers,

Right,

thanks a lot for the remainder it completely slipped out of my mind.
I'll take a look at it once again.

Thanks!
-Lukas

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-785089812-1406706465=:2071--
