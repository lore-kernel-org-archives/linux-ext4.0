From: "jon ernst" <jonernst07@gmx.com>
Subject: [PATCH] ext4: deleted unnecessary assignments and useless "if"
 statement
Date: Thu, 20 Jun 2013 01:44:56 -0400
Message-ID: <20130620054456.271300@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:62971 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3FTFo5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 01:44:57 -0400
Received: from mailout-us.gmx.com ([172.19.198.48]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0M9HDu-1V180F17L4-00CfwS for
 <linux-ext4@vger.kernel.org>; Thu, 20 Jun 2013 07:44:57 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

comparing unsigned variable with 0 always return false.
err =3D 0 is duplicated and unnecessary.

Signed-off-by: "Jon Ernst" <jonernst07@gmx.com>

--- a/fs/ext4/inode.c =C2=A0 =C2=A0=20
+++ b/fs/ext4/inode.c =C2=A0 =C2=A0=20
@@ -1098,8 +1098,6 @@ static int ext4_write_end(struct file *f
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (i_size_changed)
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_mark_inode=
_dirty(handle, inode);

- =C2=A0 =C2=A0 =C2=A0 if (copied < 0)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D copied;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pos + len > inode->i_size && ext4_can_t=
runcate(inode))
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* if we have a=
llocated more blocks and copied
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * less. We wil=
l have blocks allocated outside
@@ -3365,7 +3363,6 @@ int ext4_block_zero_page_range(handle_t
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pos +=3D blocks=
ize;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

- =C2=A0 =C2=A0 =C2=A0 err =3D 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (buffer_freed(bh)) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUFFER_TRACE(bh=
, "freed: skip");
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock;
@@ -3405,7 +3402,6 @@ int ext4_block_zero_page_range(handle_t

 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUFFER_TRACE(bh, "zeroed end of block");

- =C2=A0 =C2=A0 =C2=A0 err =3D 0;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext4_should_journal_data(inode)) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D ext4_ha=
ndle_dirty_metadata(handle, inode, bh);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
