From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Sun, 2 Jan 2011 21:23:20 +0200
Message-ID: <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
	<AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
	<4D1F6244.7050203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016361e7dc6dba9fe0498e1f78c
Cc: "Ted Ts'o" <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47419 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1ABTXV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Jan 2011 14:23:21 -0500
Received: by qwa26 with SMTP id 26so12869295qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 02 Jan 2011 11:23:20 -0800 (PST)
In-Reply-To: <4D1F6244.7050203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016361e7dc6dba9fe0498e1f78c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

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
 	return err;
 }

+/* record error messages after journal super block */
+static void ext4_record_journal_err(struct super_block *sb, const char *wh=
ere,
+		const char *function, const char *fmt, va_list args)
+{
+#define MSGLEN 256
+	journal_t *journal =3D EXT4_SB(sb)->s_journal;
+	char *buf;
+	unsigned long offset;
+	int len;
+=09
+	if (!journal)
+		return;
+
+	buf =3D (char *)journal->j_superblock;
+	offset =3D (unsigned long)buf % sb->s_blocksize;
+	buf +=3D sizeof(journal_superblock_t);
+	offset +=3D sizeof(journal_superblock_t);
+
+	/* seek to end of message buffer */
+	while (offset < sb->s_blocksize && *buf) {
+		buf +=3D MSGLEN;
+		offset +=3D MSGLEN;
+	}
+
+	if (offset+MSGLEN > sb->s_blocksize)
+		/* no space left in message buffer */
+		return;
+
+	len =3D snprintf(buf, MSGLEN, "%s: %s: ", where, function);
+	len +=3D vsnprintf(buf+len, MSGLEN-len, fmt, args);
+}
+
+static void ext4_record_journal_errstr(struct super_block *sb,
+		const char *where, const char *function, ...)
+{
+	va_list args;
+
+	va_start(args, function);
+	ext4_record_journal_err(sb, where, function, "%s\n", args);
+	va_end(args);
+}
+
 void ext4_journal_abort_handle(const char *caller, unsigned int line,
 			       const char *err_fn, struct buffer_head *bh,
 			       handle_t *handle, int err)
 {
+	struct super_block *sb =3D handle->h_transaction->t_journal->j_private;
 	char nbuf[16];
 	const char *errstr =3D ext4_decode_error(NULL, err, nbuf);

@@ -311,6 +354,9 @@ void ext4_journal_abort_handle(const char *caller,
unsigned int line,
 	printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
 	       caller, line, errstr, err_fn);

+	/* record error message in journal super block */
+	ext4_record_journal_errstr(sb, caller, err_fn, errstr);
+
 	jbd2_journal_abort_handle(handle);
 }

@@ -398,6 +444,11 @@ void __ext4_error(struct super_block *sb, const
char *function,
 	       sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);

+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(sb);
 }

@@ -422,6 +473,11 @@ void ext4_error_inode(struct inode *inode, const
char *function,
 	printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
 	va_end(args);

+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(inode->i_sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(inode->i_sb);
 }

@@ -452,6 +508,11 @@ void ext4_error_file(struct file *file, const
char *function,
 	printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, path, &vaf);
 	va_end(args);

+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(inode->i_sb, __func__, function, fmt, args);
+	va_end(args);
+
 	ext4_handle_error(inode->i_sb);
 }

@@ -510,6 +571,9 @@ void __ext4_std_error(struct super_block *sb,
const char *function,
 	       sb->s_id, function, line, errstr);
 	save_error_info(sb, function, line);

+	/* record error message in journal super block */
+	ext4_record_journal_errstr(sb, __func__, function, errstr);
+
 	ext4_handle_error(sb);
 }

