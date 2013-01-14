From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] fs/ext3: memory leak by calling set_qf_name or clear_qf_name,
 many times.
Date: Mon, 14 Jan 2013 10:29:16 +0800
Message-ID: <50F36D7C.2020107@asianux.com>
References: <50DA857B.1050808@asianux.com> <20121231120621.GD7564@quack.suse.cz> <50E66B19.5060907@asianux.com> <20130107195425.GE13659@quack.suse.cz> <50EB8EDA.3020709@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:54274 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3ANC2e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 21:28:34 -0500
In-Reply-To: <50EB8EDA.3020709@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2013=E5=B9=B401=E6=9C=8808=E6=97=A5 11:13, Chen Gang =E5=86=99=
=E9=81=93:
> =E4=BA=8E 2013=E5=B9=B401=E6=9C=8808=E6=97=A5 03:54, Jan Kara =E5=86=99=
=E9=81=93:
>> > On Fri 04-01-13 13:39:37, Chen Gang wrote:
>>> >>   if what I guess is true
>>> >>     it seems we have to duplicate memory for old_opts in ext3_re=
mount.
>>> >>     and for clear_qf_name, set_qf_name, ext3_remount:
>>> >>       use normal memory allocation and free ways instead of curr=
ent using.
>> >   Yes. Updated patch attached.
>> >=20
>   at least for me, Jan Kara's patch is ok. thanks.
>=20
>   welcome another members (especially Theodore Ts'o) to giving confir=
mation or completion.
>   also welcome to checking this suggestion whether valid for fs/ext4.

  I will send a relative patch for fs/ext4, just according to Jan Kara'=
s patch.
  I will send it within 2 weeks (excuse me, I have to do another things=
 this week).

  welcome any additional suggestions and completions.

  thanks.

--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
