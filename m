From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Free allocated and pre-allocated blocks when check_eofblocks_fl
 fails
Date: Wed, 22 Jun 2011 10:28:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106221027090.4118@dhcp-27-109.brq.redhat.com>
References: <20110621032816.6A0A942247@ruihe.smo.corp.google.com> <alpine.LFD.2.00.1106211717100.21178@dhcp-27-109.brq.redhat.com> <BANLkTin00aSpUXVAjB6DWajB6Sf079y11MMh_X7WcO8JJz9TBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-725959581-1308731307=:4118"
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1FVI2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2011 04:28:30 -0400
In-Reply-To: <BANLkTin00aSpUXVAjB6DWajB6Sf079y11MMh_X7WcO8JJz9TBQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-725959581-1308731307=:4118
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 21 Jun 2011, Jiaying Zhang wrote:

> > >
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 5199bac..8cf6ec9 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -3596,10 +3596,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
> > >       }
> > >
> > >       err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
> > > -     if (err)
> > > -             goto out2;
> > > -
> > > -     err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> > > +     if (!err)
> > > +             err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> > >       if (err) {
> >
> > why not to use:
> >        else {
> >
> It is not the same. If there is an error from ext4_ext_insert_extent(),
> we also want to free allocated blocks.

Oh, of course I have missed the assignment, sorry.

Thanks!
-Lukas

> 
> Jiaying
> >
> > >               /* free data blocks we just allocated */
> > >               /* not a good idea to call discard here directly,
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> > Thanks!
> > -Lukas
> 
--8323328-725959581-1308731307=:4118--