@@ -536,6 +600,11 @@ void __ext4_abort(struct super_block *sb, const
char *function,
 	printk("\n");
 	va_end(args);

+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	if ((sb->s_flags & MS_RDONLY) =3D=3D 0) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		sb->s_flags |=3D MS_RDONLY;
@@ -602,6 +671,11 @@ __acquires(bitlock)
 	printk(KERN_CONT "%pV\n", &vaf);
 	va_end(args);

+	/* record error message in journal super block */
+	va_start(args, fmt);
+	ext4_record_journal_err(sb, __func__, function, fmt, args);
+	va_end(args);
+
 	if (test_opt(sb, ERRORS_CONT)) {
 		ext4_commit_super(sb, 0);
 		return;
@@ -4067,12 +4141,35 @@ static void ext4_clear_journal_err(struct
super_block *sb,
 	j_errno =3D jbd2_journal_errno(journal);
 	if (j_errno) {
 		char nbuf[16];
+		char *buf1, *buf2;
+		unsigned long offset1, offset2;
+		int len1, len2;
+
+		/* copy message buffer from journal to super block */
+		buf1 =3D (char *)journal->j_superblock;
+		offset1 =3D (unsigned long)buf1 % sb->s_blocksize;
+		buf1 +=3D sizeof(journal_superblock_t);
+		offset1 +=3D sizeof(journal_superblock_t);
+		len1 =3D sb->s_blocksize - offset1;
+		buf2 =3D (char *)EXT4_SB(sb)->s_es;
+		offset2 =3D (unsigned long)buf2 % sb->s_blocksize;
+		buf2 +=3D sizeof(struct ext4_super_block);
+		offset2 +=3D sizeof(struct ext4_super_block);
+		len2 =3D sb->s_blocksize - offset2;
+		if (len2 > len1)
+			len2 =3D len1;
+		if (len2 > 0 && *buf1)
+			memcpy(buf2, buf1, len2);

 		errstr =3D ext4_decode_error(sb, j_errno, nbuf);
 		ext4_warning(sb, "Filesystem error recorded "
 			     "from previous mount: %s", errstr);
 		ext4_warning(sb, "Marking fs in need of filesystem check.");

+		/* clear journal message buffer */
+		if (len1 > 0)
+			memset(buf1, 0, len1);
+
 		EXT4_SB(sb)->s_mount_state |=3D EXT4_ERROR_FS;
 		es->s_state |=3D cpu_to_le16(EXT4_ERROR_FS);
 		ext4_commit_super(sb, 1);

--0016361e7dc6dba9fe0498e1f78c
Content-Type: application/octet-stream;
	name="e2fsck_display_message_buffer.patch"
Content-Disposition: attachment;
	filename="e2fsck_display_message_buffer.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gigbnc7j0

ZTJmc2NrOiBkaXNwbGF5IHJlY29yZGVkIGVycm9yIG1lc3NhZ2VzCgpFeHQ0IGVycm9yIG1lc3Nh
Z2VzIGFyZSByZWNvcmRlZCBpbiBhIDJLIG1lc3NhZ2UgYnVmZmVyIGFmdGVyIHRoZQpqb3VybmFs
IHN1cGVyIGJsb2NrLiAgQWZ0ZXIgam91cm5hbCByZWNvdmVyeSwgdGhlIGpvdXJuYWwgbWVzc2Fn
ZSBidWZmZXIKaXMgY29waWVkIHRvIHRoZSBmaWxlIHN5c3RlbSBtZXNzYWdlIGJ1ZmZlci4gIE9u
IGZzY2ssIGlmIHRoZSBtZXNzYWdlCmJ1ZmZlciBpcyBub3QgZW1wdHksIHRoZSByZWNvcmRlZCBt
ZXNzYWdlcyBhcmUgcHJpbnRlZCB0byBzdGRvdXQgYW5kCnRoZSBidWZmZXIgaXMgY2xlYXJlZC4K
ClNpZ25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEB1c2Vycy5zZi5uZXQ+Cgpk
aWZmIC1OdWFycCBhL2UyZnNjay9qb3VybmFsLmMgYi9lMmZzY2svam91cm5hbC5jCi0tLSBhL2Uy
ZnNjay9qb3VybmFsLmMJMjAxMC0xMi0yNyAxOTozNDoyNi4wMDAwMDAwMDAgKzAyMDAKKysrIGIv
ZTJmc2NrL2pvdXJuYWwuYwkyMDEwLTEyLTI3IDE5OjM0OjI1LjAwMDAwMDAwMCArMDIwMApAQCAt
ODM3LDYgKzgzNywyMCBAQCBzdGF0aWMgZXJyY29kZV90IHJlY292ZXJfZXh0M19qb3VybmFsKGUy
CiAKIAogCWlmIChqb3VybmFsLT5qX3N1cGVyYmxvY2stPnNfZXJybm8pIHsKKwkJLyogam91cm5h
bCBtZXNzYWdlIGJ1ZmZlciBhdCBqb3VybmFsIHN1cGVyIGJsb2NrICsgMUsgKi8KKwkJY2hhciAq
YnVmID0gKChjaGFyICopIGpvdXJuYWwtPmpfc3VwZXJibG9jaykgKworCQkJU1VQRVJCTE9DS19P
RkZTRVQ7CisJCWludCBsZW4gPSBjdHgtPmZzLT5ibG9ja3NpemUgLSAyKlNVUEVSQkxPQ0tfT0ZG
U0VUOworCisJCWlmIChsZW4gPj0gMipTVVBFUkJMT0NLX09GRlNFVCAmJiAqYnVmKSB7CisJCQkv
KiB3cml0ZSBqb3VybmFsIG1lc3NhZ2UgYnVmZmVyIHRvIHN1cGVyIGJsb2NrICsgMksgKi8KKwkJ
CWlvX2NoYW5uZWxfc2V0X2Jsa3NpemUoY3R4LT5mcy0+aW8sIFNVUEVSQkxPQ0tfT0ZGU0VUKTsK
KwkJCXJldHZhbCA9IGlvX2NoYW5uZWxfd3JpdGVfYmxrKGN0eC0+ZnMtPmlvLCAyLCAyLCBidWYp
OworCQkJaW9fY2hhbm5lbF9zZXRfYmxrc2l6ZShjdHgtPmZzLT5pbywgY3R4LT5mcy0+YmxvY2tz
aXplKTsKKwkJCS8qIGNsZWFyIGpvdXJuYWwgbWVzc2FnZSBidWZmZXIgKi8KKwkJCW1lbXNldChi
dWYsIDAsIGxlbik7CisJCX0KKwogCQljdHgtPmZzLT5zdXBlci0+c19zdGF0ZSB8PSBFWFQyX0VS
Uk9SX0ZTOwogCQlleHQyZnNfbWFya19zdXBlcl9kaXJ0eShjdHgtPmZzKTsKIAkJam91cm5hbC0+
al9zdXBlcmJsb2NrLT5zX2Vycm5vID0gMDsKZGlmZiAtTnVhcnAgYS9lMmZzY2svc3VwZXIuYyBi
L2UyZnNjay9zdXBlci5jCi0tLSBhL2UyZnNjay9zdXBlci5jCTIwMTAtMTItMjcgMTk6MzQ6MjYu
MDAwMDAwMDAwICswMjAwCisrKyBiL2UyZnNjay9zdXBlci5jCTIwMTAtMTItMjcgMTk6MzQ6MjUu
MDAwMDAwMDAwICswMjAwCkBAIC02NzIsNiArNjcyLDQzIEBAIHN0YXRpYyB2b2lkIGUyZnNja19m
aXhfZGlyaGFzaF9oaW50KGUyZnMKIAl9CiB9CiAKKy8qCisgKiBUaGlzIGZ1bmN0aW9uIHByaW50
cyB0aGUgbWVzc2FnZSBidWZmZXIgYXQgdGhlIGVuZCBvZiBzdXBlciBibG9jay4KKyAqLworc3Rh
dGljIHZvaWQgZTJmc2NrX3ByaW50X21lc3NhZ2VfYnVmZmVyKGUyZnNja190IGN0eCkKK3sKKwlj
aGFyICpidWY7CisJaW50IGxlbiA9IGN0eC0+ZnMtPmJsb2Nrc2l6ZSAtIDIqU1VQRVJCTE9DS19P
RkZTRVQ7CisJdW5zaWduZWQgb2Zmc2V0ID0gMDsKKwlpbnQgcmV0dmFsOworI2RlZmluZSBNU0dM
RU4gMjU2CisKKwlpZiAobGVuIDwgMipTVVBFUkJMT0NLX09GRlNFVCkKKwkJcmV0dXJuOworCisJ
YnVmID0gKGNoYXIgKikgZTJmc2NrX2FsbG9jYXRlX21lbW9yeShjdHgsIGxlbiwgIm1lc3NhZ2Ug
YnVmZmVyIik7CisKKwlpb19jaGFubmVsX3NldF9ibGtzaXplKGN0eC0+ZnMtPmlvLCBTVVBFUkJM
T0NLX09GRlNFVCk7CisJLyogcmVhZCBtZXNzYWdlIGJ1ZmZlciBmcm9tIHN1cGVyIGJsb2NrICsg
MksgKi8KKwlyZXR2YWwgPSBpb19jaGFubmVsX3JlYWRfYmxrKGN0eC0+ZnMtPmlvLCAyLCAyLCBi
dWYpOworCWlmIChyZXR2YWwgfHwgISpidWYpCisJCWdvdG8gb3V0OworCisJLyogcHJpbnQgbWVz
c2FnZXMgaW4gYnVmZmVyICovCisJcHV0cygiRXJyb3IgbWVzc2FnZXMgcmVjb3JkZWQgaW4gbWVz
c2FnZSBidWZmZXI6Iik7CisJd2hpbGUgKG9mZnNldCA8IGxlbiAmJiBidWZbb2Zmc2V0XSkgewor
CQlmcHV0cyhidWYrb2Zmc2V0LCBzdGRvdXQpOworCQlvZmZzZXQgKz0gTVNHTEVOOworCX0KKwkv
KiBjbGVhciBtZXNzYWdlIGJ1ZmZlciAqLworCW1lbXNldChidWYsIDAsIGxlbik7CisJcmV0dmFs
ID0gaW9fY2hhbm5lbF93cml0ZV9ibGsoY3R4LT5mcy0+aW8sIDIsIDIsIGJ1Zik7CisJcHV0cygi
RW5kIG9mIG1lc3NhZ2UgYnVmZmVyLiIpOworb3V0OgorCWlvX2NoYW5uZWxfc2V0X2Jsa3NpemUo
Y3R4LT5mcy0+aW8sIGN0eC0+ZnMtPmJsb2Nrc2l6ZSk7CisJZXh0MmZzX2ZyZWVfbWVtKCZidWYp
OworfQorCiAKIHZvaWQgY2hlY2tfc3VwZXJfYmxvY2soZTJmc2NrX3QgY3R4KQogewpAQCAtMTA5
MSw2ICsxMTI4LDExIEBAIHZvaWQgY2hlY2tfc3VwZXJfYmxvY2soZTJmc2NrX3QgY3R4KQogCSAq
LwogCWUyZnNja19maXhfZGlyaGFzaF9oaW50KGN0eCk7CiAKKwkvKgorCSAqIFByaW50IG1lc3Nh
Z2UgYnVmZmVyIGlmIG5lY2Vzc2FyeQorCSAqLworCWUyZnNja19wcmludF9tZXNzYWdlX2J1ZmZl
cihjdHgpOworCiAJcmV0dXJuOwogfQogCg==
--0016361e7dc6dba9fe0498e1f78c
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
--0016361e7dc6dba9fe0498e1f78c--
