From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Wed, 26 Dec 2012 13:08:17 +0800
Message-ID: <50DA8641.1030004@asianux.com>
References: <50D7E815.6050503@asianux.com> <20121225184825.GD5318@thunk.org> <50DA6BC7.1000804@asianux.com> <20121226044532.GB16669@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:19400 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2LZFHY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Dec 2012 00:07:24 -0500
In-Reply-To: <20121226044532.GB16669@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8826=E6=97=A5 12:45, Theodore Ts'o =E5=86=
=99=E9=81=93:
> On Wed, Dec 26, 2012 at 11:15:19AM +0800, Chen Gang wrote:
>>
>>   checking the ext3_acl_size, it does not like what you said above.
>>   but we can say, the design for ext3_acl_size is really not quit we=
ll.
>>     (maybe can cause issue).
>=20
> Ah, I see.  What's there is OK, but it's not at all obvious that it's
> OK.  A valid acl must have a very specific order of tags, as enforced
> by posix_acl_valid() in fs/posix_acl.c:
>=20
> ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL=
_OTHER=20
>=20
> [1] Where * is the regexp sense of "0 or more times"
> [2] Only if there is at least one ACL_USER or ACL_GROUP tag; otherwis=
e
> 	skip ACL_MASK.
>=20
> Hence, a valid acl can have at most 4 short acl entry types
> (ACL_USER_OBJ, ACL_GROUP, ACL_MASK, and ACL_OTHER), and if there is
> less than 4 acl entries, they must all be short acl types.
>=20
> All I can say is, this is a horrible way of coding things, and I wish
> this was documented explicitly somewhere either in fs/posix_acl.c or
> in include/linux/posix_acl.h.  Yuck, yuck, yuck....
>=20
> 						- Ted

  learned.

  :-)

  also better to give a comment above the function ext3_acl_size.

  thanks.

--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
