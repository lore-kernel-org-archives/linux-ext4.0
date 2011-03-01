From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ext4: record error messages in message buffer
Date: Tue, 1 Mar 2011 07:27:54 +0200
Message-ID: <AANLkTimksvJ1hTwE-pqidDzVh95GGtOyr0m0At+ovJ_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0015175d0adaf50c28049d650e74
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44976 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab1CAF14 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 00:27:56 -0500
Received: by qwd7 with SMTP id 7so3407452qwd.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 21:27:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0015175d0adaf50c28049d650e74
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ted,

I found this patch in my haystack.
Are you planning to merge it in upcoming merge window?

I will follow with latest version of fsck patch.

Thanks,
Amir.

---------- Forwarded message ----------
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, Jan 2, 2011 at 9:23 PM
Subject: Re: Regular ext4 error warning with HD in USB dock
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
linux-ext4@vger.kernel.org


On Sat, Jan 1, 2011 at 7:20 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> On 12/28/2010 05:30 AM, Amir Goldstein wrote:
>>
>> On Tue, Dec 28, 2010 at 10:19 AM, Rogier Wolff<R.E.Wolff@bitwizard.nl>
>> =A0wrote:
>>>
>>> On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
>>>>
>>>> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
>>>>>
>>>>> [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback da=
ta
>>>>> mode.
>>>>> Opts: (null)
>>>>> [1048702.736011] EXT4-fs (sde8): error count: 3
>>>>> [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
>>>>> ext4_journal_start_sb:251
>>>>> [1048702.736018] EXT4-fs (sde8): last error at 1289080948:
>>>>> ext4_put_super:719
>>>>
>>>> That's actually not an error. =A0It's a report which is generated ever=
y
>>>> 24 hours, indicating that there has been 3 errors since the last time
>>>> the error count has been cleared, with the first error taking place at
>>>> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
>>>> ext4_journal_start_sb(), at line 251, and the most recent error taking
>>>> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
>>>> ext4_put_super() at line 719. =A0This is a new feature which was added
>>>> in 2.6.36.
>>>
>>> Nice. But the issue you're not mentioning is: What errors could have
>>> happened on the 6th of november? Should Con worry about those errors?
>>>
>> Ted,
>>
>> I would like to use this opportunity to remind you about my
>> record_journal_errstr()
>> implementation, see:
>>
>> https://github.com/amir73il/ext4-snapshots/blob/next3-stable/fs/next3/su=
per.c#L157
>>
>> It records the initial errors messages (which I found to be the most
>> interesting),
>> in a message buffer on the unused space after the journal super block
>> (3K on a 4K block fs).
>>
>> fsck prints out those messages and clears the buffer.
>> In under a year of Next3 fs in beta and production, it has helped me man=
y
>> times
>> to analyse bugs post-mortem and find the problem.
>>
>> If there is demand, I can post the patch for Ext4.
>>
>> Amir.
>
> I do think that this sounds like a useful addition - should be very usefu=
l
> in doing post mortem analysis...
>
> Thanks!
>
> Ric
>
>

Hi Ric,

Attached are the patches for ext4 (against Ted's next branch) and
e2fsck (against 1.41.14).

e2fsck patch is running in production with e2fsprogs-1.41.9 and the
porting to 1.41.14 was trivial.
ext4 patch is a 'trivial+' port of the Next3 patch running in production.

Do you think you guys can take the patches for a test drive?

Thanks,
Amir.


ext4: record error messages in message buffer

Ext4 error messages are stored in the free space after the journal super bl=
ock.
After journal recovery, the message buffer is copied from the journal super
block to the file system super block.

When error behavior is configured to remount-ro, the message buffer can be =
read
and displayed at a later time by e2fsck. The messages from the time of the
error are very helpful in post-mortem bug analysis.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7728a4c..8888815 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -290,10 +290,53 @@ int __ext4_journal_stop(const char *where,
unsigned int line, handle_t *handle)
=A0 =A0 =A0 =A0return err;
=A0}

+/* record error messages after journal super block */
+static void ext4_record_journal_err(struct super_block *sb, const char *wh=
ere,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *function, const char *fmt, va_lis=
t args)
+{
+#define MSGLEN 256
+ =A0 =A0 =A0 journal_t *journal =3D EXT4_SB(sb)->s_journal;
+ =A0 =A0 =A0 char *buf;
+ =A0 =A0 =A0 unsigned long offset;
+ =A0 =A0 =A0 int len;
+
+ =A0 =A0 =A0 if (!journal)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
+
+ =A0 =A0 =A0 buf =3D (char *)journal->j_superblock;
+ =A0 =A0 =A0 offset =3D (unsigned long)buf % sb->s_blocksize;
+ =A0 =A0 =A0 buf +=3D sizeof(journal_superblock_t);
+ =A0 =A0 =A0 offset +=3D sizeof(journal_superblock_t);
+
+ =A0 =A0 =A0 /* seek to end of message buffer */
+ =A0 =A0 =A0 while (offset < sb->s_blocksize && *buf) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf +=3D MSGLEN;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D MSGLEN;
+ =A0 =A0 =A0 }
+
+ =A0 =A0 =A0 if (offset+MSGLEN > sb->s_blocksize)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no space left in message buffer */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
+
+ =A0 =A0 =A0 len =3D snprintf(buf, MSGLEN, "%s: %s: ", where, function);
+ =A0 =A0 =A0 len +=3D vsnprintf(buf+len, MSGLEN-len, fmt, args);
+}
+
+static void ext4_record_journal_errstr(struct super_block *sb,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *where, const char *function, ...)
+{
+ =A0 =A0 =A0 va_list args;
+
+ =A0 =A0 =A0 va_start(args, function);
+ =A0 =A0 =A0 ext4_record_journal_err(sb, where, function, "%s\n", args);
+ =A0 =A0 =A0 va_end(args);
+}
+
=A0void ext4_journal_abort_handle(const char *caller, unsigned int line,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *err=
_fn, struct buffer_head *bh,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_t *handl=
e, int err)
=A0{
+ =A0 =A0 =A0 struct super_block *sb =3D handle->h_transaction->t_journal->=
j_private;
=A0 =A0 =A0 =A0char nbuf[16];
=A0 =A0 =A0 =A0const char *errstr =3D ext4_decode_error(NULL, err, nbuf);

@@ -311,6 +354,9 @@ void ext4_journal_abort_handle(const char *caller,
unsigned int line,
=A0 =A0 =A0 =A0printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
=A0 =A0 =A0 =A0 =A0 =A0 =A0 caller, line, errstr, err_fn);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 ext4_record_journal_errstr(sb, caller, err_fn, errstr);
+
=A0 =A0 =A0 =A0jbd2_journal_abort_handle(handle);
=A0}

@@ -398,6 +444,11 @@ void __ext4_error(struct super_block *sb, const
char *function,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_id, function, line, current->comm, &vaf);
=A0 =A0 =A0 =A0va_end(args);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 va_start(args, fmt);
+ =A0 =A0 =A0 ext4_record_journal_err(sb, __func__, function, fmt, args);
+ =A0 =A0 =A0 va_end(args);
+
=A0 =A0 =A0 =A0ext4_handle_error(sb);
=A0}

