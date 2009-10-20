From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Tue, 20 Oct 2009 17:52:43 +0200
Message-ID: <20091020155243.GA25760@duck.suse.cz>
References: <1256023478-746-1-git-send-email-jack@suse.cz> <1256023478-746-5-git-send-email-jack@suse.cz> <6601abe90910200736i78fa50b0jb4db9fed8800c805@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	chris.mason@oracle.com
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZJTPxo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 11:53:44 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90910200736i78fa50b0jb4db9fed8800c805@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-10-09 07:36:55, Curt Wohlgemuth wrote:
> On Tue, Oct 20, 2009 at 12:24 AM, Jan Kara <jack@suse.cz> wrote:
> > We cannot rely on buffer dirty bits during fsync because pdflush ca=
n come
> > before fsync is called and clear dirty bits without forcing a trans=
action
> > commit. What we do is that we track which transaction has last chan=
ged
> > the inode and which transaction last changed allocation and force i=
t to
> > disk on fsync.
<snip>
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 10539e3..3e167f6 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3315,6 +3315,11 @@ int ext4_ext_get_blocks(handle_t *handle, st=
ruct inode *inode,
> > =A0 =A0 =A0 =A0newblock =3D ext_pblock(&newex);
> > =A0 =A0 =A0 =A0allocated =3D ext4_ext_get_actual_len(&newex);
> > =A0 =A0 =A0 =A0set_buffer_new(bh_result);
> > +
> > + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_sync_tid, handle->h_tran=
saction->t_tid);
> > + =A0 =A0 =A0 atomic_set(&EXT4_I(inode)->i_datasync_tid,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle->h_transaction->t_tid);
> > + =A0 =A0 =A0 printk("Datasync tid %u\n", handle->h_transaction->t_=
tid);
>=20
> Both here and in ext4_ind_get_blocks() below, I think you need to
> guard the atomic_set() calls with ext4_handle_valid().
  Ah, good point. Will fix.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
