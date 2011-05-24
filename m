From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/5] ext4 : Update low level ext4 journal routines to
 specify gfp_mask for transaction allocation.
Date: Tue, 24 May 2011 01:08:44 -0700
Message-ID: <BANLkTimNK8RWxz7699EdUdbWxYJvjhmerQ@mail.gmail.com>
References: <BANLkTinfvAXWwjtMnYRBL5JHLmYJGhS-aQ@mail.gmail.com>
 <20110511160447.GJ5057@quack.suse.cz> <BANLkTimEpNq5L3p2UsByTMEYG2G2ORA0dw@mail.gmail.com>
 <20110523164123.GF4716@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57279 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab1EXIJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 04:09:05 -0400
Received: by qwk3 with SMTP id 3so3211175qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 01:09:04 -0700 (PDT)
In-Reply-To: <20110523164123.GF4716@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 9:41 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 21-05-11 19:43:10, Manish Katiyar wrote:
>> On Wed, May 11, 2011 at 9:04 AM, Jan Kara <jack@suse.cz> wrote:
>> > On Sun 24-04-11 17:13:18, Manish Katiyar wrote:
>> >> Update low level ext4 journal routines to pass an extra parameter
>> >> to journal allocation routines to specify whether transaction all=
ocation
>> >> can fail or not. With this patch ext4_journal_start() can fail du=
e to
>> >> ENOMEM. Added a new interface ext4_journal_start_tryhard() which =
isn't
>> >> supposed to fail and keep retrying till the allocation succeeds.
>> > =A0As I wrote in a comment in the comment to the first patch, firs=
t just
>> > make ext4_journal_start_sb() and similar functions pass false as a=
 part of
>> > the first patch.
>> >
>> > Then it would be better to create a new function that passes true =
- the
>> > name does not really matter since it will be removed later in the =
series
>> > but it will help the review process. You can call it
>> > ext4_journal_start_sb_enomem() or whatever. This way we keep backw=
ard
>> > compatibility because currently all call sites really expect the r=
etry
>> > behavior.
>>
>> Hi Jan,
>>
>> Here is the updated patch incorporating your comments. This adds a n=
ew
>> function ext4_journal_start_failok and updates the ext4 code where w=
e
>> can fail.
>>
>> This patch adds a new wrapper ext4_journal_start_failok() which
>> can fail with -ENOMEM. Update the ext4 code with this, where callers
>> are ok failing the transaction start.
> =A0Thanks. My comments are below.

Thanks a lot Jan,
Will send the updated patch based on your comments.

>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> ---
>> =A0fs/ext4/acl.c =A0 =A0 =A0 =A0 | =A0 =A06 +++---
>> =A0fs/ext4/ext4_jbd2.h =A0 | =A0 10 +++++++++-
>> =A0fs/ext4/extents.c =A0 =A0 | =A0 =A02 +-
>> =A0fs/ext4/inode.c =A0 =A0 =A0 | =A0 19 +++++++++++--------
>> =A0fs/ext4/ioctl.c =A0 =A0 =A0 | =A0 =A04 ++--
>> =A0fs/ext4/migrate.c =A0 =A0 | =A0 =A04 ++--
>> =A0fs/ext4/move_extent.c | =A0 =A02 +-
>> =A0fs/ext4/namei.c =A0 =A0 =A0 | =A0 23 +++++++++++++++--------
>> =A0fs/ext4/super.c =A0 =A0 =A0 | =A0 17 ++++++++++++++---
>> =A0fs/ext4/xattr.c =A0 =A0 =A0 | =A0 =A03 ++-
>> =A0fs/jbd2/transaction.c | =A0 =A04 +++-
>> =A011 files changed, 63 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
>> index 21eacd7..cdb1f51 100644
>> --- a/fs/ext4/acl.c
>> +++ b/fs/ext4/acl.c
>> @@ -350,11 +350,10 @@ ext4_acl_chmod(struct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int retries =3D 0;
>>
>> =A0 =A0 =A0 retry:
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start_failok(inode=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DAT=
A_TRANS_BLOCKS(inode->i_sb));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_sb=
, error);
> =A0Here, you should rather do
> if (error !=3D ENOMEM)
> =A0 =A0 =A0 =A0ext4_std_error(inode->i_sb, error);
> =A0We probably want to know about EIO (which is the other realistic e=
rror).

