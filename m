From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] Free allocated and pre-allocated blocks when
 check_eofblocks_fl fails
Date: Tue, 21 Jun 2011 12:40:04 -0700
Message-ID: <BANLkTin00aSpUXVAjB6DWajB6Sf079y11MMh_X7WcO8JJz9TBQ@mail.gmail.com>
References: <20110621032816.6A0A942247@ruihe.smo.corp.google.com>
	<alpine.LFD.2.00.1106211717100.21178@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61618 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab1FUTkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 15:40:08 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p5LJe6eU029799
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 12:40:06 -0700
Received: from gyc15 (gyc15.prod.google.com [10.243.49.143])
	by kpbe20.cbf.corp.google.com with ESMTP id p5LJdJ6A005956
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 12:40:05 -0700
Received: by gyc15 with SMTP id 15so50270gyc.38
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 12:40:05 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106211717100.21178@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 8:24 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
>
> On Mon, 20 Jun 2011, Jiaying Zhang wrote:
>
> > We have hit the same BUG_ON as described in
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D31222
> > on some of our servers that have disk failures or corrupted inodes.=
 After
> > looking at the code, I think the problem is that we are not freeing=
 inode's
> > preallocation list when check_eofblocks_fl fails in ext4_ext_map_bl=
ocks(),
> > which leaves the inode's preallocation list in an inconsistent stat=
e.
> >
> > Below is a proposed patch to fix the bug. I have tested it by manua=
lly
> > inserting a random failure in check_eofblocks_fl() and run a test t=
hat
> > creates and uses an inode's preallocated blocks. Without the fix, t=
he kernel
> > crashes after a few runs. With the fix, no crash is observed.
> >
> > ext4: free allocated and pre-allocated blocks when check_eofblocks_=
fl fails
> >
> > Upon corrupted inode or disk failures, we may fail after we already=
 allocate
> > some blocks from the inode or take some blocks from the inode's pre=
allocation
> > list, but before we successfully insert the corresponding extent to=
 the extent
> > tree. In this case, we should free any allocated blocks and discard=
 the inode's
> > preallocated blocks because the entries in the inode's preallocatio=
n list may
> > be in an inconsistent state.
> >
> > Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>
> Hi,
>
> the change looks good to me (with one note), but the patch itself is =
not very
> well formated, and Ted would have to copy it out. Please use this:
>
> ext4: free allocated and pre-allocated blocks when check_eofblocks_fl=
 fails
>
> for Subject line and put any comments which should not appear in the
> commit description after signed-off-by line starting with "--- " line=
=2E
> Or just use git format-patch.
Thanks for the suggestion. I will re-send the patch with correct format=
=2E

>
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 5199bac..8cf6ec9 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3596,10 +3596,8 @@ int ext4_ext_map_blocks(handle_t *handle, st=
ruct inode *inode,
> > =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 err =3D check_eofblocks_fl(handle, inode, map->m_lblk, =
path, ar.len);
> > - =A0 =A0 if (err)
> > - =A0 =A0 =A0 =A0 =A0 =A0 goto out2;
> > -
> > - =A0 =A0 err =3D ext4_ext_insert_extent(handle, inode, path, &newe=
x, flags);
> > + =A0 =A0 if (!err)
> > + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_insert_extent(handle, in=
ode, path, &newex, flags);
> > =A0 =A0 =A0 if (err) {
>
> why not to use:
> =A0 =A0 =A0 =A0else {
>
It is not the same. If there is an error from ext4_ext_insert_extent(),
we also want to free allocated blocks.

Jiaying
>
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* free data blocks we just allocated *=
/
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* not a good idea to call discard here=
 directly,
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>
> Thanks!
> -Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
