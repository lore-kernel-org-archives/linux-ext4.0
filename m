From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/ext3: set pointer = NULL, after kfree it
Date: Wed, 26 Dec 2012 10:33:12 +0800
Message-ID: <50DA61E8.5090009@asianux.com>
References: <50D7EEF6.4070005@asianux.com> <20121225185155.GE5318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:52378 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2LZCcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Dec 2012 21:32:19 -0500
In-Reply-To: <20121225185155.GE5318@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8826=E6=97=A5 02:51, Theodore Ts'o =E5=86=
=99=E9=81=93:
> On Mon, Dec 24, 2012 at 01:58:14PM +0800, Chen Gang wrote:
>>
>>   set s->base =3D NULL, after kfree it.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>=20
> Was this to fix something flagged by some static code checker?  The
> only caller of ext3_xattr_block_set() is ext3_xattr_set_handle(), and
> s->base is stored on the stack, and as soon as ext3_xattr_block_set()
> returns, the object will disappear.  So it seems pretty hard to see
> how this could lead to a use-after-free bug.
>=20
>     	       	       	 		- Ted
>=20
>=20

  this patch is not for a bug

  it is only for coding habit:
    it is better to set is to NULL, after kfree it.
    in the future, if another functions need call ext3_xattr_block_set,=
 too.
      it will avoid another members to make mistake.

  since it is not for fixing bug, it is really a minor patch.
  I can understand if you do not apply it.

--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