@@ -422,6 +473,11 @@ void ext4_error_inode(struct inode *inode, const
char *function,
=A0 =A0 =A0 =A0printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
=A0 =A0 =A0 =A0va_end(args);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 va_start(args, fmt);
+ =A0 =A0 =A0 ext4_record_journal_err(inode->i_sb, __func__, function, fmt,=
 args);
+ =A0 =A0 =A0 va_end(args);
+
=A0 =A0 =A0 =A0ext4_handle_error(inode->i_sb);
=A0}

@@ -452,6 +508,11 @@ void ext4_error_file(struct file *file, const
char *function,
=A0 =A0 =A0 =A0printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, p=
ath, &vaf);
=A0 =A0 =A0 =A0va_end(args);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 va_start(args, fmt);
+ =A0 =A0 =A0 ext4_record_journal_err(inode->i_sb, __func__, function, fmt,=
 args);
+ =A0 =A0 =A0 va_end(args);
+
=A0 =A0 =A0 =A0ext4_handle_error(inode->i_sb);
=A0}

@@ -510,6 +571,9 @@ void __ext4_std_error(struct super_block *sb,
const char *function,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_id, function, line, errstr);
=A0 =A0 =A0 =A0save_error_info(sb, function, line);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 ext4_record_journal_errstr(sb, __func__, function, errstr);
+
=A0 =A0 =A0 =A0ext4_handle_error(sb);
=A0}

