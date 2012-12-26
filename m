From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Wed, 26 Dec 2012 11:15:19 +0800
Message-ID: <50DA6BC7.1000804@asianux.com>
References: <50D7E815.6050503@asianux.com> <20121225184825.GD5318@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:44426 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2LZDO1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Dec 2012 22:14:27 -0500
In-Reply-To: <20121225184825.GD5318@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8826=E6=97=A5 02:48, Theodore Ts'o =E5=86=
=99=E9=81=93:
> On Mon, Dec 24, 2012 at 01:28:53PM +0800, Chen Gang wrote:
>>
>>   better to use kzalloc instead of kmalloc.
>>     if acl_e->e_tag is neither ACL_USER, nor ACL_GROUP.
>>     entry->e_id will not be initialized
>>
>>   we can not say it is a bug, but suggest to initialize it, too.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>=20
> This shouldn't be a problem, since if e_tag is not ACL_USER nor
> ACL_GROUP, the on-disk encoding does not include e_id at all.
>=20

  ok, thanks.  it is my fault.

  :-)


> That being said, it looks to me there's another bug hiding here.  The
> size of the extended attribute is calculated by ext3_acl_size(), and
> it looks totally wrong.  For one thing, it caluclates the size of the
> xattr assuming all of the stored encoding ext3_acl_entry_short ---
> which would not be the case if we had a acl entry of type ACL_USER or
> ACL_GROUP.
>=20
> But if that were the case, it would mean that we would not be storing
> the full acl entry on disk, which would be a pretty horrible and
> obvious breakage.
>=20

  checking the ext3_acl_size, it does not like what you said above.
  but we can say, the design for ext3_acl_size is really not quit well.
    (maybe can cause issue).

 26 static inline size_t ext3_acl_size(int count)
 27 {
 28         if (count <=3D 4) {
 29                 return sizeof(ext3_acl_header) +
 30                        count * sizeof(ext3_acl_entry_short);
 31         } else {
 32                 return sizeof(ext3_acl_header) +
 33                        4 * sizeof(ext3_acl_entry_short) +
 34                        (count - 4) * sizeof(ext3_acl_entry);
 35         }
 36 }


> I haven't had time to check this yet, but I wanted to flag this so
> hopefully someone else should double check this.....  It would seem t=
o
> me that the better thing to do would be to calculate the size as part
> of the for loop in ext3_acl_to_disk(), and drop ext3_acl_size() from
> acl.h.  (This code exists in ext4 as well, so if we have a bug in
> ext3, we would have a similar bug in ext4.)
>=20

  at least, for my idea:
    your design for ext3_acl_size is a standard one.
    it is necessary to use your design instead of original design.

  if you also like me to provide the relative patch, please tell me.

  thanks.


gchen.

>=20
> 						- Ted
>=20
>=20



--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
