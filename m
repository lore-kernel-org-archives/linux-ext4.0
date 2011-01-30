From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation if
 caller can handler failures
Date: Sat, 29 Jan 2011 21:29:37 -0800
Message-ID: <AANLkTimMZfSBx-c_O_N2HNVHSsZObFmFLo2peFB_d_Fy@mail.gmail.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com> <20110125161745.GC4088@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, mkatiyar@gmail.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35371 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1A3F37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 00:29:59 -0500
Received: by qwa26 with SMTP id 26so4502211qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 21:29:59 -0800 (PST)
In-Reply-To: <20110125161745.GC4088@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Below is the updated patch based on your feedback.

On Tue, Jan 25, 2011 at 8:17 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> On Sat 22-01-11 19:34:55, Manish Katiyar wrote:
>> Pass GFP_KERNEL for transaction allocation for ext4 routines if call=
er
>> can handler failures
> =A0Some error recovery paths will need cleaning up before you actuall=
y start
> using them - see below:
>
>> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
>> index e0270d1..1a4a944 100644
>> --- a/fs/ext4/acl.c
>> +++ b/fs/ext4/acl.c
>> @@ -351,7 +351,7 @@ ext4_acl_chmod(struct inode *inode)
>>
>> =A0 =A0 =A0 retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DATA_=
TRANS_BLOCKS(inode->i_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_DATA_=
TRANS_BLOCKS(inode->i_sb), true);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_=
sb, error);
> =A0We shouldn't call ext4_std_error() (that possibly logs the message=
 in
