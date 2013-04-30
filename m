From: "Jon ERNST" <jonernst@gmx.com>
Subject: [ext4] extent tree es_len can be zero?
Date: Tue, 30 Apr 2013 00:59:19 -0400
Message-ID: <20130430045920.296280@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:55877 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3D3E7V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Apr 2013 00:59:21 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0MhAVJ-1UAiSH1cJd-00MOhT for
 <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 06:59:20 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi ,list,

extent tree es_len can be zero?
if we call ext4_es_end when es_len is zero, it will have problem.


diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 95796a1..49a8da2 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -108,7 +108,7 @@
 =C2=A0* =C2=A0 =C2=A0 tree are ordered by logical block no.
 =C2=A0*
 =C2=A0* =C2=A0 -- =C2=A0 =C2=A0 =C2=A0 =C2=A0operations on a extent st=
atus tree
- * =C2=A0 =C2=A0 There are three important operations on a delayed ext=
ent tree: find
+ * =C2=A0 =C2=A0 There are three important operations on a delayed ext=
ent tree: finding
 =C2=A0* =C2=A0 =C2=A0 next extent, adding a extent(a range of blocks) =
and removing a extent.
 =C2=A0*
 =C2=A0* =C2=A0 -- =C2=A0 =C2=A0 =C2=A0 =C2=A0race on a extent status t=
ree
@@ -195,7 +195,7 @@ static void ext4_es_print_tree(struct inode *inode)
=20
 static inline ext4_lblk_t ext4_es_end(struct extent_status *es)
 {
- =C2=A0 =C2=A0 =C2=A0 BUG_ON(es->es_lblk + es->es_len < es->es_lblk);
+ =C2=A0 =C2=A0 =C2=A0 BUG_ON(es->es_lblk + es->es_len <=3D es->es_lblk=
);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0return es->es_lblk + es->es_len - 1;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