Ok.... will skip it only for -ENOMEM.

>
>> @@ -449,7 +448,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
>> char *name, const void *value,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;
>>
>> =A0retry:
>> - =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCK=
S(inode->i_sb));
>> + =A0 =A0 handle =3D ext4_journal_start_failok(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
>> =A0 =A0 =A0 error =3D ext4_set_acl(handle, inode, type, acl);
> =A0This change is OK. But looking at the code there, we should rather=
 do
> if (IS_ERR(handle)) {
> =A0 =A0 =A0 =A0error =3D PTR_ERR(handle);
> =A0 =A0 =A0 =A0goto release_and_out;
> }
> =A0Can you please include this change in your other patch fixing ACL =
error
> handling? Thanks.

I already had fixed this as part of the earlier ACL patch that I
posted, so didn't fix it here.

>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index f2fa5e8..f7b2d4d 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3523,7 +3523,7 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inode write */
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start_failok(inode=
, 2);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is really bad lu=
ck. We've written the data
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but cannot extend i=
_size. Bail out and pretend
> =A0Here we shouldn't fail because that will leave blocks outside EOF
> allocated. So just leave there original ext4_journal_start().

ohh okie... Actually for one of the similar patches earlier, you had
suggested that it can fail, so I followed the same. Will change it to
nofail version.

>
>> @@ -5371,7 +5372,9 @@ int ext4_setattr(struct dentry *dentry, struct
>> iattr *attr)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ext4_acl_chmod(inode);
>>
>> =A0err_out:
>> - =A0 =A0 ext4_std_error(inode->i_sb, error);
>> + =A0 =A0 if (error !=3D -ENOMEM) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_sb, error);
>> + =A0 =A0 }
> =A0No need for braces here...

ok.

>
>> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
>> index 92816b4..8870746 100644
>> --- a/fs/ext4/migrate.c
>> +++ b/fs/ext4/migrate.c
>> @@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
>> =A0 =A0 =A0 ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
>> =A0 =A0 =A0 up_read((&EXT4_I(inode)->i_data_sem));
>>
>> - =A0 =A0 handle =3D ext4_journal_start(inode, 1);
>> + =A0 =A0 handle =3D ext4_journal_start_failok(inode, 1);
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* It is impossible to update on-disk =
structures without
> =A0Here we should better not fail because we have inode on orphan lis=
t and
> need to eventually remove it. So just keep old ext4_journal_start().

ok.

>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 4e4c17f..2d57a57 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -247,7 +247,8 @@ static void ext4_put_nojournal(handle_t *handle)
>> =A0 * ext4 prevents a new handle from being started by s_frozen, whi=
ch
>> =A0 * is in an upper layer.
>> =A0 */
>> -handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks=
)
>> +static handle_t *ext4_journal_start_sb_int(struct super_block *sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0int nblocks, bool errok)
> =A0Maybe __ext4_journal_start_sb() would be a more usual name...
>
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index b5c2550..3453c29 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -308,6 +308,8 @@ static handle_t *new_handle(int nblocks)
>> =A0 * handle_t *jbd2_journal_start() - Obtain a new handle.
>> =A0 * @journal: Journal to start transaction on.
>> =A0 * @nblocks: number of block buffer we might modify
>> + * @errok : True if the transaction allocation can fail
>> + * =A0 =A0 =A0 =A0 =A0with ENOMEM.
>> =A0 *
>> =A0 * We make sure that the transaction can guarantee at least nbloc=
ks of
>> =A0 * modified buffers in the log. =A0We block until the log can gua=
rantee
> =A0Move this to the patch adding the parameter...

Will do.

>
>> @@ -338,7 +340,7 @@ handle_t *jbd2_journal_start(journal_t *journal,
>> int nblocks, bool errok)
>>
>> =A0 =A0 =A0 current->journal_info =3D handle;
>>
>> - =A0 =A0 err =3D start_this_handle(journal, handle, GFP_NOFS);
>> + =A0 =A0 err =3D start_this_handle(journal, handle, errok ? GFP_KER=
NEL : GFP_NOFS);
>> =A0 =A0 =A0 if (err < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_handle(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 current->journal_info =3D NULL;
> =A0This is probably just a leftover from some previous version?

Actually no. I added this as part of this patch. So do I actually
switch the gfp_mask in the last patch of the series ?

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
