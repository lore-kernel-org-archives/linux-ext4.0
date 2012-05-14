From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH] ext2: cleanup the comment for ext2_export_ops
Date: Tue, 15 May 2012 07:56:06 +0800
Message-ID: <4FB19B96.4010106@gmail.com>
References: <4FB0B0F4.3060908@gmail.com> <20120514095525.GD5353@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44945 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2ENX42 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 19:56:28 -0400
In-Reply-To: <20120514095525.GD5353@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B405=E6=9C=8814=E6=97=A5 17:55, Jan Kara wrote:
> On Mon 14-05-12 15:15:00, Wang Sheng-Hui wrote:
>> ext2_export_ops gets more valued fields, not get_parent only.
>> Clean up the comment.
>   Um, I'd just remove the whole comment. It isn't particularly inform=
ative
> anyway - NULL meaning the default behavior is very common in kernel. =
And we
> really set about half of entries anyway...
>=20
> 								Honza

Thanks, Honza.

Patch regenerated. Please check it.

>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/ext2/super.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
>> index e1025c7..640b4c6 100644
>> --- a/fs/ext2/super.c
>> +++ b/fs/ext2/super.c
>> @@ -359,7 +359,6 @@ static struct dentry *ext2_fh_to_parent(struct s=
uper_block *sb, struct fid *fid,
>>  /* Yes, most of these are left as NULL!!
>>   * A NULL value implies the default, which works with ext2-like fil=
e
>>   * systems, but can be improved upon.
>> - * Currently only get_parent is required.
>>   */
>>  static const struct export_operations ext2_export_ops =3D {
>>  	.fh_to_dentry =3D ext2_fh_to_dentry,
>> --=20
>> 1.7.1

=46rom 362925f80bdfb1c105e346f535c5e51c7359b550 Mon Sep 17 00:00:00 200=
1
=46rom: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Tue, 15 May 2012 07:53:46 +0800
Subject: [PATCH] ext2: remove the redundant comment for ext2_export_ops

Per Honza, It isn't particularly informative anyway - NULL
meaning the default behavior is very common in kernel. And we
really set about half of entries anyway.

Remove the whole comment for ext2_export_ops.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext2/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e1025c7..f9b0f41 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -356,11 +356,6 @@ static struct dentry *ext2_fh_to_parent(struct sup=
er_block *sb, struct fid *fid,
 				    ext2_nfs_get_inode);
 }
=20
-/* Yes, most of these are left as NULL!!
- * A NULL value implies the default, which works with ext2-like file
- * systems, but can be improved upon.
- * Currently only get_parent is required.
- */
 static const struct export_operations ext2_export_ops =3D {
 	.fh_to_dentry =3D ext2_fh_to_dentry,
 	.fh_to_parent =3D ext2_fh_to_parent,
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
