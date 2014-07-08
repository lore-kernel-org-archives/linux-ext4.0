From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: reopen the file system with saved flags after
 a journal replay
Date: Tue, 8 Jul 2014 14:49:55 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407081448530.2180@localhost.localdomain>
References: <1404616198-315-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1407080947580.2180@localhost.localdomain> <20140708115827.GB27440@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1348034113-1404823798=:2180"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	=?KOI8-R?B?4c7E0sXKIPfB08nMydvJzg==?= <a.vasilishin@kpi.ua>,
	Jon Severinsson <jon@severinsson.net>, 744953@bugs.debian.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaGHMu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 08:50:29 -0400
In-Reply-To: <20140708115827.GB27440@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1348034113-1404823798=:2180
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 8 Jul 2014, Theodore Ts'o wrote:

> Date: Tue, 8 Jul 2014 07:58:27 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
>     Андрей Василишин <a.vasilishin@kpi.ua>,
>     Jon Severinsson <jon@severinsson.net>, 744953@bugs.debian.org
> Subject: Re: [PATCH] e2fsck: reopen the file system with saved flags after a
>     journal replay
> 
> On Tue, Jul 08, 2014 at 11:03:53AM +0200, Lukáš Czerner wrote:
> > > +	ctx->openfs_flags = flags;
> > >  	retval = try_open_fs(ctx, flags, io_ptr, &fs);
> > 
> > Maybe we can get rid of 'flags' argument since it's not needed
> > anymore ?
> 
> Yeah, I thought of that, but I was trying to keep the patch small,
> since I thought this was one that distros might want to cherry pick.

Makes sense.

> 
> > Otherwise the patch looks good, however for some reason I can not
> > reproduce the problem in the big file system (without bigalloc) even
> > though looking at bitmap.c it looks like we really should get that
> > error.
> 
> Ah, yes, in the big file system case we don't hit it because we don't
> actually load the bitmaps before we close and reopen the file system
> again.  But in the bigalloc case, we check and fail at openfs time,
> which aborts the fsck run.
> 
> So we could work around this by moving the bigalloc check to when we
> open the file system, but you want get the other openfs flags right,
> especially the EXT2_FLAG_SKIP_MMP flags.

Yep, I agree with the fix, I was just wondering about the big fs
case. Anyway you can add:

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1348034113-1404823798=:2180--
