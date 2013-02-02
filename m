From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v4] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Sat, 02 Feb 2013 13:10:48 +0800
Message-ID: <510C9FD8.1040601@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com> <50E64A4E.7010408@asianux.com> <50E64BFD.6090000@asianux.com> <20130107192016.GD13659@quack.suse.cz> <50EFD427.8060100@asianux.com> <50FB9696.7090702@asianux.com> <20130121102428.GA5588@quack.suse.cz> <50FD1B22.1020906@asianux.com> <51078725.9000802@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, paul.gortmaker@windriver.com,
	ebiederm@xmission.com, adilger.kernel@dilger.ca,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:2891 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3BBFK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2013 00:10:56 -0500
In-Reply-To: <51078725.9000802@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Al Viro:


  could you give a glance for this comment patch when you have time ?
    I am so sorry for not including your mail address for this patch, o=
riginally
      (it is really my fault, although the comment patch itself is inno=
cence)

    I should notice next time.
      (and now, I always use ./script/get_maintainers.pl to get mail ad=
dress)


  maybe, the comment patch seems quite minor.
    but at least for me, I think most of comment patches are not minor.
      (in correct place, providing correct comments are not minor)

    I also plan to provide more comment patches, in 2nd half of this ye=
ar.
      (if it seems not a good idea, please tell me, thanks)

    if you have another opinions, welcome to discussion.


  whether this patch will be applied or not, I still thank to relative =
members:
    Theodore Ts'o: always give helpful responses at key point time.
                     (not only for this patch).

    Jan Kara:      provide more useful informations in action.
                     (not only for this patch).


  thanks.

gchen.

=E4=BA=8E 2013=E5=B9=B401=E6=9C=8829=E6=97=A5 16:24, Chen Gang =E5=86=99=
=E9=81=93:
> Hello Al Viro:
>=20
>   could you give a glance for this comment patch when you have time ?
>=20
>     (at least for me, most of comment patches are valuable for integr=
ating)
>=20
>=20
>   thanks.
>=20
> gchen.


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
