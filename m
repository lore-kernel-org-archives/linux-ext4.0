From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 2/2] ext3: Add journal error check into ext3_rename()
Date: Tue, 23 Nov 2010 12:37:10 +0900
Message-ID: <1290483430.1857.43.camel@leonhard>
References: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
	 <1290151716-4041-2-git-send-email-namhyung@gmail.com>
	 <20101122180501.GE5012@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:40780 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KWDhQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 22:37:16 -0500
In-Reply-To: <20101122180501.GE5012@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-22 (=EC=9B=94), 19:05 +0100, Jan Kara:
>   Uhuh, why ext3_journal_revoke()? I expect you want to cancel the ch=
anges
> you possibly did to new_bh. ext3_journal_forget() is for that but eve=
n that
> doesn't necessarily do what you want because it could cancel also cha=
nges
> some unrelated operation did to the buffer. So the only way to really=
 undo
> the change is to set new_de->inode and new_de->file_type to original
> values. Also since we already unlinked the inode from the old directo=
ry,
> I'm not sure it's even beneficial to undo linking it to the new one. =
So I'd
> just bail out as fast as we can and leave on fsck to handle the mess.=
=2E.
>=20
> 								Honza

Right. I wanted cancel the changes but I wasn't sure what I did. Thanks
for the explanation. I'll send v2 soon.

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
