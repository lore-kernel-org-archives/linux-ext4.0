From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] e2fsck: display recorded error messages
Date: Tue, 1 Mar 2011 07:34:02 +0200
Message-ID: <AANLkTinOEvBgmThmUGRL8Eo934_GH9phN6ZgQ-cCow=1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b8c96d680a4049d652427
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36909 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab1CAFeD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 00:34:03 -0500
Received: by qwd7 with SMTP id 7so3409291qwd.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 21:34:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016363b8c96d680a4049d652427
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ted,

This is the latest patch to go with
ext4: record error messages in message buffer 					=09

Amir.


---------- Forwarded message ----------
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, Jan 8, 2011 at 10:06 PM
Subject: Re: Regular ext4 error warning with HD in USB dock
To: Ted Ts'o <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Ric Wheeler <rwheeler@redhat.com>, Con Kolivas
<kernel@kolivas.org>, adilger.kernel@dilger.ca,
linux-ext4@vger.kernel.org


On Sat, Jan 8, 2011 at 10:05 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrot=
e:
> On Fri, Jan 07, 2011 at 11:07:23PM +0200, Amir Goldstein wrote:
>> On Fri, Jan 7, 2011 at 9:41 PM, Amir Goldstein <amir73il@gmail.com> wrot=
e:
>> > On Fri, Jan 7, 2011 at 7:26 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> >> Am I missing something? =A0The kernel stores up to 3k worth of data, =
on
>> >> a 4k block file system. =A0Whereas e2fsck patch blindly assume 2k wor=
hth
>> >> of data regardless of the block size. =A0The kernel patch looks ok, b=
ut
>> >> the e2fsprogs patch seems badly broken....
>>
>> So it's not badly broken, it copies blocksize-2K, which is clumsily
>> written like this:
>> + =A0 =A0 int len =3D ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;
>
> So this should be:
>
> =A0int len =3D ctx->fs->blocksize - SUPERBLOCK_OFFSET - sizeof (<superblo=
ck>);
>
> Although those two numbers are equal right now, there is no reason to
> assume that they will remain so in the future. So if the superblock
> size (or the offset) changes in the future, it's much better to have
> programmed this so that it will keep on working as opposed to getting
> to deal with ugly bugs in code that hasn't changed in years...
>

Very well, here is a less ugly version of the e2fsck patch:

e2fsck: display recorded error messages

Ext4 error messages are recorded in a message buffer after the
journal super block. =A0After journal recovery, the journal message buffer
is copied to the file system message buffer. =A0On fsck, if the message
buffer is not empty, the recorded messages are printed to stdout and
the buffer is cleared.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 93f685c..00d4d8f 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -837,6 +837,22 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)


=A0 =A0 =A0 =A0if (journal->j_superblock->s_errno) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* journal message buffer at journal super bl=
ock + 1K */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *buf =3D ((char *) journal->j_superblock=
) +
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SUPERBLOCK_OFFSET;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 int n, len =3D ctx->fs->blocksize - MSGBUF_OF=
FSET;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len >=3D MSGBUF_OFFSET && *buf) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* keep it simple - write in =
MSGBUF_OFFSET blocksize */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_channel_set_blksize(ctx->f=
s->io, MSGBUF_OFFSET);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n =3D len / MSGBUF_OFFSET;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write journal message buff=
er to super block + 2K */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D io_channel_write_b=
lk(ctx->fs->io, 1, n, buf);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_channel_set_blksize(ctx->f=
s->io, ctx->fs->blocksize);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear journal message buff=
er */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(buf, 0, len);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ctx->fs->super->s_state |=3D EXT2_ERROR_FS;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_mark_super_dirty(ctx->fs);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_superblock->s_errno =3D 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index b6923c6..f3274df 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -452,6 +452,45 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
=A0 =A0 =A0 =A0}
=A0}

