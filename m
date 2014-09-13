From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: possible different donor file naming in e4defrag
Date: Sat, 13 Sep 2014 16:23:55 -0400
Message-ID: <BAY179-W4808C28B05751CF895329AFDCA0@phx.gbl>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>,<20140815203909.GM2808@birch.djwong.org>,<BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>,<BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>,<25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>,<BAY179-W1E8676C4343760B6A8332FDCC0@phx.gbl>,<BAY179-W439C9EFFCA6CA9A7C99DF8FDCC0@phx.gbl>,<30D261EC-6B62-4A83-BA43-29DF560DF193@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_eaf0253c-5de2-4e0f-b0f8-68f4e023dc3f_"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc3s26.hotmail.com ([65.54.190.164]:60690 "EHLO
	BAY004-OMC3S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbaIMUX4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2014 16:23:56 -0400
In-Reply-To: <30D261EC-6B62-4A83-BA43-29DF560DF193@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_eaf0253c-5de2-4e0f-b0f8-68f4e023dc3f_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Subject: Re: possible different donor file naming in e4defrag
> From: adilger@dilger.ca
> Date: Fri=2C 12 Sep 2014 13:41:17 -0600
> CC: darrick.wong@oracle.com=3B linux-ext4@vger.kernel.org
> To: thomas_reardon@hotmail.com
>
> On Sep 11=2C 2014=2C at 5:03 PM=2C TR Reardon <thomas_reardon@hotmail.com=
> wrote:
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index d0eac60..8001182 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -1526=2C31 +1527=2C36 @@ static int file_defrag(const char *file=2C c=
onst struct stat64 *buf=2C
>>
>> /* Create donor inode */
>> memset(tmp_inode_name=2C 0=2C PATH_MAX + 8)=3B
>> - sprintf(tmp_inode_name=2C "%.*s.defrag"=2C
>> - (int)strnlen(file=2C PATH_MAX)=2C file)=3B
>> - donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C S=
_IRUSR)=3B
>> + /* Try O_TMPFILE first=2C to avoid changing directory mtime */
>> + sprintf(tmp_inode_name=2C "%.*s"=2C (int)strnlen(file=2C PATH_MAX)=2C =
file)=3B
>> + donor_fd =3D open64(dirname(tmp_inode_name)=2C O_TMPFILE | O_WRONLY | =
O_EXCL=2C S_IRUSR | S_IWUSR )=3B
>
> Lines need to be <=3D 80 columns. Please run patch through checkpatch.pl.
>
> Why is it opened O_WRONLY=2C but the permissions are S_IRUSR | S_IWUSR?
> I agree it didn't make sense in the old code to have S_IRUSR either=2C
> but I don't think this makes more sense. If the file is write-only
> (which is probably correct=2C unless e4defrag is doing some post-copy
> checksum of the data) then S_IWUSR would be enough.


I agree=2C wasn't sure if appropriate to change existing. I have changed in=
 updated.


