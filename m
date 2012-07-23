From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all
 dirty pages in punch hole
Date: Mon, 23 Jul 2012 21:18:01 +0800
Message-ID: <20120723131801.GA4254@gmail.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
 <1342943986-12413-10-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1207231249020.20857@localhost>
 <20120723115722.GA3363@gmail.com>
 <alpine.LFD.2.00.1207231354220.20857@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37160 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GWNJ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jul 2012 09:09:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207231354220.20857@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 23, 2012 at 02:20:57PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
[cut...]
> > > Moreover I think that we should avoid taking i_mutex if we can an=
d I
> > > believe that we can in this case, because we only need to prevent
> > > allocation. So I just want to let you know that this part is
> > > probably going to change anyway.
> >=20
> > It seems that we need to take i_mutex locking to prevent from buffe=
red
> > writes after page cache has been truncated by truncate_pagecache_ra=
nge.
> > If a buffered write without delalloc occurs after truncating page c=
ache
> > and before taking i_data_sem, that means that the allocated block f=
or
> > this buffered write will be removed in ext4_ext_remove_space when t=
he
> > offset is within the range of the hole.  Am I missing something?
>=20
> You're absolutely right, currently this is possible. But I think that=
 we
> can take i_data_sem before truncating the pagecache hence preventing =
anyone
> from mapping new blocks. However this is not yet implemented in my
> patch set.
>=20
> ...
> hmm, looking at the ext4_write_begin() it seems like it might not be
> such good idea after all. It seems to take page lock before
> i_data_sem so we might get deadlock, moreover if the punch hole
> happened in the middle of the ext4_write_begin() we might have only
> part of the data written, moreover this does not have to be hole
> aligned, which is bad. I need to revise that.

Yes, this is why I think that i_mutex locking should be taken.  At leas=
t
we are safty when we take the i_mutex. :-)

Regards,
Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
