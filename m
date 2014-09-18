From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
 cleanup.
Date: Thu, 18 Sep 2014 11:44:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1409181139580.3870@localhost.localdomain>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org> <1410698337-27454-2-git-send-email-dmonakhov@openvz.org> <20140918042907.GD24887@thunk.org> <alpine.LFD.2.00.1409181048460.3870@localhost.localdomain> <87egv9tgw3.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-729025102-1411033260=:3870"
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbaIRJoy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 05:44:54 -0400
In-Reply-To: <87egv9tgw3.fsf@openvz.org>
Content-ID: <alpine.LFD.2.00.1409181142330.3870@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-729025102-1411033260=:3870
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1409181142331.3870@localhost.localdomain>

On Thu, 18 Sep 2014, Dmitry Monakhov wrote:

> Date: Thu, 18 Sep 2014 13:30:36 +0400
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> To: Luká¨ Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
>     cleanup.
> 
> On Thu, 18 Sep 2014 10:49:56 +0200 (CEST), Luká¨ Czerner <lczerner@redhat.com> wrote:
> > On Thu, 18 Sep 2014, Theodore Ts'o wrote:
> > 
> > > Date: Thu, 18 Sep 2014 00:29:07 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Dmitry Monakhov <dmonakhov@openvz.org>
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
> > >     cleanup.
> > > 
> > > On Sun, Sep 14, 2014 at 04:38:57PM +0400, Dmitry Monakhov wrote:
> > > > Production fs likely compiled/mounted w/o jbd debugging, so orphan list clearing
> > > > will be silent.
> > > > 
> > > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > 
> > > Thanks, applied.
> > 
> > Hmm did not we just take this out recently with
> > 
> > 566370a2e56837be98bc62d012fc2d2d11851db4 ext4: suppress ext4 orphan
> > messages on mount
> The message I want to change appears only if file system contains
> errors. So IMHO this is reasonable to make this message louder.
> This is important because after orphan list will be directly cleared
> later fsck will complain about incorrect dtime and corrupted orphan list.
> Sane administrator should investigate why this happen. So leaving
> precise message in /var/log/messages is good practice from our side.

Ah, yes. It's for the file system with errors so it is fine. I spoke too
soon, sorry about that.

Thanks!
-Lukas

> > 
> > and TBH I like it that way.
> > 
> > Thanks!
> > -Lukas
> > 
> > > 
> > > 					- Ted
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> 
--8323328-729025102-1411033260=:3870--