+/*
+ * This function prints the message buffer at the end of super block.
+ */
+static void e2fsck_print_message_buffer(e2fsck_t ctx)
+{
+ =A0 =A0 =A0 char *buf;
+ =A0 =A0 =A0 int n, len =3D ctx->fs->blocksize - MSGBUF_OFFSET;
+ =A0 =A0 =A0 unsigned offset =3D 0;
+ =A0 =A0 =A0 int retval;
+
+ =A0 =A0 =A0 if (len < MSGBUF_OFFSET)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 1K or 2K fs->blocksize */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
+
+ =A0 =A0 =A0 buf =3D (char *) e2fsck_allocate_memory(ctx, len, "message bu=
ffer");
+
+ =A0 =A0 =A0 /* keep it simple - write in MSGBUF_OFFSET blocksize */
+ =A0 =A0 =A0 io_channel_set_blksize(ctx->fs->io, MSGBUF_OFFSET);
+ =A0 =A0 =A0 n =3D len / MSGBUF_OFFSET;
+ =A0 =A0 =A0 /* read message buffer from super block + 2K */
+ =A0 =A0 =A0 retval =3D io_channel_read_blk(ctx->fs->io, 1, n, buf);
+ =A0 =A0 =A0 if (retval || !*buf)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
+
+ =A0 =A0 =A0 /* print messages in buffer */
+ =A0 =A0 =A0 puts("Error messages recorded in message buffer:");
+ =A0 =A0 =A0 while (offset < len && buf[offset]) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 puts(buf+offset);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D MSGBUF_RECLEN;
+ =A0 =A0 =A0 }
+ =A0 =A0 =A0 /* clear message buffer */
+ =A0 =A0 =A0 memset(buf, 0, len);
+ =A0 =A0 =A0 retval =3D io_channel_write_blk(ctx->fs->io, 2, 2, buf);
+ =A0 =A0 =A0 puts("End of message buffer.");
+out:
+ =A0 =A0 =A0 io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize);
+ =A0 =A0 =A0 ext2fs_free_mem(&buf);
+}
+

=A0void check_super_block(e2fsck_t ctx)
=A0{
@@ -874,6 +913,11 @@ void check_super_block(e2fsck_t ctx)
=A0 =A0 =A0 =A0 */
=A0 =A0 =A0 =A0e2fsck_fix_dirhash_hint(ctx);

+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* Print message buffer if necessary
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 e2fsck_print_message_buffer(ctx);
+
=A0 =A0 =A0 =A0return;
=A0}

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a204eb7..5b73c2a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -38,6 +38,12 @@ extern "C" {
=A0*/
=A0#define SUPERBLOCK_OFFSET =A0 =A0 =A01024
=A0#define SUPERBLOCK_SIZE =A0 =A0 =A0 =A01024
+/*
+ * When blocksize > 2K, the space after the superblock is used as
+ * a buffer to record error messages (in 256 bytes records).
+ */
+#define MSGBUF_OFFSET =A0 =A0 =A0 =A0 =A0(SUPERBLOCK_OFFSET+SUPERBLOCK_SIZ=
E)
+#define MSGBUF_RECLEN =A0 =A0 =A0 =A0 =A0256

