From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
Date: Wed, 16 Oct 2013 14:01:39 +0200
Message-ID: <20131016120139.GA14278@quack.suse.cz>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1310151919290.1921@localhost.localdomain>
 <CAGW2f1EaVQMQn37QPmzhMZiWUD=oqLTGoFQe=ZteHUUxpQbNCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3JPMBl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Oct 2013 08:01:41 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1EaVQMQn37QPmzhMZiWUD=oqLTGoFQe=ZteHUUxpQbNCw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-10-13 15:54:18, jon ernst wrote:
> On Tue, Oct 15, 2013 at 1:20 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@re=
dhat.com> wrote:
> > On Tue, 15 Oct 2013, Jan Kara wrote:
> >
> >> Date: Tue, 15 Oct 2013 15:32:28 +0200
> >> From: Jan Kara <jack@suse.cz>
> >> To: Ted Tso <tytso@mit.edu>
> >> Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
> >> Subject: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
> >>
> >> It doesn't make sense to require io_end->handle when we are in noj=
ournal
> >> mode. So update the assertion accordingly to avoid false warnings =
from
> >> ext4_add_complete_io().
> >
> > Looks good.
> >
> > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> >
> >>
> >> Reported-by: Eric Whitney <enwlinux@gmail.com>
> >> Signed-off-by: Jan Kara <jack@suse.cz>
> >> ---
> >>  fs/ext4/page-io.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> >> index d7d0c7b46ed4..d488f80ee32d 100644
> >> --- a/fs/ext4/page-io.c
> >> +++ b/fs/ext4/page-io.c
> >> @@ -197,14 +197,15 @@ static void dump_completed_IO(struct inode *=
inode, struct list_head *head)
> >>  static void ext4_add_complete_io(ext4_io_end_t *io_end)
> >>  {
> >>       struct ext4_inode_info *ei =3D EXT4_I(io_end->inode);
> >> +     struct ext4_sb_info *sbi =3D EXT4_SB(io_end->inode->i_sb);
> >>       struct workqueue_struct *wq;
> >>       unsigned long flags;
> >>
> >>       /* Only reserved conversions from writeback should enter her=
e */
> >>       WARN_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
> >> -     WARN_ON(!io_end->handle);
> >> +     WARN_ON(!io_end->handle && sbi->s_journal);
>=20
> swap 2 conditions would be better in my opinion.   (for no-journal
> case, it will be short-circuited. For journal case, no harm, no
> difference.)
> i know this is too picky. :)
  OTOH you will check sbi->s_journal unnecessarily for the more common
case when the journal is enabled. But I don't care tham much really.

								Honza

--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
