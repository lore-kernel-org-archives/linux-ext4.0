From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] ext4: Fix memory leak when quota options are specified
 multiple times
Date: Mon, 21 Jan 2013 19:07:51 +0800
Message-ID: <50FD2187.30708@asianux.com>
References: <50FBC2D8.9070807@asianux.com> <20130121103138.GB5588@quack.suse.cz> <50FD1FA1.8060104@asianux.com> <20130121110524.GG5588@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:44278 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3AULHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 06:07:04 -0500
In-Reply-To: <20130121110524.GG5588@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 19:05, Jan Kara =E5=86=99=
=E9=81=93:
> On Mon 21-01-13 18:59:45, Chen Gang wrote:
>> =E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 18:31, Jan Kara =E5=86=
=99=E9=81=93:
>>>   The port looks good. You can add:
>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>
>>   does it mean:
>>     if the applier also think this patch is ok, he will add you as
>> Reviewed-by (it is also just what my willing) ?
>   Yes.
>=20
> 								Honza
>=20

  thank you.

  :-)

--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