=A0/*
=A0* The last ext2fs revision level that this version of the library is

--0016363b8c96d680a4049d652427
Content-Type: application/octet-stream;
	name="e2fsck_display_message_buffer_v2.patch"
Content-Disposition: attachment;
	filename="e2fsck_display_message_buffer_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gioy5sf10

ZTJmc2NrOiBkaXNwbGF5IHJlY29yZGVkIGVycm9yIG1lc3NhZ2VzCgpFeHQ0IGVycm9yIG1lc3Nh
Z2VzIGFyZSByZWNvcmRlZCBpbiBhIG1lc3NhZ2UgYnVmZmVyIGFmdGVyIHRoZQpqb3VybmFsIHN1
cGVyIGJsb2NrLiAgQWZ0ZXIgam91cm5hbCByZWNvdmVyeSwgdGhlIGpvdXJuYWwgbWVzc2FnZSBi
dWZmZXIKaXMgY29waWVkIHRvIHRoZSBmaWxlIHN5c3RlbSBtZXNzYWdlIGJ1ZmZlci4gIE9uIGZz
Y2ssIGlmIHRoZSBtZXNzYWdlCmJ1ZmZlciBpcyBub3QgZW1wdHksIHRoZSByZWNvcmRlZCBtZXNz
YWdlcyBhcmUgcHJpbnRlZCB0byBzdGRvdXQgYW5kCnRoZSBidWZmZXIgaXMgY2xlYXJlZC4KClNp
Z25lZC1vZmYtYnk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEB1c2Vycy5zZi5uZXQ+CgpkaWZm
IC0tZ2l0IGEvZTJmc2NrL2pvdXJuYWwuYyBiL2UyZnNjay9qb3VybmFsLmMKaW5kZXggOTNmNjg1
Yy4uMDBkNGQ4ZiAxMDA2NDQKLS0tIGEvZTJmc2NrL2pvdXJuYWwuYworKysgYi9lMmZzY2svam91
cm5hbC5jCkBAIC04MzcsNiArODM3LDIyIEBAIHN0YXRpYyBlcnJjb2RlX3QgcmVjb3Zlcl9leHQz
X2pvdXJuYWwoZTJmc2NrX3QgY3R4KQogCiAKIAlpZiAoam91cm5hbC0+al9zdXBlcmJsb2NrLT5z
X2Vycm5vKSB7CisJCS8qIGpvdXJuYWwgbWVzc2FnZSBidWZmZXIgYXQgam91cm5hbCBzdXBlciBi
bG9jayArIDFLICovCisJCWNoYXIgKmJ1ZiA9ICgoY2hhciAqKSBqb3VybmFsLT5qX3N1cGVyYmxv
Y2spICsKKwkJCVNVUEVSQkxPQ0tfT0ZGU0VUOworCQlpbnQgbiwgbGVuID0gY3R4LT5mcy0+Ymxv
Y2tzaXplIC0gTVNHQlVGX09GRlNFVDsKKworCQlpZiAobGVuID49IE1TR0JVRl9PRkZTRVQgJiYg
KmJ1ZikgeworCQkJLyoga2VlcCBpdCBzaW1wbGUgLSB3cml0ZSBpbiBNU0dCVUZfT0ZGU0VUIGJs
b2Nrc2l6ZSAqLworCQkJaW9fY2hhbm5lbF9zZXRfYmxrc2l6ZShjdHgtPmZzLT5pbywgTVNHQlVG
X09GRlNFVCk7CisJCQluID0gbGVuIC8gTVNHQlVGX09GRlNFVDsKKwkJCS8qIHdyaXRlIGpvdXJu
YWwgbWVzc2FnZSBidWZmZXIgdG8gc3VwZXIgYmxvY2sgKyAySyAqLworCQkJcmV0dmFsID0gaW9f
Y2hhbm5lbF93cml0ZV9ibGsoY3R4LT5mcy0+aW8sIDEsIG4sIGJ1Zik7CisJCQlpb19jaGFubmVs
X3NldF9ibGtzaXplKGN0eC0+ZnMtPmlvLCBjdHgtPmZzLT5ibG9ja3NpemUpOworCQkJLyogY2xl
YXIgam91cm5hbCBtZXNzYWdlIGJ1ZmZlciAqLworCQkJbWVtc2V0KGJ1ZiwgMCwgbGVuKTsKKwkJ
fQorCiAJCWN0eC0+ZnMtPnN1cGVyLT5zX3N0YXRlIHw9IEVYVDJfRVJST1JfRlM7CiAJCWV4dDJm
c19tYXJrX3N1cGVyX2RpcnR5KGN0eC0+ZnMpOwogCQlqb3VybmFsLT5qX3N1cGVyYmxvY2stPnNf
ZXJybm8gPSAwOwpkaWZmIC0tZ2l0IGEvZTJmc2NrL3N1cGVyLmMgYi9lMmZzY2svc3VwZXIuYwpp
bmRleCBiNjkyM2M2Li5mMzI3NGRmIDEwMDY0NAotLS0gYS9lMmZzY2svc3VwZXIuYworKysgYi9l
MmZzY2svc3VwZXIuYwpAQCAtNDUyLDYgKzQ1Miw0NSBAQCBzdGF0aWMgdm9pZCBlMmZzY2tfZml4
X2Rpcmhhc2hfaGludChlMmZzY2tfdCBjdHgpCiAJfQogfQogCisvKgorICogVGhpcyBmdW5jdGlv
biBwcmludHMgdGhlIG1lc3NhZ2UgYnVmZmVyIGF0IHRoZSBlbmQgb2Ygc3VwZXIgYmxvY2suCisg
Ki8KK3N0YXRpYyB2b2lkIGUyZnNja19wcmludF9tZXNzYWdlX2J1ZmZlcihlMmZzY2tfdCBjdHgp
Cit7CisJY2hhciAqYnVmOworCWludCBuLCBsZW4gPSBjdHgtPmZzLT5ibG9ja3NpemUgLSBNU0dC
VUZfT0ZGU0VUOworCXVuc2lnbmVkIG9mZnNldCA9IDA7CisJaW50IHJldHZhbDsKKworCWlmIChs
ZW4gPCBNU0dCVUZfT0ZGU0VUKQorCQkvKiAxSyBvciAySyBmcy0+YmxvY2tzaXplICovCisJCXJl
dHVybjsKKworCWJ1ZiA9IChjaGFyICopIGUyZnNja19hbGxvY2F0ZV9tZW1vcnkoY3R4LCBsZW4s
ICJtZXNzYWdlIGJ1ZmZlciIpOworCisJLyoga2VlcCBpdCBzaW1wbGUgLSB3cml0ZSBpbiBNU0dC
VUZfT0ZGU0VUIGJsb2Nrc2l6ZSAqLworCWlvX2NoYW5uZWxfc2V0X2Jsa3NpemUoY3R4LT5mcy0+
aW8sIE1TR0JVRl9PRkZTRVQpOworCW4gPSBsZW4gLyBNU0dCVUZfT0ZGU0VUOworCS8qIHJlYWQg
bWVzc2FnZSBidWZmZXIgZnJvbSBzdXBlciBibG9jayArIDJLICovCisJcmV0dmFsID0gaW9fY2hh
bm5lbF9yZWFkX2JsayhjdHgtPmZzLT5pbywgMSwgbiwgYnVmKTsKKwlpZiAocmV0dmFsIHx8ICEq
YnVmKQorCQlnb3RvIG91dDsKKworCS8qIHByaW50IG1lc3NhZ2VzIGluIGJ1ZmZlciAqLworCXB1
dHMoIkVycm9yIG1lc3NhZ2VzIHJlY29yZGVkIGluIG1lc3NhZ2UgYnVmZmVyOiIpOworCXdoaWxl
IChvZmZzZXQgPCBsZW4gJiYgYnVmW29mZnNldF0pIHsKKwkJcHV0cyhidWYrb2Zmc2V0KTsKKwkJ
b2Zmc2V0ICs9IE1TR0JVRl9SRUNMRU47CisJfQorCS8qIGNsZWFyIG1lc3NhZ2UgYnVmZmVyICov
CisJbWVtc2V0KGJ1ZiwgMCwgbGVuKTsKKwlyZXR2YWwgPSBpb19jaGFubmVsX3dyaXRlX2Jsayhj
dHgtPmZzLT5pbywgMiwgMiwgYnVmKTsKKwlwdXRzKCJFbmQgb2YgbWVzc2FnZSBidWZmZXIuIik7
CitvdXQ6CisJaW9fY2hhbm5lbF9zZXRfYmxrc2l6ZShjdHgtPmZzLT5pbywgY3R4LT5mcy0+Ymxv
Y2tzaXplKTsKKwlleHQyZnNfZnJlZV9tZW0oJmJ1Zik7Cit9CisKIAogdm9pZCBjaGVja19zdXBl
cl9ibG9jayhlMmZzY2tfdCBjdHgpCiB7CkBAIC04NzQsNiArOTEzLDExIEBAIHZvaWQgY2hlY2tf
c3VwZXJfYmxvY2soZTJmc2NrX3QgY3R4KQogCSAqLwogCWUyZnNja19maXhfZGlyaGFzaF9oaW50
KGN0eCk7CiAKKwkvKgorCSAqIFByaW50IG1lc3NhZ2UgYnVmZmVyIGlmIG5lY2Vzc2FyeQorCSAq
LworCWUyZnNja19wcmludF9tZXNzYWdlX2J1ZmZlcihjdHgpOworCiAJcmV0dXJuOwogfQogCmRp
ZmYgLS1naXQgYS9saWIvZXh0MmZzL2V4dDJmcy5oIGIvbGliL2V4dDJmcy9leHQyZnMuaAppbmRl
eCBhMjA0ZWI3Li41YjczYzJhIDEwMDY0NAotLS0gYS9saWIvZXh0MmZzL2V4dDJmcy5oCisrKyBi
L2xpYi9leHQyZnMvZXh0MmZzLmgKQEAgLTM4LDYgKzM4LDEyIEBAIGV4dGVybiAiQyIgewogICov
CiAjZGVmaW5lIFNVUEVSQkxPQ0tfT0ZGU0VUCTEwMjQKICNkZWZpbmUgU1VQRVJCTE9DS19TSVpF
IAkxMDI0CisvKgorICogV2hlbiBibG9ja3NpemUgPiAySywgdGhlIHNwYWNlIGFmdGVyIHRoZSBz
dXBlcmJsb2NrIGlzIHVzZWQgYXMgCisgKiBhIGJ1ZmZlciB0byByZWNvcmQgZXJyb3IgbWVzc2Fn
ZXMgKGluIDI1NiBieXRlcyByZWNvcmRzKS4KKyAqLworI2RlZmluZSBNU0dCVUZfT0ZGU0VUIAkJ
KFNVUEVSQkxPQ0tfT0ZGU0VUK1NVUEVSQkxPQ0tfU0laRSkKKyNkZWZpbmUgTVNHQlVGX1JFQ0xF
TgkJMjU2CiAKIC8qCiAgKiBUaGUgbGFzdCBleHQyZnMgcmV2aXNpb24gbGV2ZWwgdGhhdCB0aGlz
IHZlcnNpb24gb2YgdGhlIGxpYnJhcnkgaXMK
--0016363b8c96d680a4049d652427--