> the kernel log and remounts the fs read-only, panics the kernel or so=
) in
> case of ENOMEM...
>
>> @@ -449,7 +449,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
>> char *name, const void *value,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 acl =3D NULL;
>>
>> =A0retry:
>> - =A0 =A0 handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCK=
S(inode->i_sb));
>> + =A0 =A0 handle =3D ext4_journal_start(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_DATA_TRANS_BLOCKS(inode->i_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> =A0It's actually not your bug, but the above should be:
> =A0error =3D PTR_ERR(handle);
> =A0goto release_and_out;
>
>> =A0 =A0 =A0 error =3D ext4_set_acl(handle, inode, type, acl);
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index eb9097a..e0e27a3 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -1257,7 +1257,7 @@ extern int ext4_init_inode_table(struct
>> super_block *sb, ext4_group_t group,
>> =A0 =A0 =A0 if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> - =A0 =A0 handle =3D ext4_journal_start_sb(sb, 1);
>> + =A0 =A0 handle =3D ext4_journal_start_sb(sb, 1, true);
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0Well, this might be disputable. This function is used to lazily
> initialize inode table. =A0If the initialization fails, thread remove=
s the
> request for initialization from the queue. But in case of ENOMEM, it =
might
> be more suitable to just postpone the initialization work to a more
> suitable time...

I have converted it back to pass false. Will send a separate patch late=
r.

>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9f7f9e4..76c20b8 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> ...
>> @@ -1398,7 +1398,7 @@ static int _ext4_get_block(struct inode *inode=
,
>> sector_t iblock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map.m_len > DIO_MAX_BLOCKS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_len =3D DIO_MAX_BL=
OCKS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dio_credits =3D ext4_chunk_trans_blocks(=
inode, map.m_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, dio_c=
redits);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, dio_c=
redits, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> =A0Hmm, this would be actually another useful prerequisite cleanup of=
 this
> series. _ext4_get_block() should need to start a transaction only whe=
n
> called from direct IO path (otherwise transaction should be already s=
tarted
> when creating blocks). But this is only implicit so it would be good =
to
> create ext4_get_block_directIO() which would start a transaction, use=
 it
> as a callback of __blockdev_direct_IO(), and remove the code from sta=
ndard
> _ext4_get_block() function. Then you can also make ext4_journal_start=
()
> possibly fail and still it will be clear you do not introduce any pot=
ential
> problems.
>
>> @@ -1621,7 +1621,7 @@ static int ext4_write_begin(struct file *file,
>> struct address_space *mapping,
>> =A0 =A0 =A0 to =3D from + len;
>>
>> =A0retry:
>> - =A0 =A0 handle =3D ext4_journal_start(inode, needed_blocks);
>> + =A0 =A0 handle =3D ext4_journal_start(inode, needed_blocks, false)=
;
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0Failing this with ENOMEM is OK. Note that grab_cache_page_write_be=
gin()
> called just below can fail with ENOMEM as well.

Using the same reasoning, I also changed ext4_da_write_begin().

>
>> @@ -3553,7 +3554,7 @@ static ssize_t ext4_ind_direct_IO(int rw, stru=
ct
>> kiocb *iocb,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (final_size > inode->i_size) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inod=
e write */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_st=
art(inode, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_st=
art(inode, 2, false);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D =
PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
> =A0This can fail without introducing problems. It's standard directIO=
 write
> path.
>
>> @@ -3596,7 +3597,7 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Credits for sb + inode write */
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 2, fa=
lse);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This is really bad lu=
ck. We've written the data
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but cannot extend i=
_size. Bail out and pretend
> =A0This one can fail just fine as well.
>
>> @@ -5329,8 +5330,10 @@ int ext4_setattr(struct dentry *dentry, struc=
t
>> iattr *attr)
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* (user+group)*(old+new) structure, ino=
de write (sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* inode block, ? - but truncate inode=
 update has it) */
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, (EXT4=
_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 true);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> @@ -5365,7 +5368,7 @@ int ext4_setattr(struct dentry *dentry, struct
>> iattr *attr)
>> =A0 =A0 =A0 =A0 =A0 =A0(ext4_test_inode_flag(inode, EXT4_INODE_EOFBL=
OCKS)))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_t *handle;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 3);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 3, tr=
ue);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
> =A0The above two sites are fine but note that err_out calls ext4_std_=
error()
> which we don't want to happen in case of ENOMEM.
>
>> @@ -5822,7 +5825,7 @@ int ext4_change_inode_journal_flag(struct inod=
e
>> *inode, int val)
>>
>> =A0 =A0 =A0 /* Finally we can mark the inode as dirty. */
>>
>> - =A0 =A0 handle =3D ext4_journal_start(inode, 1);
>> + =A0 =A0 handle =3D ext4_journal_start(inode, 1, true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> =A0This can fail OK, but you should undo inode flag and aops change b=
efore
> returning error (that would be probably better as a separate preparat=
ory
> patch because it won't be completely trivial - you need to lock the u=
pdates
> again etc. possibly create a helper function for that so that you don=
't
> duplicate the code).

Changed back to pass false. Will do the cleanup and error handling as
part of separate patch once I start understanding the code better.



=46or ext4 functions which can handle transaction allocation failures,
pass GFP_KERNEL flag for transaction allocation dring journal start.
Otherwise GFP_NOFS is passed which retries in a loop till allocation
succeeds.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/acl.c         |   12 +++++++-----
 fs/ext4/ext4_jbd2.h   |    9 +++++----
 fs/ext4/extents.c     |    8 ++++----
 fs/ext4/ialloc.c      |    2 +-
 fs/ext4/inode.c       |   37 +++++++++++++++++++++----------------
 fs/ext4/ioctl.c       |    4 ++--
 fs/ext4/migrate.c     |    4 ++--
 fs/ext4/move_extent.c |    2 +-
 fs/ext4/namei.c       |   24 +++++++++++++++---------
 fs/ext4/resize.c      |    8 ++++----
 fs/ext4/super.c       |   13 +++++++------
 fs/ext4/xattr.c       |    3 ++-
 12 files changed, 71 insertions(+), 55 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index e0270d1..0f7aac2 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -351,10 +351,9 @@ ext4_acl_chmod(struct inode *inode)

 	retry:
 		handle =3D ext4_journal_start(inode,
-				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
-			ext4_std_error(inode->i_sb, error);
 			goto out;
 		}
 		error =3D ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
@@ -449,9 +448,12 @@ ext4_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,
 		acl =3D NULL;

 retry:
-	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_=
sb));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	handle =3D ext4_journal_start(inode,
+			            EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
+	if (IS_ERR(handle)) {
+		error =3D PTR_ERR(handle);
+		goto release_and_out;
+	}
 	error =3D ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
 	if (error =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &ret=
ries))
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d8b992e..38f128e 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -161,7 +161,7 @@ int __ext4_handle_dirty_super(const char *where,
unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))

-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks,
bool errok);
 int __ext4_journal_stop(const char *where, unsigned int line,
handle_t *handle);

 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
