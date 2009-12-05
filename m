From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH][RFC] kjournald affinity patch
Date: Fri, 04 Dec 2009 17:08:34 -0700
Message-ID: <6CCA0618-5E60-42E2-B9B5-96B16185CB92@sun.com>
References: <58E055D0-728A-473F-857A-AC4ED7BAE759@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_dwFTMbb+6p1fsJYQF8RwKQ)"
Cc: Johann Lombardi <johann@sun.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38519 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbZLEAIa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 19:08:30 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB508acL009781
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 16:08:36 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KU500200KAAS700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 04 Dec 2009 16:08:36 -0800 (PST)
Received: from cabot-wlan.adilger.int ([unknown] [68.147.195.121])
 by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 with ESMTPSA id <0KU500NSMKEB3M80@fe-sfbay-10.sun.com> for
 linux-ext4@vger.kernel.org; Fri, 04 Dec 2009 16:08:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_dwFTMbb+6p1fsJYQF8RwKQ)
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-transfer-encoding: 7BIT

Per discussion on the ext4 concall, attached is a basic version of the  
journal affinity patch against an older kernel (2.6.10) and ext3, but  
looking at the patch it doesn't seem very dependent upon the ext3/ext4  
version at all and can probably be .

This defaults to enabling NUMA affinity if CONFIG_NUMA is enabled, so  
per our discussion it probably needs a mount option that will enable  
it only if specified.  We had discussed  
"journal_affinity={off,on,node#}" or "={none,auto,node#}" as  
possibilities.

Original patch was developed by someone at Bull (possibly even Johann,  
when he worked there), but I don't have the exact attribution.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--Boundary_(ID_dwFTMbb+6p1fsJYQF8RwKQ)
Content-type: application/octet-stream; name=kjournald-affinity.patch;
 x-unix-mode=0644
Content-transfer-encoding: QUOTED-PRINTABLE
Content-disposition: attachment; filename=kjournald-affinity.patch

--- linux-2.6.10.orig/fs/ext3/super.c=092004-12-24 22:35:28.000000000=
 +0100=0D=0A+++ linux-2.6.10/fs/ext3/super.c=092005-01-18 12:27:51.89=
6529310 +0100=0D=0A@@ -1787,6 +1787,32 @@=0D=0A =09return NULL;=0D=
=0A }=0D=0A =0D=0A+#ifdef CONFIG_NUMA=0D=0A+#include <linux/nodemask.=
h>=0D=0A+#include <asm/topology.h>=0D=0A+static int journal_node_affi=
nity =3D 0;=0D=0A+spinlock_t journal_node_affinity_lock =3D SPIN_LOCK=
_UNLOCKED;=0D=0A+static void ext3_bind_journal_thread(journal_t *jour=
nal)=0A+{=0D=0A+=09int i, node;=0D=0A+=0D=0A+=09spin_lock(&journal_no=
de_affinity_lock);=0D=0A+=09for (i =3D 0; i < MAX_NUMNODES; i++) {=
=0D=0A+=09=09node =3D (journal_node_affinity + i) % MAX_NUMNODES;=
=0D=0A+=0D=0A+=09=09if (!nr_cpus_node(node) || !node_online(node))=
=0D=0A+=09=09=09continue;=0D=0A+=0D=0A+=09=09set_cpus_allowed(journal=
->j_task, node_to_cpumask(node));=0D=0A+=09=09journal_node_affinity =
=3D (node + 1) % MAX_NUMNODES;=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=
=09spin_unlock(&journal_node_affinity_lock);=0D=0A+}=0A+#else=0A+#def=
ine ext3_bind_journal_thread(journal) do {} while(0)=0D=0A+#endif=
=0D=0A+=0D=0A static int ext3_load_journal(struct super_block * sb,=
=0D=0A =09=09=09     struct ext3_super_block * es)=0D=0A {=0D=0A@@ -1=
852,6 +1875,8 @@=0D=0A =09=09return err;=0D=0A =09}=0D=0A =0D=0A+=
=09ext3_bind_journal_thread(journal);=0D=0A+=0D=0A =09EXT3_SB(sb)->s_=
journal =3D journal;=0D=0A =09ext3_clear_journal_err(sb, es);=0D=0A =
=09return 0;=0D=0A@@ -1881,6 +1908,8 @@=0D=0A =09=09return -EIO;=0D=
=0A =09}=0D=0A =0D=0A+=09ext3_bind_journal_thread(journal);=0D=0A+=
=0D=0A =09EXT3_SB(sb)->s_journal =3D journal;=0D=0A =0D=0A =09ext3_up=
date_dynamic_rev(sb);=0D=0A=

--Boundary_(ID_dwFTMbb+6p1fsJYQF8RwKQ)--
