From: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Subject: [PATCH] EXT4: optimizing group serch for inode allocation
Date: Sat, 19 Dec 2015 05:02:56 +0530
Message-ID: <CAKJOkCr-O+37QfFFJgtkRUZfo_-U=qmYy=Ooc7oqtqcVrz1HWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1148f8621f296a0527348f17
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36413 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbLRXc6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2015 18:32:58 -0500
Received: by mail-wm0-f53.google.com with SMTP id p187so3843776wmp.1
        for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2015 15:32:57 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001a1148f8621f296a0527348f17
Content-Type: text/plain; charset=UTF-8

>From 9e09fef78b2fa552c883bf8124af873abfde0805 Mon Sep 17 00:00:00 2001
From: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>

Added a check at the start of group search loop to
avoid looping unecessarily in case of empty group.
This also allow group search to jump directly to
"found_flex_bg" with "stats" and "group" already set,
so there is no need to go through the extra steps of
setting "best_desc" and "best_group" and then break
out of the loop just to set "stats" and "group" again.

Signed-off-by: Lokesh N Jaliminche <lokesh.jaliminche@gmail.com>
---
 fs/ext4/ialloc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1b8024d..588bf8e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -446,6 +446,8 @@ static int find_group_orlov(struct super_block
*sb, struct inode *parent,
  struct ext4_sb_info *sbi = EXT4_SB(sb);
  ext4_group_t real_ngroups = ext4_get_groups_count(sb);
  int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
+ unsigned int inodes_per_flex_group;
+ long unsigned int blocks_per_clustre;
  unsigned int freei, avefreei, grp_free;
  ext4_fsblk_t freeb, avefreec;
  unsigned int ndirs;
@@ -470,6 +472,8 @@ static int find_group_orlov(struct super_block
*sb, struct inode *parent,
  percpu_counter_read_positive(&sbi->s_freeclusters_counter));
  avefreec = freeb;
  do_div(avefreec, ngroups);
+ inodes_per_flex_group = inodes_per_group * flex_size;
+ blocks_per_clustre = sbi->s_blocks_per_group * flex_size;
  ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);

  if (S_ISDIR(mode) &&
@@ -489,6 +493,10 @@ static int find_group_orlov(struct super_block
*sb, struct inode *parent,
  for (i = 0; i < ngroups; i++) {
  g = (parent_group + i) % ngroups;
  get_orlov_stats(sb, g, flex_size, &stats);
+ /* the group can't get any better than empty */
+ if (inodes_per_flex_group == stats.free_inodes &&
+ blocks_per_clustre == stats.free_clusters)
+ goto found_flex_bg;
  if (!stats.free_inodes)
  continue;
  if (stats.used_dirs >= best_ndir)
-- 
1.7.1

--001a1148f8621f296a0527348f17
Content-Type: application/octet-stream;
	name="0001-EXT4-optimizing-group-serch-for-inode-allocation.patch"
Content-Disposition: attachment;
	filename="0001-EXT4-optimizing-group-serch-for-inode-allocation.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iicb9fva0

RnJvbSA5ZTA5ZmVmNzhiMmZhNTUyYzg4M2JmODEyNGFmODczYWJmZGUwODA1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMb2tlc2ggTmFnYXBwYSBKYWxpbWluY2hlIDxsb2tlc2guamFs
aW1pbmNoZUBzZWFnYXRlLmNvbT4KRGF0ZTogU2F0LCAxOSBEZWMgMjAxNSAwMDozMzowNiArMDUz
MApTdWJqZWN0OiBbUEFUQ0hdIEVYVDQ6IG9wdGltaXppbmcgZ3JvdXAgc2VyY2ggZm9yIGlub2Rl
IGFsbG9jYXRpb24KCkFkZGVkIGEgY2hlY2sgYXQgdGhlIHN0YXJ0IG9mIGdyb3VwIHNlYXJjaCBs
b29wIHRvCmF2b2lkIGxvb3BpbmcgdW5lY2Vzc2FyaWx5IGluIGNhc2Ugb2YgZW1wdHkgZ3JvdXAu
ClRoaXMgYWxzbyBhbGxvdyBncm91cCBzZWFyY2ggdG8ganVtcCBkaXJlY3RseSB0bwoiZm91bmRf
ZmxleF9iZyIgd2l0aCAic3RhdHMiIGFuZCAiZ3JvdXAiIGFscmVhZHkgc2V0LApzbyB0aGVyZSBp
cyBubyBuZWVkIHRvIGdvIHRocm91Z2ggdGhlIGV4dHJhIHN0ZXBzIG9mCnNldHRpbmcgImJlc3Rf
ZGVzYyIgYW5kICJiZXN0X2dyb3VwIiBhbmQgdGhlbiBicmVhawpvdXQgb2YgdGhlIGxvb3AganVz
dCB0byBzZXQgInN0YXRzIiBhbmQgImdyb3VwIiBhZ2Fpbi4KClNpZ25lZC1vZmYtYnk6IExva2Vz
aCBOYWdhcHBhIEphbGltaW5jaGUgPGxva2VzaC5qYWxpbWluY2hlQGdtYWlsLmNvbT4KLS0tCiBm
cy9leHQ0L2lhbGxvYy5jIHwgICAgOCArKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9pYWxsb2MuYyBi
L2ZzL2V4dDQvaWFsbG9jLmMKaW5kZXggMWI4MDI0ZC4uNTg4YmY4ZSAxMDA2NDQKLS0tIGEvZnMv
ZXh0NC9pYWxsb2MuYworKysgYi9mcy9leHQ0L2lhbGxvYy5jCkBAIC00NDYsNiArNDQ2LDggQEAg
c3RhdGljIGludCBmaW5kX2dyb3VwX29ybG92KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVj
dCBpbm9kZSAqcGFyZW50LAogCXN0cnVjdCBleHQ0X3NiX2luZm8gKnNiaSA9IEVYVDRfU0Ioc2Ip
OwogCWV4dDRfZ3JvdXBfdCByZWFsX25ncm91cHMgPSBleHQ0X2dldF9ncm91cHNfY291bnQoc2Ip
OwogCWludCBpbm9kZXNfcGVyX2dyb3VwID0gRVhUNF9JTk9ERVNfUEVSX0dST1VQKHNiKTsKKwl1
bnNpZ25lZCBpbnQgaW5vZGVzX3Blcl9mbGV4X2dyb3VwOworCWxvbmcgdW5zaWduZWQgaW50IGJs
b2Nrc19wZXJfY2x1c3RyZTsKIAl1bnNpZ25lZCBpbnQgZnJlZWksIGF2ZWZyZWVpLCBncnBfZnJl
ZTsKIAlleHQ0X2ZzYmxrX3QgZnJlZWIsIGF2ZWZyZWVjOwogCXVuc2lnbmVkIGludCBuZGlyczsK
QEAgLTQ3MCw2ICs0NzIsOCBAQCBzdGF0aWMgaW50IGZpbmRfZ3JvdXBfb3Jsb3Yoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYiwgc3RydWN0IGlub2RlICpwYXJlbnQsCiAJCXBlcmNwdV9jb3VudGVyX3Jl
YWRfcG9zaXRpdmUoJnNiaS0+c19mcmVlY2x1c3RlcnNfY291bnRlcikpOwogCWF2ZWZyZWVjID0g
ZnJlZWI7CiAJZG9fZGl2KGF2ZWZyZWVjLCBuZ3JvdXBzKTsKKwlpbm9kZXNfcGVyX2ZsZXhfZ3Jv
dXAgPSBpbm9kZXNfcGVyX2dyb3VwICogZmxleF9zaXplOworCWJsb2Nrc19wZXJfY2x1c3RyZSA9
IHNiaS0+c19ibG9ja3NfcGVyX2dyb3VwICogZmxleF9zaXplOwogCW5kaXJzID0gcGVyY3B1X2Nv
dW50ZXJfcmVhZF9wb3NpdGl2ZSgmc2JpLT5zX2RpcnNfY291bnRlcik7CiAKIAlpZiAoU19JU0RJ
Uihtb2RlKSAmJgpAQCAtNDg5LDYgKzQ5MywxMCBAQCBzdGF0aWMgaW50IGZpbmRfZ3JvdXBfb3Js
b3Yoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0IGlub2RlICpwYXJlbnQsCiAJCWZvciAo
aSA9IDA7IGkgPCBuZ3JvdXBzOyBpKyspIHsKIAkJCWcgPSAocGFyZW50X2dyb3VwICsgaSkgJSBu
Z3JvdXBzOwogCQkJZ2V0X29ybG92X3N0YXRzKHNiLCBnLCBmbGV4X3NpemUsICZzdGF0cyk7CisJ
CQkvKiB0aGUgZ3JvdXAgY2FuJ3QgZ2V0IGFueSBiZXR0ZXIgdGhhbiBlbXB0eSAqLworCQkJaWYg
KGlub2Rlc19wZXJfZmxleF9ncm91cCA9PSBzdGF0cy5mcmVlX2lub2RlcyAmJgorCQkJCWJsb2Nr
c19wZXJfY2x1c3RyZSA9PSBzdGF0cy5mcmVlX2NsdXN0ZXJzKQorCQkJCQlnb3RvIGZvdW5kX2Zs
ZXhfYmc7CiAJCQlpZiAoIXN0YXRzLmZyZWVfaW5vZGVzKQogCQkJCWNvbnRpbnVlOwogCQkJaWYg
KHN0YXRzLnVzZWRfZGlycyA+PSBiZXN0X25kaXIpCi0tIAoxLjcuMQoK
--001a1148f8621f296a0527348f17--
