From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Wed, 26 Dec 2012 13:34:20 +0800
Message-ID: <50DA8C5C.9040200@asianux.com>
References: <50D7E815.6050503@asianux.com> <20121225184825.GD5318@thunk.org> <50DA6BC7.1000804@asianux.com> <20121226044532.GB16669@thunk.org> <50DA8641.1030004@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:8243 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2LZFd1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Dec 2012 00:33:27 -0500
In-Reply-To: <50DA8641.1030004@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  I prefer:
    define a macro in .h file and give comments with relative informati=
on.
    for function ext3_acl_size, use the macro instead of hard code numb=
er "4"
     (then not need to comment for the function ext3_acl_size)

gchen.

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8826=E6=97=A5 13:08, Chen Gang =E5=86=99=
=E9=81=93:
>> Ah, I see.  What's there is OK, but it's not at all obvious that it'=
s
>> > OK.  A valid acl must have a very specific order of tags, as enfor=
ced
>> > by posix_acl_valid() in fs/posix_acl.c:
>> >=20
>> > ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] =
ACL_OTHER=20
>> >=20
>> > [1] Where * is the regexp sense of "0 or more times"
>> > [2] Only if there is at least one ACL_USER or ACL_GROUP tag; other=
wise
>> > 	skip ACL_MASK.
>> >=20
>> > Hence, a valid acl can have at most 4 short acl entry types
>> > (ACL_USER_OBJ, ACL_GROUP, ACL_MASK, and ACL_OTHER), and if there i=
s
>> > less than 4 acl entries, they must all be short acl types.
>> >=20
>> > All I can say is, this is a horrible way of coding things, and I w=
ish
>> > this was documented explicitly somewhere either in fs/posix_acl.c =
or
>> > in include/linux/posix_acl.h.  Yuck, yuck, yuck....
>> >=20
>> > 						- Ted
>   learned.
>=20
>   :-)
>=20
>   also better to give a comment above the function ext3_acl_size.
>=20
>   thanks.


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
