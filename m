From: Boxi Liu <boxi10liu@gmail.com>
Subject: fix the ext4_read_inline_dir return value
Date: Tue, 22 Oct 2013 00:33:10 +0800
Message-ID: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c251ea00260c04e942d7c0
Cc: "lewis.liulei" <lewis.liulei@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>, "tm@tao.ma" <tm@tao.ma>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:42885 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3JUQdM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 12:33:12 -0400
Received: by mail-qe0-f53.google.com with SMTP id cy11so3929953qeb.26
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 09:33:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001a11c251ea00260c04e942d7c0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

hi=A3=AC
there may be a bug in ext4_read_inline_dir() function with inline_data feat=
ure.
when I recursion call a sys_old_readdir to read a direntry's
sub_dentry,I find that the ext4_read_inline_dir return the len of the
inline_data ,but in the no inline_data case,it will return 0.It is
inconsistent.
So I try to make a patch to fix it.

--001a11c251ea00260c04e942d7c0
Content-Type: application/octet-stream;
	name="0001-ext4-fix-the-ext4_read_inline_dir-return-value.patch"
Content-Disposition: attachment;
	filename="0001-ext4-fix-the-ext4_read_inline_dir-return-value.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hn1xaqbs0

RnJvbSAwZWNlMDY3ZmU4YTYwNTY2YTljM2Y2MzY0MjFlMjgwZTE3Mjc3MzA3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb3hpTGl1IDxsZXdpcy5saXVsZWlAaHVhd2VpLmNvbT4KRGF0
ZTogV2VkLCAxOCBTZXAgMjAxMyAwMTowNjo0MCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIAlleHQ0
OiBmaXggdGhlIGV4dDRfcmVhZF9pbmxpbmVfZGlyIHJldHVybiB2YWx1ZQoKCUluIGV4dDRfcmVh
ZF9pbmxuZV9kaXIsdGhlIHJldHVybiB2YWx1ZSBpcyB0aGUgcmV0dXJuCglvZiBleHQ0X3JlYWRf
aW5saW5lX2RhdGEgbGVuLkJ1dCBpbiBubyBpbmxpbmVfZGF0YSBjYXNlLAoJdGhlIHJldHVybiB2
YWx1ZSBpcyAwLGl0J3MgaW5jb25zaXN0ZW50LlNvIGZpeCB0aGUgcmV0dXJuCgl2YWx1ZSBvZiBl
eHQ0X3JlYWRfaW5saW5lX2Rpci4KClNpZ25lZC1vZmYtYnk6IEJveGlMaXUgPGxld2lzLmxpdWxl
aUBodWF3ZWkuY29tPgotLS0KIGZzL2V4dDQvaW5saW5lLmMgfCAxICsKIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvaW5saW5lLmMgYi9mcy9leHQ0
L2lubGluZS5jCmluZGV4IGQ5ZWNiZjEuLmMzZWZiNjUgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvaW5s
aW5lLmMKKysrIGIvZnMvZXh0NC9pbmxpbmUuYwpAQCAtMTQ0Miw2ICsxNDQyLDcgQEAgaW50IGV4
dDRfcmVhZF9pbmxpbmVfZGlyKHN0cnVjdCBmaWxlICpmaWxlLAogCWlmIChyZXQgPCAwKQogCQln
b3RvIG91dDsKIAorCXJldCA9IDA7CiAJc2IgPSBpbm9kZS0+aV9zYjsKIAlwYXJlbnRfaW5vID0g
bGUzMl90b19jcHUoKChzdHJ1Y3QgZXh0NF9kaXJfZW50cnlfMiAqKWRpcl9idWYpLT5pbm9kZSk7
CiAJb2Zmc2V0ID0gY3R4LT5wb3M7Ci0tIAoxLjguMS5tc3lzZ2l0LjEKCg==
--001a11c251ea00260c04e942d7c0--
