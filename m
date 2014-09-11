From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: possible different donor file naming in e4defrag
Date: Thu, 11 Sep 2014 19:03:41 -0400
Message-ID: <BAY179-W439C9EFFCA6CA9A7C99DF8FDCC0@phx.gbl>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>,<20140815203909.GM2808@birch.djwong.org>,<BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>,<BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>,<25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>,<BAY179-W1E8676C4343760B6A8332FDCC0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_6f6e5a61-6dba-4d63-bfb2-92c404d6c30c_"
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc3s2.hotmail.com ([65.54.190.140]:61324 "EHLO
	BAY004-OMC3S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaIKXDm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 19:03:42 -0400
In-Reply-To: <BAY179-W1E8676C4343760B6A8332FDCC0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--_6f6e5a61-6dba-4d63-bfb2-92c404d6c30c_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

(attaching same=2C to fix whitespace...I suppose I should configure a prope=
r email client sometime)=0A=
=0A=
+Reardon=0A=
=0A=
=0A=
----------------------------------------=0A=
> From: thomas_reardon@hotmail.com=0A=
> To: adilger@dilger.ca=0A=
> CC: darrick.wong@oracle.com=3B linux-ext4@vger.kernel.org=0A=
> Subject: RE: possible different donor file naming in e4defrag=0A=
> Date: Thu=2C 11 Sep 2014 18:49:07 -0400=0A=
>=0A=
>> On Sep 11=2C 2014=2C at 1:48 PM=2C TR Reardon <thomas_reardon@hotmail.co=
m> wrote:=0A=
>>> Picking this back up. How would O_TMPFILE avoid races? It definitely av=
oids the unwanted mtime/atime update=2C but then the existing "<filename>.d=
efrag" pseudo-lock file would no longer be available. How could you use O_T=
MPFILE and still avoid multiple defrag? If this isn't possible=2C then rese=
tting the parent times on unlink(tmpfile)=2C as you suggest=2C is the simpl=
est way out of this.=0A=
>>=0A=
>> Looking at this the opposite way - what are the chances that there=0A=
>> will be concurrent defrags on the same file? Basically no chance at=0A=
>> all. So long as it doesn't explode (the kernel would need to protect=0A=
>> against this anyway to avoid malicious apps)=2C the worst case is that=
=0A=
>> there will be some extra defragmentation done in a very rare case.=0A=
>>=0A=
>> Conversely=2C creating a temporary filename and then resetting the=0A=
>> parent directory timestamp is extra work for every file defragmented=2C=
=0A=
>> and is racy because e4defrag may "reset" the time to before the temp=0A=
>> file was created=2C but clobber a legitimate timestamp update in the=0A=
>> directory from some other concurrent update. That timestamp update=0A=
>> is always going to be racy=2C even if e4defrag tries to be careful.=0A=
>>=0A=
>> Cheers=2C Andreas=0A=
>=0A=
>=0A=
> Thanks=2C well described.=0A=
>=0A=
> So a simple attempt with O_TMPFILE first=2C then revert to original behav=
ior=2C like below?=0A=
>=0A=
>=0A=
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c=0A=
> index d0eac60..8001182 100644=0A=
> --- a/misc/e4defrag.c=0A=
> +++ b/misc/e4defrag.c=0A=
> @@ -40=2C6 +40=2C7 @@=0A=
> #include <sys/stat.h>=0A=
> #include <sys/statfs.h>=0A=
> #include <sys/vfs.h>=0A=
> +#include <libgen.h>=0A=
>=0A=
> /* A relatively new ioctl interface ... */=0A=
> #ifndef EXT4_IOC_MOVE_EXT=0A=
> @@ -1526=2C31 +1527=2C36 @@ static int file_defrag(const char *file=2C co=
nst struct stat64 *buf=2C=0A=
>=0A=
> /* Create donor inode */=0A=
> memset(tmp_inode_name=2C 0=2C PATH_MAX + 8)=3B=0A=
> - sprintf(tmp_inode_name=2C "%.*s.defrag"=2C=0A=
> - (int)strnlen(file=2C PATH_MAX)=2C file)=3B=0A=
> - donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C S_=
IRUSR)=3B=0A=
> + /* Try O_TMPFILE first=2C to avoid changing directory mtime */=0A=
> + sprintf(tmp_inode_name=2C "%.*s"=2C (int)strnlen(file=2C PATH_MAX)=2C f=
ile)=3B=0A=
> + donor_fd =3D open64(dirname(tmp_inode_name)=2C O_TMPFILE | O_WRONLY | O=
_EXCL=2C S_IRUSR | S_IWUSR )=3B=0A=
> if (donor_fd < 0) {=0A=
> - if (mode_flag & DETAIL) {=0A=
> - PRINT_FILE_NAME(file)=3B=0A=
> - if (errno =3D=3D EEXIST)=0A=
> - PRINT_ERR_MSG_WITH_ERRNO(=0A=
> - "File is being defraged by other program")=3B=0A=
> - else=0A=
> - PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN)=3B=0A=
> + sprintf(tmp_inode_name=2C "%.*s.defrag"=2C=0A=
> + (int)strnlen(file=2C PATH_MAX)=2C file)=3B=0A=
> + donor_fd =3D open64(tmp_inode_name=2C O_WRONLY | O_CREAT | O_EXCL=2C S_=
IRUSR)=3B=0A=
> + if (donor_fd < 0) {=0A=
> + if (mode_flag & DETAIL) {=0A=
> + PRINT_FILE_NAME(file)=3B=0A=
> + if (errno =3D=3D EEXIST)=0A=
> + PRINT_ERR_MSG_WITH_ERRNO(=0A=
> + "File is being defraged by other program")=3B=0A=
> + else=0A=
> + PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN)=3B=0A=
> + }=0A=
> + goto out=3B=0A=
> }=0A=
> - goto out=3B=0A=
> - }=0A=
>=0A=
> - /* Unlink donor inode */=0A=
> - ret =3D unlink(tmp_inode_name)=3B=0A=
> - if (ret < 0) {=0A=
> - if (mode_flag & DETAIL) {=0A=
> - PRINT_FILE_NAME(file)=3B=0A=
> - PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B=0A=
> + /* Unlink donor inode */=0A=
> + ret =3D unlink(tmp_inode_name)=3B=0A=
> + if (ret < 0) {=0A=
> + if (mode_flag & DETAIL) {=0A=
> + PRINT_FILE_NAME(file)=3B=0A=
> + PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink")=3B=0A=
> + }=0A=
> + goto out=3B=0A=
> }=0A=
> - goto out=3B=0A=
> }=0A=
> -=0A=
> +=0A=
> /* Allocate space for donor inode */=0A=
> orig_group_tmp =3D orig_group_head=3B=0A=
> do {=0A=
>=0A=
> --=0A=
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in=
=0A=
> the body of a message to majordomo@vger.kernel.org=0A=
> More majordomo info at http://vger.kernel.org/majordomo-info.html=0A=
 		 	   		  =

--_6f6e5a61-6dba-4d63-bfb2-92c404d6c30c_
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="DEFRAG_O_TMPFILE"

ZGlmZiAtLWdpdCBhL21pc2MvZTRkZWZyYWcuYyBiL21pc2MvZTRkZWZyYWcuYwppbmRleCBkMGVh
YzYwLi44MDAxMTgyIDEwMDY0NAotLS0gYS9taXNjL2U0ZGVmcmFnLmMKKysrIGIvbWlzYy9lNGRl
ZnJhZy5jCkBAIC00MCw2ICs0MCw3IEBACiAjaW5jbHVkZSA8c3lzL3N0YXQuaD4KICNpbmNsdWRl
IDxzeXMvc3RhdGZzLmg+CiAjaW5jbHVkZSA8c3lzL3Zmcy5oPgorI2luY2x1ZGUgPGxpYmdlbi5o
PgogCiAvKiBBIHJlbGF0aXZlbHkgbmV3IGlvY3RsIGludGVyZmFjZSAuLi4gKi8KICNpZm5kZWYg
RVhUNF9JT0NfTU9WRV9FWFQKQEAgLTE1MjYsMzEgKzE1MjcsMzYgQEAgc3RhdGljIGludCBmaWxl
X2RlZnJhZyhjb25zdCBjaGFyICpmaWxlLCBjb25zdCBzdHJ1Y3Qgc3RhdDY0ICpidWYsCiAKIAkv
KiBDcmVhdGUgZG9ub3IgaW5vZGUgKi8KIAltZW1zZXQodG1wX2lub2RlX25hbWUsIDAsIFBBVEhf
TUFYICsgOCk7Ci0Jc3ByaW50Zih0bXBfaW5vZGVfbmFtZSwgIiUuKnMuZGVmcmFnIiwKLQkJCQko
aW50KXN0cm5sZW4oZmlsZSwgUEFUSF9NQVgpLCBmaWxlKTsKLQlkb25vcl9mZCA9IG9wZW42NCh0
bXBfaW5vZGVfbmFtZSwgT19XUk9OTFkgfCBPX0NSRUFUIHwgT19FWENMLCBTX0lSVVNSKTsKKwkv
KiBUcnkgT19UTVBGSUxFIGZpcnN0LCB0byBhdm9pZCBjaGFuZ2luZyBkaXJlY3RvcnkgbXRpbWUg
Ki8KKwlzcHJpbnRmKHRtcF9pbm9kZV9uYW1lLCAiJS4qcyIsIChpbnQpc3RybmxlbihmaWxlLCBQ
QVRIX01BWCksIGZpbGUpOworCWRvbm9yX2ZkID0gb3BlbjY0KGRpcm5hbWUodG1wX2lub2RlX25h
bWUpLCBPX1RNUEZJTEUgfCBPX1dST05MWSB8IE9fRVhDTCwgU19JUlVTUiB8IFNfSVdVU1IgKTsK
IAlpZiAoZG9ub3JfZmQgPCAwKSB7Ci0JCWlmIChtb2RlX2ZsYWcgJiBERVRBSUwpIHsKLQkJCVBS
SU5UX0ZJTEVfTkFNRShmaWxlKTsKLQkJCWlmIChlcnJubyA9PSBFRVhJU1QpCi0JCQkJUFJJTlRf
RVJSX01TR19XSVRIX0VSUk5PKAotCQkJCSJGaWxlIGlzIGJlaW5nIGRlZnJhZ2VkIGJ5IG90aGVy
IHByb2dyYW0iKTsKLQkJCWVsc2UKLQkJCQlQUklOVF9FUlJfTVNHX1dJVEhfRVJSTk8oTkdNU0df
RklMRV9PUEVOKTsKKwkJc3ByaW50Zih0bXBfaW5vZGVfbmFtZSwgIiUuKnMuZGVmcmFnIiwKKwkJ
CQkJKGludClzdHJubGVuKGZpbGUsIFBBVEhfTUFYKSwgZmlsZSk7CisJCWRvbm9yX2ZkID0gb3Bl
bjY0KHRtcF9pbm9kZV9uYW1lLCBPX1dST05MWSB8IE9fQ1JFQVQgfCBPX0VYQ0wsIFNfSVJVU1Ip
OworCQlpZiAoZG9ub3JfZmQgPCAwKSB7CisJCQlpZiAobW9kZV9mbGFnICYgREVUQUlMKSB7CisJ
CQkJUFJJTlRfRklMRV9OQU1FKGZpbGUpOworCQkJCWlmIChlcnJubyA9PSBFRVhJU1QpCisJCQkJ
CVBSSU5UX0VSUl9NU0dfV0lUSF9FUlJOTygKKwkJCQkJIkZpbGUgaXMgYmVpbmcgZGVmcmFnZWQg
Ynkgb3RoZXIgcHJvZ3JhbSIpOworCQkJCWVsc2UKKwkJCQkJUFJJTlRfRVJSX01TR19XSVRIX0VS
Uk5PKE5HTVNHX0ZJTEVfT1BFTik7CisJCQl9CisJCQlnb3RvIG91dDsKIAkJfQotCQlnb3RvIG91
dDsKLQl9CiAKLQkvKiBVbmxpbmsgZG9ub3IgaW5vZGUgKi8KLQlyZXQgPSB1bmxpbmsodG1wX2lu
b2RlX25hbWUpOwotCWlmIChyZXQgPCAwKSB7Ci0JCWlmIChtb2RlX2ZsYWcgJiBERVRBSUwpIHsK
LQkJCVBSSU5UX0ZJTEVfTkFNRShmaWxlKTsKLQkJCVBSSU5UX0VSUl9NU0dfV0lUSF9FUlJOTygi
RmFpbGVkIHRvIHVubGluayIpOworCQkvKiBVbmxpbmsgZG9ub3IgaW5vZGUgKi8KKwkJcmV0ID0g
dW5saW5rKHRtcF9pbm9kZV9uYW1lKTsKKwkJaWYgKHJldCA8IDApIHsKKwkJCWlmIChtb2RlX2Zs
YWcgJiBERVRBSUwpIHsKKwkJCQlQUklOVF9GSUxFX05BTUUoZmlsZSk7CisJCQkJUFJJTlRfRVJS
X01TR19XSVRIX0VSUk5PKCJGYWlsZWQgdG8gdW5saW5rIik7CisJCQl9CisJCQlnb3RvIG91dDsK
IAkJfQotCQlnb3RvIG91dDsKIAl9Ci0KKwkKIAkvKiBBbGxvY2F0ZSBzcGFjZSBmb3IgZG9ub3Ig
aW5vZGUgKi8KIAlvcmlnX2dyb3VwX3RtcCA9IG9yaWdfZ3JvdXBfaGVhZDsKIAlkbyB7Cg==

--_6f6e5a61-6dba-4d63-bfb2-92c404d6c30c_--
