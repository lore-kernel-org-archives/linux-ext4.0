From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out before using them.
Date: Mon, 26 Jan 2009 13:29:07 +0100
Message-ID: <20090126122907.GA18681@atrey.karlin.mff.cuni.cz>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com> <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZAZM3J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 07:29:09 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> > ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
> > where we access the b_size of it. Since it is a local variable it
> > might contain some garbage. Make sure it is filled with zero before
> > passing.
> 
> Hi Ted/mingming,
> 
> Any feedback on this ??
  Ops, sorry. I wanted to reply but first I wanted to research more
whether we can set b_size to 0 and then forgot about it. Looking into
other code (e.g. in fs/mpage.c or fs/buffer.c) I think it would be
better to set b_size to sb->s_blocksize and be done with that. Mapping
code does not need anything else set to a deterministic value so using
memset is a bit overkill.

								Honza

> > Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
> > ---
> >  fs/ext2/super.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index da8bdea..d10aa44 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -1327,7 +1327,7 @@ static ssize_t ext2_quota_read(struct
> > super_block *sb, int type, char *data,
> >                tocopy = sb->s_blocksize - offset < toread ?
> >                                sb->s_blocksize - offset : toread;
> >
> > -               tmp_bh.b_state = 0;
> > +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
> >                err = ext2_get_block(inode, blk, &tmp_bh, 0);
> >                if (err < 0)
> >                        return err;
> > @@ -1366,7 +1366,7 @@ static ssize_t ext2_quota_write(struct
> > super_block *sb, int type,
> >                tocopy = sb->s_blocksize - offset < towrite ?
> >                                sb->s_blocksize - offset : towrite;
> >
> > -               tmp_bh.b_state = 0;
> > +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
> >                err = ext2_get_block(inode, blk, &tmp_bh, 1);
> >                if (err < 0)
> >                        goto out;
> > --
> > 1.5.4.3
> >
> >
> > Thanks -
> > Manish
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
