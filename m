From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 05/30] ext4: snapshot hooks - delete blocks
Date: Tue, 7 Jun 2011 15:32:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071530550.11385@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <1304959308-11122-6-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106071306510.4754@dhcp-27-109.brq.redhat.com>
 <BANLkTinKD5aQQfhVAdFc9UbpJTjvhnW-3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-250306918-1307453554=:11385"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1FGNct (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 09:32:49 -0400
In-Reply-To: <BANLkTinKD5aQQfhVAdFc9UbpJTjvhnW-3A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-250306918-1307453554=:11385
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jun 2011, Amir G. wrote:

> >> @@ -4543,6 +4544,29 @@ do_more:
> >>               goto error_return;
> >>       }
> >>
> >> +     maxblocks = count;
> >> +     ret = ext4_snapshot_get_delete_access(handle, inode,
> >> +                                           block, &maxblocks);
> >
> > It would be nice to have this defined in the same commit, so I know what
> > is it doing.
> 
> Sorry, full patches again :-/
> I will post them soon without any fixes, so you can have a look.
> 

No problem, I'll wait for the full patches before proceeding. Fix
whatever you to and repost.

Thanks!
-Lukas
--8323328-250306918-1307453554=:11385--