@@ -209,9 +209,10 @@ static inline void
ext4_journal_release_buffer(handle_t *handle,
 		jbd2_journal_release_buffer(handle, bh);
 }

-static inline handle_t *ext4_journal_start(struct inode *inode, int nb=
locks)
+static inline handle_t *ext4_journal_start(struct inode *inode,
+					   int nblocks, bool errok)
 {
-	return ext4_journal_start_sb(inode->i_sb, nblocks);
+	return ext4_journal_start_sb(inode->i_sb, nblocks, errok);
 }

 #define ext4_journal_stop(handle) \
@@ -232,7 +233,7 @@ static inline int ext4_journal_extend(handle_t
*handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, false);
 	return 0;
 }

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 63a7581..5944b1c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2333,7 +2333,7 @@ static int ext4_ext_remove_space(struct inode
*inode, ext4_lblk_t start)
 	ext_debug("truncate since %u\n", start);

 	/* probably first extent we're gonna free will be last in block */
-	handle =3D ext4_journal_start(inode, depth + 1);
+	handle =3D ext4_journal_start(inode, depth + 1, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -3544,7 +3544,7 @@ void ext4_ext_truncate(struct inode *inode)
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err =3D ext4_writepage_trans_blocks(inode);
-	handle =3D ext4_journal_start(inode, err);
+	handle =3D ext4_journal_start(inode, err, false);
 	if (IS_ERR(handle))
 		return;

@@ -3677,7 +3677,7 @@ retry:
 	while (ret >=3D 0 && ret < max_blocks) {
 		map.m_lblk =3D map.m_lblk + ret;
 		map.m_len =3D max_blocks =3D max_blocks - ret;
-		handle =3D ext4_journal_start(inode, credits);
+		handle =3D ext4_journal_start(inode, credits, true);
 		if (IS_ERR(handle)) {
 			ret =3D PTR_ERR(handle);
 			break;
@@ -3752,7 +3752,7 @@ int ext4_convert_unwritten_extents(struct inode
*inode, loff_t offset,
 	while (ret >=3D 0 && ret < max_blocks) {
 		map.m_lblk +=3D ret;
 		map.m_len =3D (max_blocks -=3D ret);
-		handle =3D ext4_journal_start(inode, credits);
+		handle =3D ext4_journal_start(inode, credits, false);
 		if (IS_ERR(handle)) {
 			ret =3D PTR_ERR(handle);
 			break;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index eb9097a..4499dcd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1257,7 +1257,7 @@ extern int ext4_init_inode_table(struct
super_block *sb, ext4_group_t group,
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
 		goto out;

-	handle =3D ext4_journal_start_sb(sb, 1);
+	handle =3D ext4_journal_start_sb(sb, 1, false);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..12a9b74 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -129,7 +129,7 @@ static handle_t *start_transaction(struct inode *in=
ode)
 {
 	handle_t *result;

-	result =3D ext4_journal_start(inode, blocks_for_truncate(inode));
+	result =3D ext4_journal_start(inode, blocks_for_truncate(inode), fals=
e);
 	if (!IS_ERR(result))
 		return result;

@@ -204,7 +204,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto no_delete;

-	handle =3D ext4_journal_start(inode, blocks_for_truncate(inode)+3);
+	handle =3D ext4_journal_start(inode, blocks_for_truncate(inode)+3, fa=
lse);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
@@ -1398,7 +1398,7 @@ static int _ext4_get_block(struct inode *inode,
sector_t iblock,
 		if (map.m_len > DIO_MAX_BLOCKS)
 			map.m_len =3D DIO_MAX_BLOCKS;
 		dio_credits =3D ext4_chunk_trans_blocks(inode, map.m_len);
-		handle =3D ext4_journal_start(inode, dio_credits);
+		handle =3D ext4_journal_start(inode, dio_credits, false);
 		if (IS_ERR(handle)) {
 			ret =3D PTR_ERR(handle);
 			return ret;
@@ -1621,7 +1621,7 @@ static int ext4_write_begin(struct file *file,
struct address_space *mapping,
 	to =3D from + len;

 retry:
-	handle =3D ext4_journal_start(inode, needed_blocks);
+	handle =3D ext4_journal_start(inode, needed_blocks, true);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -2653,7 +2653,8 @@ static int __ext4_journalled_writepage(struct pag=
e *page,
 	 * references to buffers so we are safe */
 	unlock_page(page);

-	handle =3D ext4_journal_start(inode, ext4_writepage_trans_blocks(inod=
e));
+	handle =3D ext4_journal_start(inode, ext4_writepage_trans_blocks(inod=
e),
+				    false);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -3049,7 +3050,7 @@ retry:
 		needed_blocks =3D ext4_da_writepages_trans_blocks(inode);

 		/* start a new transaction*/
-		handle =3D ext4_journal_start(inode, needed_blocks);
+		handle =3D ext4_journal_start(inode, needed_blocks, false);
 		if (IS_ERR(handle)) {
 			ret =3D PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
@@ -3204,7 +3205,7 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start(inode, 1, true);
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -3553,7 +3554,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct
kiocb *iocb,

 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
-			handle =3D ext4_journal_start(inode, 2);
+			handle =3D ext4_journal_start(inode, 2, true);
 			if (IS_ERR(handle)) {
 				ret =3D PTR_ERR(handle);
 				goto out;
@@ -3596,7 +3597,7 @@ retry:
 		int err;

 		/* Credits for sb + inode write */
-		handle =3D ext4_journal_start(inode, 2);
+		handle =3D ext4_journal_start(inode, 2, true);
 		if (IS_ERR(handle)) {
 			/* This is really bad luck. We've written the data
 			 * but cannot extend i_size. Bail out and pretend
@@ -5329,8 +5330,10 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)

 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle =3D ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(ino=
de->i_sb)+
-					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
+		handle =3D ext4_journal_start(inode,
+					    (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
+					    EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
+					    true);
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
 			goto err_out;
@@ -5365,7 +5368,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
 		handle_t *handle;

-		handle =3D ext4_journal_start(inode, 3);
+		handle =3D ext4_journal_start(inode, 3, true);
 		if (IS_ERR(handle)) {
 			error =3D PTR_ERR(handle);
 			goto err_out;
@@ -5385,7 +5388,7 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 							    attr->ia_size);
 			if (error) {
 				/* Do as much error cleanup as possible */
-				handle =3D ext4_journal_start(inode, 3);
+				handle =3D ext4_journal_start(inode, 3, false);
 				if (IS_ERR(handle)) {
 					ext4_orphan_del(NULL, inode);
 					goto err_out;
@@ -5421,7 +5424,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
 		rc =3D ext4_acl_chmod(inode);

 err_out:
-	ext4_std_error(inode->i_sb, error);
+	if (error !=3D -ENOMEM) {
+		ext4_std_error(inode->i_sb, error);
+	}
 	if (!error)
 		error =3D rc;
 	return error;
@@ -5738,7 +5743,7 @@ void ext4_dirty_inode(struct inode *inode)
 {
 	handle_t *handle;

-	handle =3D ext4_journal_start(inode, 2);
+	handle =3D ext4_journal_start(inode, 2, false);
 	if (IS_ERR(handle))
 		goto out;

@@ -5822,7 +5827,7 @@ int ext4_change_inode_journal_flag(struct inode
*inode, int val)

 	/* Finally we can mark the inode as dirty. */

-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start(inode, 1, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index eb3bc2f..a357b9a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
cmd, unsigned long arg)
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
 			ext4_truncate(inode);

-		handle =3D ext4_journal_start(inode, 1);
+		handle =3D ext4_journal_start(inode, 1, true);
 		if (IS_ERR(handle)) {
 			err =3D PTR_ERR(handle);
 			goto flags_out;
@@ -157,7 +157,7 @@ flags_out:
 			goto setversion_out;
 		}

-		handle =3D ext4_journal_start(inode, 1);
+		handle =3D ext4_journal_start(inode, 1, true);
 		if (IS_ERR(handle)) {
 			err =3D PTR_ERR(handle);
 			goto setversion_out;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b0a126f..729dcbc 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -488,7 +488,7 @@ int ext4_ext_migrate(struct inode *inode)
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
-					+ 1);
+					+ 1, true);
 	if (IS_ERR(handle)) {
 		retval =3D PTR_ERR(handle);
 		return retval;
@@ -533,7 +533,7 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_set_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
 	up_read((&EXT4_I(inode)->i_data_sem));

-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start(inode, 1, true);
 	if (IS_ERR(handle)) {
 		/*
 		 * It is impossible to update on-disk structures without
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b9f3e78..d5aad4d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,7 +813,7 @@ move_extent_per_page(struct file *o_filp, struct
inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks =3D ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle =3D ext4_journal_start(orig_inode, jblocks);
+	handle =3D ext4_journal_start(orig_inode, jblocks, true);
 	if (IS_ERR(handle)) {
 		*err =3D PTR_ERR(handle);
 		return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5485390..a3ad11f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1739,7 +1739,8 @@ static int ext4_create(struct inode *dir, struct
dentry *dentry, int mode,
 retry:
 	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -1775,7 +1776,8 @@ static int ext4_mknod(struct inode *dir, struct
dentry *dentry,
 retry:
 	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -1814,7 +1816,8 @@ static int ext4_mkdir(struct inode *dir, struct
dentry *dentry, int mode)
 retry:
 	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+					true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2127,7 +2130,8 @@ static int ext4_rmdir(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb=
));
+	handle =3D ext4_journal_start(dir,
+				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb), true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2188,7 +2192,8 @@ static int ext4_unlink(struct inode *dir, struct
dentry *dentry)
 	dquot_initialize(dir);
 	dquot_initialize(dentry->d_inode);

-	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb=
));
+	handle =3D ext4_journal_start(dir,
+				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb), true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2246,8 +2251,9 @@ static int ext4_symlink(struct inode *dir,

 retry:
 	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
-					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
+				    EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
+				    EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb),
+				    true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2313,7 +2319,7 @@ static int ext4_link(struct dentry *old_dentry,

 retry:
 	handle =3D ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) =
+
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS, true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

@@ -2365,7 +2371,7 @@ static int ext4_rename(struct inode *old_dir,
struct dentry *old_dentry,
 		dquot_initialize(new_dentry->d_inode);
 	handle =3D ext4_journal_start(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2, true);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3ecc6e4..e50d083 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -176,7 +176,7 @@ static int setup_new_group_blocks(struct super_bloc=
k *sb,
 	int err =3D 0, err2;

 	/* This transaction may be extended/restarted along the way */
-	handle =3D ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle =3D ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, true);

 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -655,7 +655,7 @@ static void update_backups(struct super_block *sb,
 	handle_t *handle;
 	int err =3D 0, err2;

-	handle =3D ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	handle =3D ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA, true);
 	if (IS_ERR(handle)) {
 		group =3D 1;
 		err =3D PTR_ERR(handle);
@@ -793,7 +793,7 @@ int ext4_group_add(struct super_block *sb, struct
ext4_new_group_data *input)
 	 */
 	handle =3D ext4_journal_start_sb(sb,
 				       ext4_bg_has_super(sb, input->group) ?
-				       3 + reserved_gdb : 4);
+				       3 + reserved_gdb : 4, true);
 	if (IS_ERR(handle)) {
 		err =3D PTR_ERR(handle);
 		goto exit_put;
@@ -1031,7 +1031,7 @@ int ext4_group_extend(struct super_block *sb,
struct ext4_super_block *es,
 	/* We will update the superblock, one block bitmap, and
 	 * one group descriptor via ext4_free_blocks().
 	 */
-	handle =3D ext4_journal_start_sb(sb, 3);
+	handle =3D ext4_journal_start_sb(sb, 3, true);
 	if (IS_ERR(handle)) {
 		err =3D PTR_ERR(handle);
 		ext4_warning(sb, "error %d on journal start", err);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb10a06..eacfea7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ static void ext4_put_nojournal(handle_t *handle)
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks,
bool errok)
 {
 	journal_t *journal;

@@ -258,7 +258,7 @@ handle_t *ext4_journal_start_sb(struct super_block
*sb, int nblocks)
 			ext4_abort(sb, "Detected aborted journal");
 			return ERR_PTR(-EROFS);
 		}
-		return jbd2_journal_start(journal, nblocks);
+		return jbd2_journal_start(journal, nblocks, errok);
 	}
 	return ext4_get_nojournal();
 }
@@ -4471,7 +4471,8 @@ static int ext4_write_dquot(struct dquot *dquot)

 	inode =3D dquot_to_inode(dquot);
 	handle =3D ext4_journal_start(inode,
-				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb),
+				    false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret =3D dquot_commit(dquot);
@@ -4487,7 +4488,7 @@ static int ext4_acquire_dquot(struct dquot *dquot=
)
 	handle_t *handle;

 	handle =3D ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb), false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret =3D dquot_acquire(dquot);
@@ -4503,7 +4504,7 @@ static int ext4_release_dquot(struct dquot *dquot=
)
 	handle_t *handle;

 	handle =3D ext4_journal_start(dquot_to_inode(dquot),
-				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb), false);
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
@@ -4534,7 +4535,7 @@ static int ext4_write_info(struct super_block
*sb, int type)
 	handle_t *handle;

 	/* Data block + inode block */
-	handle =3D ext4_journal_start(sb->s_root->d_inode, 2);
+	handle =3D ext4_journal_start(sb->s_root->d_inode, 2, false);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret =3D dquot_commit_info(sb, type);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index fc32176..0e39f57 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1084,7 +1084,8 @@ ext4_xattr_set(struct inode *inode, int
name_index, const char *name,
 	int error, retries =3D 0;

 retry:
-	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_=
sb));
+	handle =3D ext4_journal_start(inode,
+				    EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
 	if (IS_ERR(handle)) {
 		error =3D PTR_ERR(handle);
 	} else {
--=20
1.6.0.4


Thanks -
Manish

>
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index eb3bc2f..3e7977b 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
>> cmd, unsigned long arg)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (oldflags & EXT4_EOFBLOCKS_FL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 1, fa=
lse);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(handle);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto flags_out;
> =A0This can handle failure just fine...
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cb10a06..7714a15 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4487,7 +4488,7 @@ static int ext4_acquire_dquot(struct dquot *dq=
uot)
>> =A0 =A0 =A0 handle_t *handle;
>>
>> =A0 =A0 =A0 handle =3D ext4_journal_start(dquot_to_inode(dquot),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_INIT_BLOCKS(dquot->dq_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
>> =A0 =A0 =A0 ret =3D dquot_acquire(dquot);
>> @@ -4503,7 +4504,7 @@ static int ext4_release_dquot(struct dquot *dq=
uot)
>> =A0 =A0 =A0 handle_t *handle;
>>
>> =A0 =A0 =A0 handle =3D ext4_journal_start(dquot_to_inode(dquot),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EX=
T4_QUOTA_DEL_BLOCKS(dquot->dq_sb), true);
>> =A0 =A0 =A0 if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Release dquot anyway to avoid endless=
 cycle in dqput() */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dquot_release(dquot);
> =A0For now put 'false' in these quota functions. Because failure here
> results in a failure of dquot_initialize() which is not tested in mos=
t
> places and thus results in quota miscomputations... Properly handling=
 this
> would require another set of cleanups.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
