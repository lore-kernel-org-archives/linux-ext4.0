From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -V3 9/9] ext4: Fix lockdep recursive locking warning
Date: Fri, 7 Nov 2008 21:52:11 +0530
Message-ID: <20081107162211.GN25194@skywalker>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225997374-10846-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4913F698.30309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52593 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKGQ0J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 11:26:09 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA7GP6QJ024931
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 03:25:06 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7GMLql243990
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 03:22:22 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA7GML6i019814
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 03:22:21 +1100
Content-Disposition: inline
In-Reply-To: <4913F698.30309@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 04:04:40PM +0800, Li Zefan wrote:
> I got compile error on IA64:
>=20
> fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_add_groupinfo=E2=80=99=
:
> fs/ext4/mballoc.c:2482: error: implicit declaration of function =E2=80=
=98__init_rwsem=E2=80=99
>=20
>=20

Can you try this patch. I guess IA64 doesn't support lockdep

ext4: Fix lockdep recursive locking warning

=46rom: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Indicate that the group locks can be taken in loop.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f58de20..cb0ccbe 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2413,6 +2413,9 @@ ext4_mb_store_history(struct ext4_allocation_cont=
ext *ac)
 #define ext4_mb_history_init(sb)
 #endif
=20
+#ifdef CONFIG_LOCKDEP
+static struct lock_class_key alloc_sem_key[NR_BG_LOCKS];
+#endif
=20
 /* Create and initialize ext4_group_info data for the given group. */
 int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
@@ -2473,8 +2476,14 @@ int ext4_mb_add_groupinfo(struct super_block *sb=
, ext4_group_t group,
 	}
=20
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
-	init_rwsem(&meta_group_info[i]->alloc_sem);
+#ifdef CONFIG_LOCKDEP
+	__init_rwsem(&meta_group_info[i]->alloc_sem,
+			"&meta_group_info[i]->alloc_sem",
+			&alloc_sem_key[i]);
 	meta_group_info[i]->bb_free_root.rb_node =3D NULL;;
+#else
+	init_rwsem(&meta_group_info[i]->alloc_sem);
+#endif
=20
 #ifdef DOUBLE_CHECK
 	{
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