>> if (donor_fd < 0) {
>> - if (mode_flag & DETAIL) {
>> - PRINT_FILE_NAME(file)=3B
>> - if (errno =3D=3D EEXIST)
>> - PRINT_ERR_MSG_WITH_ERRNO(
>> - "File is being defraged by other program")=3B
>> - else
>> - PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN)=3B
>> + sprintf(tmp_inode_name=2C "%.*s.defrag"=2C
>> + (int)strnlen(file=2C PATH_MAX)=2C file)=3B
>> + donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C S=
_IRUSR)=3B
>
> Wrap at 80 columns.
>
> This has the same issue with O_WRONLY and S_IRUSR=2C though it at least
> matches the old code.
>
>> + if (donor_fd < 0) {
>> + if (mode_flag & DETAIL) {
>> + PRINT_FILE_NAME(file)=3B
>> + if (errno =3D=3D EEXIST)
>> + PRINT_ERR_MSG_WITH_ERRNO(
>> + "File is being defraged by other program")=3B
>> + else
>> + PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN)=3B
>> + }
>> + goto out=3B
>> }
>> - goto out=3B
>> - }
>>
>> - /* Unlink donor inode */
>> - ret =3D unlink(tmp_inode_name)=3B
>> - if (ret < 0) {
>> - if (mode_flag & DETAIL) {
>> - PRINT_FILE_NAME(file)=3B
>> - PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B
>> + /* Unlink donor inode */
>> + ret =3D unlink(tmp_inode_name)=3B
>> + if (ret < 0) {
>> + if (mode_flag & DETAIL) {
>> + PRINT_FILE_NAME(file)=3B
>> + PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B
>> + }
>> + goto out=3B
>> }
>
> Shouldn't it reset the timestamp in this case?
>
> Cheers=2C Andreas


Oh=2C I thought you were arguing that it should collapse to only the O_TMPF=
ILE case to avoid unnecessary races. Updated handles it in both cases=2C bu=
t prefers O_TMPFILE.


(attached has proper whitespace)

--
Signed-off-by: TR Reardon <thomas_reardon@hotmail.com>
--
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index d0eac60..2facf44 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -40=2C6 +40=2C7 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 #include <sys/vfs.h>
+#include <libgen.h>

 /* A relatively new ioctl interface ... */
 #ifndef EXT4_IOC_MOVE_EXT
@@ -1408=2C6 +1409=2C8 @@ static int file_defrag(const char *file=2C const =
struct stat64 *buf=2C
 int file_frags_start=2C file_frags_end=3B
 int orig_physical_cnt=2C donor_physical_cnt =3D 0=3B
 char tmp_inode_name[PATH_MAX + 8]=3B
+ char *parent_name =3D NULL=3B
+ struct stat parent_stat=3B
 ext4_fsblk_t blk_count =3D 0=3B
 struct fiemap_extent_list *orig_list_physical =3D NULL=3B
 struct fiemap_extent_list *orig_list_logical =3D NULL=3B
@@ -1526=2C29 +1529=2C51 @@ static int file_defrag(const char *file=2C cons=
t struct stat64 *buf=2C

 /* Create donor inode */
 memset(tmp_inode_name=2C 0=2C PATH_MAX + 8)=3B
- sprintf(tmp_inode_name=2C "%.*s.defrag"=2C
- (int)strnlen(file=2C PATH_MAX)=2C file)=3B
- donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C S_IR=
USR)=3B
+ /* Try O_TMPFILE first=2C to avoid changing directory mtime */
+ sprintf(tmp_inode_name=2C "%.*s"=2C (int)strnlen(file=2C PATH_MAX)=2C fil=
e)=3B
+ parent_name =3D dirname(tmp_inode_name)=3B
+ donor_fd =3D open64(parent_name=2C O_WRONLY | O_TMPFILE | O_EXCL=2C S_IWU=
SR)=3B
 if (donor_fd < 0) {
- if (mode_flag & DETAIL) {
- PRINT_FILE_NAME(file)=3B
- if (errno =3D=3D EEXIST)
+ /* Save parent timestamps for reset */
+ ret =3D stat(parent_name=2C &parent_stat)=3B
+ if (ret < 0) {
+ if (mode_flag & DETAIL) {
+ PRINT_FILE_NAME(file)=3B
 PRINT_ERR_MSG_WITH_ERRNO(
- "File is being defraged by other program")=3B
- else
- PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN)=3B
+ "Failed to stat() parent directory")=3B
+ }
+ goto out=3B
 }
- goto out=3B
- }

- /* Unlink donor inode */
- ret =3D unlink(tmp_inode_name)=3B
- if (ret < 0) {
- if (mode_flag & DETAIL) {
- PRINT_FILE_NAME(file)=3B
- PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B
+ sprintf(tmp_inode_name=2C "%.*s.defrag"=2C
+ (int)strnlen(file=2C PATH_MAX)=2C file)=3B
+ donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C
+ S_IWUSR)=3B
+ if (donor_fd < 0) {
+ if (mode_flag & DETAIL) {
+ PRINT_FILE_NAME(file)=3B
+ if (errno =3D=3D EEXIST)
+ PRINT_ERR_MSG_WITH_ERRNO(
+ "File is being defraged by other program")=3B
+ else
+ PRINT_ERR_MSG_WITH_ERRNO(
+ NGMSG_FILE_OPEN)=3B
+ }
+ goto out=3B
 }
- goto out=3B
+
+ /* Unlink donor inode */
+ ret =3D unlink(tmp_inode_name)=3B
+ if (ret < 0) {
+ if (mode_flag & DETAIL) {
+ PRINT_FILE_NAME(file)=3B
+ PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B
+ }
+ goto out=3B
+ }
+
+ /* Reset parent times */
+ utimensat(0=2C parent_name=2C &parent_stat.st_atim=2C 0)=3B
 }

 /* Allocate space for donor inode */ 		 	   		  =

--_eaf0253c-5de2-4e0f-b0f8-68f4e023dc3f_
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="DEFRAG_O_TMPFILE_v2"

U2lnbmVkLW9mZi1ieTogVFIgUmVhcmRvbiA8dGhvbWFzX3JlYXJkb25AaG90bWFpbC5jb20+Ci0t
CmRpZmYgLS1naXQgYS9taXNjL2U0ZGVmcmFnLmMgYi9taXNjL2U0ZGVmcmFnLmMKaW5kZXggZDBl
YWM2MC4uMmZhY2Y0NCAxMDA2NDQKLS0tIGEvbWlzYy9lNGRlZnJhZy5jCisrKyBiL21pc2MvZTRk
ZWZyYWcuYwpAQCAtNDAsNiArNDAsNyBAQAogI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiAjaW5jbHVk
ZSA8c3lzL3N0YXRmcy5oPgogI2luY2x1ZGUgPHN5cy92ZnMuaD4KKyNpbmNsdWRlIDxsaWJnZW4u
aD4KIAogLyogQSByZWxhdGl2ZWx5IG5ldyBpb2N0bCBpbnRlcmZhY2UgLi4uICovCiAjaWZuZGVm
IEVYVDRfSU9DX01PVkVfRVhUCkBAIC0xNDA4LDYgKzE0MDksOCBAQCBzdGF0aWMgaW50IGZpbGVf
ZGVmcmFnKGNvbnN0IGNoYXIgKmZpbGUsIGNvbnN0IHN0cnVjdCBzdGF0NjQgKmJ1ZiwKIAlpbnQJ
ZmlsZV9mcmFnc19zdGFydCwgZmlsZV9mcmFnc19lbmQ7CiAJaW50CW9yaWdfcGh5c2ljYWxfY250
LCBkb25vcl9waHlzaWNhbF9jbnQgPSAwOwogCWNoYXIJdG1wX2lub2RlX25hbWVbUEFUSF9NQVgg
KyA4XTsKKwljaGFyCSpwYXJlbnRfbmFtZSA9IE5VTEw7CisJc3RydWN0IHN0YXQgcGFyZW50X3N0
YXQ7CiAJZXh0NF9mc2Jsa190CQkJYmxrX2NvdW50ID0gMDsKIAlzdHJ1Y3QgZmllbWFwX2V4dGVu
dF9saXN0CSpvcmlnX2xpc3RfcGh5c2ljYWwgPSBOVUxMOwogCXN0cnVjdCBmaWVtYXBfZXh0ZW50
X2xpc3QJKm9yaWdfbGlzdF9sb2dpY2FsID0gTlVMTDsKQEAgLTE1MjYsMjkgKzE1MjksNTEgQEAg
c3RhdGljIGludCBmaWxlX2RlZnJhZyhjb25zdCBjaGFyICpmaWxlLCBjb25zdCBzdHJ1Y3Qgc3Rh
dDY0ICpidWYsCiAKIAkvKiBDcmVhdGUgZG9ub3IgaW5vZGUgKi8KIAltZW1zZXQodG1wX2lub2Rl
X25hbWUsIDAsIFBBVEhfTUFYICsgOCk7Ci0Jc3ByaW50Zih0bXBfaW5vZGVfbmFtZSwgIiUuKnMu
ZGVmcmFnIiwKLQkJCQkoaW50KXN0cm5sZW4oZmlsZSwgUEFUSF9NQVgpLCBmaWxlKTsKLQlkb25v
cl9mZCA9IG9wZW42NCh0bXBfaW5vZGVfbmFtZSwgT19XUk9OTFkgfCBPX0NSRUFUIHwgT19FWENM
LCBTX0lSVVNSKTsKKwkvKiBUcnkgT19UTVBGSUxFIGZpcnN0LCB0byBhdm9pZCBjaGFuZ2luZyBk
aXJlY3RvcnkgbXRpbWUgKi8KKwlzcHJpbnRmKHRtcF9pbm9kZV9uYW1lLCAiJS4qcyIsIChpbnQp
c3RybmxlbihmaWxlLCBQQVRIX01BWCksIGZpbGUpOworCXBhcmVudF9uYW1lID0gZGlybmFtZSh0
bXBfaW5vZGVfbmFtZSk7CisJZG9ub3JfZmQgPSBvcGVuNjQocGFyZW50X25hbWUsIE9fV1JPTkxZ
IHwgT19UTVBGSUxFIHwgT19FWENMLCBTX0lXVVNSKTsKIAlpZiAoZG9ub3JfZmQgPCAwKSB7Ci0J
CWlmIChtb2RlX2ZsYWcgJiBERVRBSUwpIHsKLQkJCVBSSU5UX0ZJTEVfTkFNRShmaWxlKTsKLQkJ
CWlmIChlcnJubyA9PSBFRVhJU1QpCisJCS8qIFNhdmUgcGFyZW50IHRpbWVzdGFtcHMgZm9yIHJl
c2V0ICovCisJCXJldCA9IHN0YXQocGFyZW50X25hbWUsICZwYXJlbnRfc3RhdCk7CisJCWlmIChy
ZXQgPCAwKSB7CisJCQlpZiAobW9kZV9mbGFnICYgREVUQUlMKSB7CisJCQkJUFJJTlRfRklMRV9O
QU1FKGZpbGUpOwogCQkJCVBSSU5UX0VSUl9NU0dfV0lUSF9FUlJOTygKLQkJCQkiRmlsZSBpcyBi
ZWluZyBkZWZyYWdlZCBieSBvdGhlciBwcm9ncmFtIik7Ci0JCQllbHNlCi0JCQkJUFJJTlRfRVJS
X01TR19XSVRIX0VSUk5PKE5HTVNHX0ZJTEVfT1BFTik7CisJCQkJIkZhaWxlZCB0byBzdGF0KCkg
cGFyZW50IGRpcmVjdG9yeSIpOworCQkJfQorCQkJZ290byBvdXQ7CiAJCX0KLQkJZ290byBvdXQ7
Ci0JfQogCi0JLyogVW5saW5rIGRvbm9yIGlub2RlICovCi0JcmV0ID0gdW5saW5rKHRtcF9pbm9k
ZV9uYW1lKTsKLQlpZiAocmV0IDwgMCkgewotCQlpZiAobW9kZV9mbGFnICYgREVUQUlMKSB7Ci0J
CQlQUklOVF9GSUxFX05BTUUoZmlsZSk7Ci0JCQlQUklOVF9FUlJfTVNHX1dJVEhfRVJSTk8oIkZh
aWxlZCB0byB1bmxpbmsiKTsKKwkJc3ByaW50Zih0bXBfaW5vZGVfbmFtZSwgIiUuKnMuZGVmcmFn
IiwKKwkJCQkJKGludClzdHJubGVuKGZpbGUsIFBBVEhfTUFYKSwgZmlsZSk7CisJCWRvbm9yX2Zk
ID0gb3BlbjY0KHRtcF9pbm9kZV9uYW1lLCBPX1dST05MWSB8IE9fQ1JFQVQgfCBPX0VYQ0wsCisJ
CQkJCVNfSVdVU1IpOworCQlpZiAoZG9ub3JfZmQgPCAwKSB7CisJCQlpZiAobW9kZV9mbGFnICYg
REVUQUlMKSB7CisJCQkJUFJJTlRfRklMRV9OQU1FKGZpbGUpOworCQkJCWlmIChlcnJubyA9PSBF
RVhJU1QpCisJCQkJCVBSSU5UX0VSUl9NU0dfV0lUSF9FUlJOTygKKwkJCQkJIkZpbGUgaXMgYmVp
bmcgZGVmcmFnZWQgYnkgb3RoZXIgcHJvZ3JhbSIpOworCQkJCWVsc2UKKwkJCQkJUFJJTlRfRVJS
X01TR19XSVRIX0VSUk5PKAorCQkJCQkJTkdNU0dfRklMRV9PUEVOKTsKKwkJCX0KKwkJCWdvdG8g
b3V0OwogCQl9Ci0JCWdvdG8gb3V0OworCisJCS8qIFVubGluayBkb25vciBpbm9kZSAqLworCQly
ZXQgPSB1bmxpbmsodG1wX2lub2RlX25hbWUpOworCQlpZiAocmV0IDwgMCkgeworCQkJaWYgKG1v
ZGVfZmxhZyAmIERFVEFJTCkgeworCQkJCVBSSU5UX0ZJTEVfTkFNRShmaWxlKTsKKwkJCQlQUklO
VF9FUlJfTVNHX1dJVEhfRVJSTk8oIkZhaWxlZCB0byB1bmxpbmsiKTsKKwkJCX0KKwkJCWdvdG8g
b3V0OworCQl9CisKKwkJLyogUmVzZXQgcGFyZW50IHRpbWVzICovCisJCXV0aW1lbnNhdCgwLCBw
YXJlbnRfbmFtZSwgJnBhcmVudF9zdGF0LnN0X2F0aW0sIDApOwogCX0KIAogCS8qIEFsbG9jYXRl
IHNwYWNlIGZvciBkb25vciBpbm9kZSAqLwo=

--_eaf0253c-5de2-4e0f-b0f8-68f4e023dc3f_--