@@ -536,6 +600,11 @@ void __ext4_abort(struct super_block *sb, const
char *function,
=A0 =A0 =A0 =A0printk("\n");
=A0 =A0 =A0 =A0va_end(args);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 va_start(args, fmt);
+ =A0 =A0 =A0 ext4_record_journal_err(sb, __func__, function, fmt, args);
+ =A0 =A0 =A0 va_end(args);
+
=A0 =A0 =A0 =A0if ((sb->s_flags & MS_RDONLY) =3D=3D 0) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_CRIT, "Remounting filesyst=
em read-only");
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_flags |=3D MS_RDONLY;
@@ -602,6 +671,11 @@ __acquires(bitlock)
=A0 =A0 =A0 =A0printk(KERN_CONT "%pV\n", &vaf);
=A0 =A0 =A0 =A0va_end(args);

+ =A0 =A0 =A0 /* record error message in journal super block */
+ =A0 =A0 =A0 va_start(args, fmt);
+ =A0 =A0 =A0 ext4_record_journal_err(sb, __func__, function, fmt, args);
+ =A0 =A0 =A0 va_end(args);
+
=A0 =A0 =A0 =A0if (test_opt(sb, ERRORS_CONT)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_commit_super(sb, 0);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
@@ -4067,12 +4141,35 @@ static void ext4_clear_journal_err(struct
super_block *sb,
=A0 =A0 =A0 =A0j_errno =3D jbd2_journal_errno(journal);
=A0 =A0 =A0 =A0if (j_errno) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char nbuf[16];
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *buf1, *buf2;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long offset1, offset2;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len1, len2;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy message buffer from journal to super =
block */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf1 =3D (char *)journal->j_superblock;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset1 =3D (unsigned long)buf1 % sb->s_block=
size;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf1 +=3D sizeof(journal_superblock_t);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset1 +=3D sizeof(journal_superblock_t);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 len1 =3D sb->s_blocksize - offset1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf2 =3D (char *)EXT4_SB(sb)->s_es;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset2 =3D (unsigned long)buf2 % sb->s_block=
size;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf2 +=3D sizeof(struct ext4_super_block);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset2 +=3D sizeof(struct ext4_super_block);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 len2 =3D sb->s_blocksize - offset2;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len2 > len1)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len2 =3D len1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len2 > 0 && *buf1)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(buf2, buf1, len2);

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0errstr =3D ext4_decode_error(sb, j_errno, nb=
uf);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_warning(sb, "Filesystem error recorded =
"
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "from previous moun=
t: %s", errstr);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_warning(sb, "Marking fs in need of file=
system check.");

+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear journal message buffer */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len1 > 0)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(buf1, 0, len1);
+
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_SB(sb)->s_mount_state |=3D EXT4_ERROR_F=
S;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0es->s_state |=3D cpu_to_le16(EXT4_ERROR_FS);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_commit_super(sb, 1);

--0015175d0adaf50c28049d650e74
Content-Type: application/octet-stream;
	name="ext4_record_error_messages.patch"
Content-Disposition: attachment; filename="ext4_record_error_messages.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gigbnc7n1

ZXh0NDogcmVjb3JkIGVycm9yIG1lc3NhZ2VzIGluIG1lc3NhZ2UgYnVmZmVyCgpFeHQ0IGVycm9y
IG1lc3NhZ2VzIGFyZSBzdG9yZWQgaW4gdGhlIGZyZWUgc3BhY2UgYWZ0ZXIgdGhlIGpvdXJuYWwg
c3VwZXIgYmxvY2suCkFmdGVyIGpvdXJuYWwgcmVjb3ZlcnksIHRoZSBtZXNzYWdlIGJ1ZmZlciBp
cyBjb3BpZWQgZnJvbSB0aGUgam91cm5hbCBzdXBlcgpibG9jayB0byB0aGUgZmlsZSBzeXN0ZW0g
c3VwZXIgYmxvY2suCgpXaGVuIGVycm9yIGJlaGF2aW9yIGlzIGNvbmZpZ3VyZWQgdG8gcmVtb3Vu
dC1ybywgdGhlIG1lc3NhZ2UgYnVmZmVyIGNhbiBiZSByZWFkCmFuZCBkaXNwbGF5ZWQgYXQgYSBs
YXRlciB0aW1lIGJ5IGUyZnNjay4gVGhlIG1lc3NhZ2VzIGZyb20gdGhlIHRpbWUgb2YgdGhlCmVy
cm9yIGFyZSB2ZXJ5IGhlbHBmdWwgaW4gcG9zdC1tb3J0ZW0gYnVnIGFuYWx5c2lzLgoKU2lnbmVk
LW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQHVzZXJzLnNmLm5ldD4KCmRpZmYgLS1n
aXQgYS9mcy9leHQ0L3N1cGVyLmMgYi9mcy9leHQ0L3N1cGVyLmMKaW5kZXggNzcyOGE0Yy4uODg4
ODgxNSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9zdXBlci5jCisrKyBiL2ZzL2V4dDQvc3VwZXIuYwpA
QCAtMjkwLDEwICsyOTAsNTMgQEAgaW50IF9fZXh0NF9qb3VybmFsX3N0b3AoY29uc3QgY2hhciAq
d2hlcmUsIHVuc2lnbmVkIGludCBsaW5lLCBoYW5kbGVfdCAqaGFuZGxlKQogCXJldHVybiBlcnI7
CiB9CiAKKy8qIHJlY29yZCBlcnJvciBtZXNzYWdlcyBhZnRlciBqb3VybmFsIHN1cGVyIGJsb2Nr
ICovCitzdGF0aWMgdm9pZCBleHQ0X3JlY29yZF9qb3VybmFsX2VycihzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiLCBjb25zdCBjaGFyICp3aGVyZSwKKwkJY29uc3QgY2hhciAqZnVuY3Rpb24sIGNvbnN0
IGNoYXIgKmZtdCwgdmFfbGlzdCBhcmdzKQoreworI2RlZmluZSBNU0dMRU4gMjU2CisJam91cm5h
bF90ICpqb3VybmFsID0gRVhUNF9TQihzYiktPnNfam91cm5hbDsKKwljaGFyICpidWY7CisJdW5z
aWduZWQgbG9uZyBvZmZzZXQ7CisJaW50IGxlbjsKKwkKKwlpZiAoIWpvdXJuYWwpCisJCXJldHVy
bjsKKworCWJ1ZiA9IChjaGFyICopam91cm5hbC0+al9zdXBlcmJsb2NrOworCW9mZnNldCA9ICh1
bnNpZ25lZCBsb25nKWJ1ZiAlIHNiLT5zX2Jsb2Nrc2l6ZTsKKwlidWYgKz0gc2l6ZW9mKGpvdXJu
YWxfc3VwZXJibG9ja190KTsKKwlvZmZzZXQgKz0gc2l6ZW9mKGpvdXJuYWxfc3VwZXJibG9ja190
KTsKKworCS8qIHNlZWsgdG8gZW5kIG9mIG1lc3NhZ2UgYnVmZmVyICovCisJd2hpbGUgKG9mZnNl
dCA8IHNiLT5zX2Jsb2Nrc2l6ZSAmJiAqYnVmKSB7CisJCWJ1ZiArPSBNU0dMRU47CisJCW9mZnNl
dCArPSBNU0dMRU47CisJfQorCisJaWYgKG9mZnNldCtNU0dMRU4gPiBzYi0+c19ibG9ja3NpemUp
CisJCS8qIG5vIHNwYWNlIGxlZnQgaW4gbWVzc2FnZSBidWZmZXIgKi8KKwkJcmV0dXJuOworCisJ
bGVuID0gc25wcmludGYoYnVmLCBNU0dMRU4sICIlczogJXM6ICIsIHdoZXJlLCBmdW5jdGlvbik7
CisJbGVuICs9IHZzbnByaW50ZihidWYrbGVuLCBNU0dMRU4tbGVuLCBmbXQsIGFyZ3MpOworfQor
CitzdGF0aWMgdm9pZCBleHQ0X3JlY29yZF9qb3VybmFsX2VycnN0cihzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiLAorCQljb25zdCBjaGFyICp3aGVyZSwgY29uc3QgY2hhciAqZnVuY3Rpb24sIC4uLikK
K3sKKwl2YV9saXN0IGFyZ3M7CisKKwl2YV9zdGFydChhcmdzLCBmdW5jdGlvbik7CisJZXh0NF9y
ZWNvcmRfam91cm5hbF9lcnIoc2IsIHdoZXJlLCBmdW5jdGlvbiwgIiVzXG4iLCBhcmdzKTsKKwl2
YV9lbmQoYXJncyk7Cit9CisKIHZvaWQgZXh0NF9qb3VybmFsX2Fib3J0X2hhbmRsZShjb25zdCBj
aGFyICpjYWxsZXIsIHVuc2lnbmVkIGludCBsaW5lLAogCQkJICAgICAgIGNvbnN0IGNoYXIgKmVy
cl9mbiwgc3RydWN0IGJ1ZmZlcl9oZWFkICpiaCwKIAkJCSAgICAgICBoYW5kbGVfdCAqaGFuZGxl
LCBpbnQgZXJyKQogeworCXN0cnVjdCBzdXBlcl9ibG9jayAqc2IgPSBoYW5kbGUtPmhfdHJhbnNh
Y3Rpb24tPnRfam91cm5hbC0+al9wcml2YXRlOwogCWNoYXIgbmJ1ZlsxNl07CiAJY29uc3QgY2hh
ciAqZXJyc3RyID0gZXh0NF9kZWNvZGVfZXJyb3IoTlVMTCwgZXJyLCBuYnVmKTsKIApAQCAtMzEx
LDYgKzM1NCw5IEBAIHZvaWQgZXh0NF9qb3VybmFsX2Fib3J0X2hhbmRsZShjb25zdCBjaGFyICpj
YWxsZXIsIHVuc2lnbmVkIGludCBsaW5lLAogCXByaW50ayhLRVJOX0VSUiAiJXM6JWQ6IGFib3J0
aW5nIHRyYW5zYWN0aW9uOiAlcyBpbiAlc1xuIiwKIAkgICAgICAgY2FsbGVyLCBsaW5lLCBlcnJz
dHIsIGVycl9mbik7CiAKKwkvKiByZWNvcmQgZXJyb3IgbWVzc2FnZSBpbiBqb3VybmFsIHN1cGVy
IGJsb2NrICovCisJZXh0NF9yZWNvcmRfam91cm5hbF9lcnJzdHIoc2IsIGNhbGxlciwgZXJyX2Zu
LCBlcnJzdHIpOworCiAJamJkMl9qb3VybmFsX2Fib3J0X2hhbmRsZShoYW5kbGUpOwogfQogCkBA
IC0zOTgsNiArNDQ0LDExIEBAIHZvaWQgX19leHQ0X2Vycm9yKHN0cnVjdCBzdXBlcl9ibG9jayAq
c2IsIGNvbnN0IGNoYXIgKmZ1bmN0aW9uLAogCSAgICAgICBzYi0+c19pZCwgZnVuY3Rpb24sIGxp
bmUsIGN1cnJlbnQtPmNvbW0sICZ2YWYpOwogCXZhX2VuZChhcmdzKTsKIAorCS8qIHJlY29yZCBl
cnJvciBtZXNzYWdlIGluIGpvdXJuYWwgc3VwZXIgYmxvY2sgKi8KKwl2YV9zdGFydChhcmdzLCBm
bXQpOworCWV4dDRfcmVjb3JkX2pvdXJuYWxfZXJyKHNiLCBfX2Z1bmNfXywgZnVuY3Rpb24sIGZt
dCwgYXJncyk7CisJdmFfZW5kKGFyZ3MpOworCiAJZXh0NF9oYW5kbGVfZXJyb3Ioc2IpOwogfQog
CkBAIC00MjIsNiArNDczLDExIEBAIHZvaWQgZXh0NF9lcnJvcl9pbm9kZShzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBjb25zdCBjaGFyICpmdW5jdGlvbiwKIAlwcmludGsoS0VSTl9DT05UICJjb21tICVz
OiAlcFZcbiIsIGN1cnJlbnQtPmNvbW0sICZ2YWYpOwogCXZhX2VuZChhcmdzKTsKIAorCS8qIHJl
Y29yZCBlcnJvciBtZXNzYWdlIGluIGpvdXJuYWwgc3VwZXIgYmxvY2sgKi8KKwl2YV9zdGFydChh
cmdzLCBmbXQpOworCWV4dDRfcmVjb3JkX2pvdXJuYWxfZXJyKGlub2RlLT5pX3NiLCBfX2Z1bmNf
XywgZnVuY3Rpb24sIGZtdCwgYXJncyk7CisJdmFfZW5kKGFyZ3MpOworCiAJZXh0NF9oYW5kbGVf
ZXJyb3IoaW5vZGUtPmlfc2IpOwogfQogCkBAIC00NTIsNiArNTA4LDExIEBAIHZvaWQgZXh0NF9l
cnJvcl9maWxlKHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBjaGFyICpmdW5jdGlvbiwKIAlwcmlu
dGsoS0VSTl9DT05UICJjb21tICVzOiBwYXRoICVzOiAlcFZcbiIsIGN1cnJlbnQtPmNvbW0sIHBh
dGgsICZ2YWYpOwogCXZhX2VuZChhcmdzKTsKIAorCS8qIHJlY29yZCBlcnJvciBtZXNzYWdlIGlu
IGpvdXJuYWwgc3VwZXIgYmxvY2sgKi8KKwl2YV9zdGFydChhcmdzLCBmbXQpOworCWV4dDRfcmVj
b3JkX2pvdXJuYWxfZXJyKGlub2RlLT5pX3NiLCBfX2Z1bmNfXywgZnVuY3Rpb24sIGZtdCwgYXJn
cyk7CisJdmFfZW5kKGFyZ3MpOworCiAJZXh0NF9oYW5kbGVfZXJyb3IoaW5vZGUtPmlfc2IpOwog
fQogCkBAIC01MTAsNiArNTcxLDkgQEAgdm9pZCBfX2V4dDRfc3RkX2Vycm9yKHN0cnVjdCBzdXBl
cl9ibG9jayAqc2IsIGNvbnN0IGNoYXIgKmZ1bmN0aW9uLAogCSAgICAgICBzYi0+c19pZCwgZnVu
Y3Rpb24sIGxpbmUsIGVycnN0cik7CiAJc2F2ZV9lcnJvcl9pbmZvKHNiLCBmdW5jdGlvbiwgbGlu
ZSk7CiAKKwkvKiByZWNvcmQgZXJyb3IgbWVzc2FnZSBpbiBqb3VybmFsIHN1cGVyIGJsb2NrICov
CisJZXh0NF9yZWNvcmRfam91cm5hbF9lcnJzdHIoc2IsIF9fZnVuY19fLCBmdW5jdGlvbiwgZXJy
c3RyKTsKKwogCWV4dDRfaGFuZGxlX2Vycm9yKHNiKTsKIH0KIApAQCAtNTM2LDYgKzYwMCwxMSBA
QCB2b2lkIF9fZXh0NF9hYm9ydChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBjb25zdCBjaGFyICpm
dW5jdGlvbiwKIAlwcmludGsoIlxuIik7CiAJdmFfZW5kKGFyZ3MpOwogCisJLyogcmVjb3JkIGVy
cm9yIG1lc3NhZ2UgaW4gam91cm5hbCBzdXBlciBibG9jayAqLworCXZhX3N0YXJ0KGFyZ3MsIGZt
dCk7CisJZXh0NF9yZWNvcmRfam91cm5hbF9lcnIoc2IsIF9fZnVuY19fLCBmdW5jdGlvbiwgZm10
LCBhcmdzKTsKKwl2YV9lbmQoYXJncyk7CisKIAlpZiAoKHNiLT5zX2ZsYWdzICYgTVNfUkRPTkxZ
KSA9PSAwKSB7CiAJCWV4dDRfbXNnKHNiLCBLRVJOX0NSSVQsICJSZW1vdW50aW5nIGZpbGVzeXN0
ZW0gcmVhZC1vbmx5Iik7CiAJCXNiLT5zX2ZsYWdzIHw9IE1TX1JET05MWTsKQEAgLTYwMiw2ICs2
NzEsMTEgQEAgX19hY3F1aXJlcyhiaXRsb2NrKQogCXByaW50ayhLRVJOX0NPTlQgIiVwVlxuIiwg
JnZhZik7CiAJdmFfZW5kKGFyZ3MpOwogCisJLyogcmVjb3JkIGVycm9yIG1lc3NhZ2UgaW4gam91
cm5hbCBzdXBlciBibG9jayAqLworCXZhX3N0YXJ0KGFyZ3MsIGZtdCk7CisJZXh0NF9yZWNvcmRf
am91cm5hbF9lcnIoc2IsIF9fZnVuY19fLCBmdW5jdGlvbiwgZm10LCBhcmdzKTsKKwl2YV9lbmQo
YXJncyk7CisKIAlpZiAodGVzdF9vcHQoc2IsIEVSUk9SU19DT05UKSkgewogCQlleHQ0X2NvbW1p
dF9zdXBlcihzYiwgMCk7CiAJCXJldHVybjsKQEAgLTQwNjcsMTIgKzQxNDEsMzUgQEAgc3RhdGlj
IHZvaWQgZXh0NF9jbGVhcl9qb3VybmFsX2VycihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCWpf
ZXJybm8gPSBqYmQyX2pvdXJuYWxfZXJybm8oam91cm5hbCk7CiAJaWYgKGpfZXJybm8pIHsKIAkJ
Y2hhciBuYnVmWzE2XTsKKwkJY2hhciAqYnVmMSwgKmJ1ZjI7CisJCXVuc2lnbmVkIGxvbmcgb2Zm
c2V0MSwgb2Zmc2V0MjsKKwkJaW50IGxlbjEsIGxlbjI7CisKKwkJLyogY29weSBtZXNzYWdlIGJ1
ZmZlciBmcm9tIGpvdXJuYWwgdG8gc3VwZXIgYmxvY2sgKi8KKwkJYnVmMSA9IChjaGFyICopam91
cm5hbC0+al9zdXBlcmJsb2NrOworCQlvZmZzZXQxID0gKHVuc2lnbmVkIGxvbmcpYnVmMSAlIHNi
LT5zX2Jsb2Nrc2l6ZTsKKwkJYnVmMSArPSBzaXplb2Yoam91cm5hbF9zdXBlcmJsb2NrX3QpOwor
CQlvZmZzZXQxICs9IHNpemVvZihqb3VybmFsX3N1cGVyYmxvY2tfdCk7CisJCWxlbjEgPSBzYi0+
c19ibG9ja3NpemUgLSBvZmZzZXQxOworCQlidWYyID0gKGNoYXIgKilFWFQ0X1NCKHNiKS0+c19l
czsKKwkJb2Zmc2V0MiA9ICh1bnNpZ25lZCBsb25nKWJ1ZjIgJSBzYi0+c19ibG9ja3NpemU7CisJ
CWJ1ZjIgKz0gc2l6ZW9mKHN0cnVjdCBleHQ0X3N1cGVyX2Jsb2NrKTsKKwkJb2Zmc2V0MiArPSBz
aXplb2Yoc3RydWN0IGV4dDRfc3VwZXJfYmxvY2spOworCQlsZW4yID0gc2ItPnNfYmxvY2tzaXpl
IC0gb2Zmc2V0MjsKKwkJaWYgKGxlbjIgPiBsZW4xKQorCQkJbGVuMiA9IGxlbjE7CisJCWlmIChs
ZW4yID4gMCAmJiAqYnVmMSkKKwkJCW1lbWNweShidWYyLCBidWYxLCBsZW4yKTsKIAogCQllcnJz
dHIgPSBleHQ0X2RlY29kZV9lcnJvcihzYiwgal9lcnJubywgbmJ1Zik7CiAJCWV4dDRfd2Fybmlu
ZyhzYiwgIkZpbGVzeXN0ZW0gZXJyb3IgcmVjb3JkZWQgIgogCQkJICAgICAiZnJvbSBwcmV2aW91
cyBtb3VudDogJXMiLCBlcnJzdHIpOwogCQlleHQ0X3dhcm5pbmcoc2IsICJNYXJraW5nIGZzIGlu
IG5lZWQgb2YgZmlsZXN5c3RlbSBjaGVjay4iKTsKIAorCQkvKiBjbGVhciBqb3VybmFsIG1lc3Nh
Z2UgYnVmZmVyICovCisJCWlmIChsZW4xID4gMCkKKwkJCW1lbXNldChidWYxLCAwLCBsZW4xKTsK
KwogCQlFWFQ0X1NCKHNiKS0+c19tb3VudF9zdGF0ZSB8PSBFWFQ0X0VSUk9SX0ZTOwogCQllcy0+
c19zdGF0ZSB8PSBjcHVfdG9fbGUxNihFWFQ0X0VSUk9SX0ZTKTsKIAkJZXh0NF9jb21taXRfc3Vw
ZXIoc2IsIDEpOwo=
--0015175d0adaf50c28049d650e74--
