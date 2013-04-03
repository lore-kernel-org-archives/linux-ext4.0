From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed, 03 Apr 2013 19:55:56 +0400
Message-ID: <87txnnpq0j.fsf@openvz.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org> <1364986711-3630-2-git-send-email-dmonakhov@openvz.org> <20130403153742.GA14991@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40198 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760802Ab3DCP4A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 11:56:00 -0400
Received: by mail-lb0-f181.google.com with SMTP id r11so1719104lbv.26
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 08:55:59 -0700 (PDT)
In-Reply-To: <20130403153742.GA14991@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013 11:37:42 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 03, 2013 at 02:58:31PM +0400, Dmitry Monakhov wrote:
> > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> > index 3a120b2..34da740 100644
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -123,16 +123,15 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
> >  {
> >  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >  	__u32 csum, old;
> > -
> > -	old = hdr->h_checksum;
> > +	__le64 dsk_block_nr = cpu_to_le64(block_nr);
> > +	old = le32_to_cpu(hdr->h_checksum);
> 
> We're just saving and restoring hdr->h_checksum.  So instead of
> byte-swapping the checksum in old, and then swapping it back, why not
> just do this instead:
> 
>      __le32 old;
> 
>      old = hdr->h_checksum;
>      ...
>      hdr->h_checksum = old;
yes. obviously that is correct.
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
