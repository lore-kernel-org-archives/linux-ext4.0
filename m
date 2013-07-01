From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
Date: Mon, 1 Jul 2013 14:17:03 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1307011415480.2542@localhost.localdomain>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com> <alpine.LFD.2.00.1306271123000.1781@localhost.localdomain> <20130701114043.GA23369@laptop.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-245445503-1372681026=:2542"
Cc: linux-ext4@vger.kernel.org
To: Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3GAMRG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jul 2013 08:17:06 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r61CH6X4009715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Jul 2013 08:17:06 -0400
In-Reply-To: <20130701114043.GA23369@laptop.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-245445503-1372681026=:2542
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 1 Jul 2013, Radek Pazdera wrote:

> Date: Mon, 1 Jul 2013 13:40:43 +0200
> From: Radek Pazdera <rpazdera@redhat.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
> 
> On Thu, Jun 27, 2013 at 11:24:19AM +0200, Lukáš Czerner wrote:
> >On Sat, 4 May 2013, Radek Pazdera wrote:
> >
> >> Date: Sat,  4 May 2013 23:28:33 +0200
> >> From: Radek Pazdera <rpazdera@redhat.com>
> >> To: linux-ext4@vger.kernel.org
> >> Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
> >>     Radek Pazdera <rpazdera@redhat.com>
> >> Subject: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
> >
> >Hi Radek,
> >
> >patches do not apply cleanly any more on the ext4 dev branch. Can
> >you rebase and resend the whole patch set ?
> 
> Hi Lukas,
> 
> I tried the patches with the dev branch of
> 
>     http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/
> 
> and they seem to apply cleanly. Is that the correct tree?
> 
> This thread contains the older version of the patches, the rebased
> version should be in the thread called:
> 
>     [RFC v2 0/9] ext4: An Auxiliary Tree for the Directory Index
>     http://comments.gmane.org/gmane.comp.file-systems.ext4/38697

Ah, that's my fault as I was trying to apply the older version of
the patch series. Sorry about that.

V2 applied and compiled cleanly on ext4 dev branch.

Thanks!
-Lukas

> 
> -Radek
> 
> >Thanks!
> >-Lukas
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-245445503-1372681026=:2542--
