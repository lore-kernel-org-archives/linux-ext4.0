From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v3] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Tue, 08 Jan 2013 10:02:44 +0800
Message-ID: <50EB7E44.1040707@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com> <50E64A4E.7010408@asianux.com> <50E64BFD.6090000@asianux.com> <20130107192016.GD13659@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:6527 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3AHCBw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2013 21:01:52 -0500
In-Reply-To: <20130107192016.GD13659@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2013=E5=B9=B401=E6=9C=8808=E6=97=A5 03:20, Jan Kara =E5=86=99=
=E9=81=93:
> On Fri 04-01-13 11:26:53, Chen Gang wrote:
>> >=20
>> >   give comments (by Theodore Ts'o)
>> >=20
>> >     ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK=
[2] ACL_OTHER
>> >=20
>> >     [1] Where * is the regexp sense of "0 or more times"
>> >     [2] Only if there is at least one ACL_USER or ACL_GROUP tag;
>> >         otherwise skip ACL_MASK.
>   Note that I actually updated the entry [2] to be more precise in my
> suggested comment. I wrote:
> [2] If ACL_USER or ACL_GROUP is present, then ACL_MASK must be presen=
t.
>=20
>   Please use this formulation because the old version suggests ACL_MA=
SK
> cannot be present if neither ACL_USER nor ACL_GROUP are present and t=
hat's
> not true. Otherwise your patch looks fine. Thanks!

  according to the implementation of posix_acl_valid (contents at botto=
m).
    new comments are more precise to match the implementation.
    it means:
      if new comments was incorrect, the implementation would be incorr=
ect.
  welcome another members (especially Theodore Ts'o) to giving confirma=
tion or completion.=20

  I should wait 2 days, before send patch v4 with new comments.
    no additional reply within 2 days, means new comments is correct.


  Regards

gchen.


 76 int
 77 posix_acl_valid(const struct posix_acl *acl)
 78 {
 79         const struct posix_acl_entry *pa, *pe;
 80         int state =3D ACL_USER_OBJ;
 81         kuid_t prev_uid =3D INVALID_UID;
 82         kgid_t prev_gid =3D INVALID_GID;
 83         int needs_mask =3D 0;
 84=20
 85         FOREACH_ACL_ENTRY(pa, acl, pe) {
 86                 if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 87                         return -EINVAL;
 88                 switch (pa->e_tag) {
 89                         case ACL_USER_OBJ:
 90                                 if (state =3D=3D ACL_USER_OBJ) {
 91                                         state =3D ACL_USER;
 92                                         break;
 93                                 }
 94                                 return -EINVAL;
 95=20
 96                         case ACL_USER:
 97                                 if (state !=3D ACL_USER)
 98                                         return -EINVAL;
 99                                 if (!uid_valid(pa->e_uid))
100                                         return -EINVAL;
101                                 if (uid_valid(prev_uid) &&
102                                     uid_lte(pa->e_uid, prev_uid))
103                                         return -EINVAL;
104                                 prev_uid =3D pa->e_uid;
105                                 needs_mask =3D 1;
106                                 break;
107=20
108                         case ACL_GROUP_OBJ:
109                                 if (state =3D=3D ACL_USER) {
110                                         state =3D ACL_GROUP;
111                                         break;
112                                 }
113                                 return -EINVAL;
114=20
115                         case ACL_GROUP:
116                                 if (state !=3D ACL_GROUP)
117                                         return -EINVAL;
118                                 if (!gid_valid(pa->e_gid))
119                                         return -EINVAL;
120                                 if (gid_valid(prev_gid) &&
121                                     gid_lte(pa->e_gid, prev_gid))
122                                         return -EINVAL;
123                                 prev_gid =3D pa->e_gid;
124                                 needs_mask =3D 1;
125                                 break;
126=20
127                         case ACL_MASK:
128                                 if (state !=3D ACL_GROUP)
129                                         return -EINVAL;
130                                 state =3D ACL_OTHER;
131                                 break;
132=20
133                         case ACL_OTHER:
134                                 if (state =3D=3D ACL_OTHER ||
135                                     (state =3D=3D ACL_GROUP && !nee=
ds_mask)) {
136                                         state =3D 0;
137                                         break;
138                                 }
139                                 return -EINVAL;
140=20
141                         default:
142                                 return -EINVAL;
143                 }
144         }
145         if (state =3D=3D 0)
146                 return 0;
147         return -EINVAL;
148 }


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
