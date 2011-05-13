From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 4/5] ext4 : Add missing posix_acl_release() in
 ext4_xattr_set_acl() in error path.
Date: Thu, 12 May 2011 19:19:29 -0700
Message-ID: <BANLkTimEOXs9yzws73kZ669YKLVhr6eAmw@mail.gmail.com>
References: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com> <20110511161808.GK5057@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, mkatiyar@gmail.com,
	"Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34504 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1EMCTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 22:19:50 -0400
Received: by qwk3 with SMTP id 3so1080878qwk.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 19:19:49 -0700 (PDT)
In-Reply-To: <20110511161808.GK5057@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 9:18 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 24-04-11 17:18:02, Manish Katiyar wrote:
>> This patch fixes the following.
>>
>> a) Incase journal transaction allocation fails due to ENOMEM don't c=
all
>> ext4_std_error() since it will remount the fs as readonly and logs t=
he
>> message in kernel log.
>> b) Call posix_acl_release() incase journal allocation fails in case =
of
>> error paths.
>>
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> ---
>> =A0fs/ext4/acl.c | =A0 =A07 ++++---
>> =A01 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
>> index 21eacd7..0c98710 100644
>> --- a/fs/ext4/acl.c
>> +++ b/fs/ext4/acl.c
>> @@ -354,7 +354,6 @@ ext4_acl_chmod(struct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DAT=
A_TRANS_BLOCKS(inode->i_sb));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_sb=
, error);
> =A0The changelog speaks only about ENOMEM but you actually remove the
> message completely (so it won't catch EIO or similar errors). I think=
 you
> should just condition ext4_std_error() with if (error !=3D ENOMEM).

Hi Jan,

Thanks for your response. Here is the updated patch.

-----------------------------------------------------------------------=
----------------------------------------------
a) Incase journal transaction allocation fails due to ENOMEM don't call
ext4_std_error() since it will remount the fs as readonly and logs the
message in kernel log.

b) Call posix_acl_release() incase journal allocation fails in case
of error paths.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 21eacd7..93dc9a6 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -354,7 +354,8 @@ ext4_acl_chmod(struct inode *inode)
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
+			if (error !=3D -ENOMEM)
+				ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error =3D ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -450,8 +451,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,

 retry:
 	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_=
sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		error =3D PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error =3D ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &ret=
ries))
--=20
1.7.4.1


--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
