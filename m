From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 13:36:32 +0200
Message-ID: <20110509113632.GJ4122@quack.suse.cz>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
 <BANLkTinv=c+mXvnirHtCzfuk0eK913dVtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1EILge (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 07:36:34 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinv=c+mXvnirHtCzfuk0eK913dVtQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-05-11 19:33:19, Yongqiang Yang wrote:
> On Mon, May 9, 2011 at 7:30 PM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 09-05-11 19:18:37, Yongqiang Yang wrote:
> >> On Mon, May 9, 2011 at 7:03 PM, Jan Kara <jack@suse.cz> wrote:
> >> > On Sat 07-05-11 16:54:27, Allison Henderson wrote:
> >> >> Fix for a null pointer bug found while running punch hole tests
> >> >>
> >> >> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> >> >> ---
> >> >> :100644 100644 3c7a06e... 3302a6c... M =A0 =A0 =A0 =A0fs/ext4/n=
amei.c
> >> >> =A0fs/ext4/namei.c | =A0 =A03 ++-
> >> >> =A01 files changed, 2 insertions(+), 1 deletions(-)
> >> >>
> >> >> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> >> >> index 3c7a06e..3302a6c 100644
> >> >> --- a/fs/ext4/namei.c
> >> >> +++ b/fs/ext4/namei.c
> >> >> @@ -1422,7 +1422,8 @@ static int make_indexed_dir(handle_t *han=
dle, struct dentry *dentry,
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(handle, dir);
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata(handle, =
dir, frame->bh);
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata(handle, di=
r, bh);
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (bh)
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_met=
adata(handle, dir, bh);
> >> > =A0I'm puzzled - bh here is bh2 from the beginning of the functi=
on and we
> >> > check it for being NULL after we ext4_append() it. So how can th=
is happen?
> >> do_split() encounters a journal error and set bh to NULL before re=
turning.
> > Ah, I see. But then you just reintroduced the bug I was trying to f=
ix. So
> > either do_split() has to do the marking of buffer dirty, or we have=
 to do
> > it before calllig do_split(), or do_split() has to be changed and n=
ot
> > release passed buffer (and the two callers have to do it - which th=
ey seem
> > to do anyway). I don't mind either way but your fix is wrong.
> The fix is made by Allison not me, I think Allison will have a look a=
t
> the thread.
  Right, sorry. I was addressing Allison, not you of course ;).

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
