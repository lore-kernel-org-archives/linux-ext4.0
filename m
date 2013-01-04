From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] fs/ext3: memory leak by calling set_qf_name or clear_qf_name,
 many times.
Date: Fri, 04 Jan 2013 13:39:37 +0800
Message-ID: <50E66B19.5060907@asianux.com>
References: <50DA857B.1050808@asianux.com> <20121231120621.GD7564@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:12710 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3ADFiq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 00:38:46 -0500
In-Reply-To: <20121231120621.GD7564@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8831=E6=97=A5 20:06, Jan Kara =E5=86=99=
=E9=81=93:
>   Thanks for report. Yes, memory leak seems to be possible. Attached =
patch
> should fix it, I have added it to my tree.
>=20
> 									Honza
>=20

  after read your patch, today (although I am not a reviewer).
  is it a possible situation like this (just my imagination):
    1st let it call clear_qf_name successfully.
    2nd let it call set_qf_name successfully.
    3rd call clear_qf_name again ?
    ...
  if this situation is possible.
    I guess the memory still leak, after apply your patch.

  if what I guess is true
    it seems we have to duplicate memory for old_opts in ext3_remount.
    and for clear_qf_name, set_qf_name, ext3_remount:
      use normal memory allocation and free ways instead of current usi=
ng.

  Regards

--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
