From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out
	before using them.
Date: Mon, 26 Jan 2009 14:00:16 +0100
Message-ID: <20090126130016.GC2726@duck.suse.cz>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com> <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com> <20090126122907.GA18681@atrey.karlin.mff.cuni.cz> <ea11fea30901260433i6d06ea49v8524c46ad373733f@mail.gmail.com> <ea11fea30901260448v564b424byc9e4d1bbb289d1d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37131 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750926AbZAZNAT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2009 08:00:19 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30901260448v564b424byc9e4d1bbb289d1d8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-01-09 18:18:19, Manish Katiyar wrote:
> On Mon, Jan 26, 2009 at 6:03 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> > On Mon, Jan 26, 2009 at 5:59 PM, Jan Kara <jack@suse.cz> wrote:
> >>> On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> >>> > ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
> >>> > where we access the b_size of it. Since it is a local variable it
> >>> > might contain some garbage. Make sure it is filled with zero before
> >>> > passing.
> >>>
> >>> Hi Ted/mingming,
> >>>
> >>> Any feedback on this ??
> >>  Ops, sorry. I wanted to reply but first I wanted to research more
> >> whether we can set b_size to 0 and then forgot about it. Looking into
> >> other code (e.g. in fs/mpage.c or fs/buffer.c) I think it would be
> >> better to set b_size to sb->s_blocksize and be done with that. Mapping
> >> code does not need anything else set to a deterministic value so using
> >> memset is a bit overkill.
> >
> > Thanks Jan for your comments. Yes memset is an overkill. I did it just
> > because other users of ext2_get_block were doing the same way. Will
> > rework the patch with setting b_size as blocksize and send again.
> 
> Here is the updated patch. compile tested.
> 
> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
  Yes, now it looks fine. Thanks for the fix.

  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/ext2/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index da8bdea..2a1c0c6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1328,6 +1328,7 @@ static ssize_t ext2_quota_read(struct
> super_block *sb, int type, char *data,
>  				sb->s_blocksize - offset : toread;
> 
>  		tmp_bh.b_state = 0;
> +		tmp_bh.b_size = sb->s_blocksize;
>  		err = ext2_get_block(inode, blk, &tmp_bh, 0);
>  		if (err < 0)
>  			return err;
> @@ -1367,6 +1368,7 @@ static ssize_t ext2_quota_write(struct
> super_block *sb, int type,
>  				sb->s_blocksize - offset : towrite;
> 
>  		tmp_bh.b_state = 0;
> +		tmp_bh.b_size = sb->s_blocksize;
>  		err = ext2_get_block(inode, blk, &tmp_bh, 1);
>  		if (err < 0)
>  			goto out;
> -- 
> 1.5.4.3
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
