From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize
 var(eh) before using it
Date: Tue, 1 Nov 2011 11:31:36 +0800
Message-ID: <CAGBYx2ZVt1=QJFDuGrC6NxXkZtP-J51s=i9eh-zRYYx7GdcBrw@mail.gmail.com>
References: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org, Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1KADbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 23:31:37 -0400
Received: by gyb13 with SMTP id 13so6599615gyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 20:31:36 -0700 (PDT)
In-Reply-To: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

Sorry, Cc did not work in git.

Yongqiang.
---------- Forwarded message ----------
=46rom: Yongqiang Yang <xiaoqiangnk@gmail.com>
Date: Tue, Nov 1, 2011 at 9:21 AM
Subject: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize
var(eh) before using it
To: linux-ext4@vger.kernel.org
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>


ext4_ext_convert_to_initialized() does not initialize eh before using i=
t
and this is introduced in commit 864d21652.

Cc:Eric Gouriou <egouriou@google.com>
Cc:"Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---

Hi Eric,

Was that patch tested?

=A0fs/ext4/extents.c | =A0 =A01 +
=A01 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9dfdf8f..2798945 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2944,6 +2944,7 @@ static int
ext4_ext_convert_to_initialized(handle_t *handle,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0eof_block =3D map->m_lblk + map->m_len;

=A0 =A0 =A0 =A0depth =3D ext_depth(inode);
+ =A0 =A0 =A0 eh =3D path[depth].p_hdr;
=A0 =A0 =A0 =A0ex =3D path[depth].p_ext;
=A0 =A0 =A0 =A0ee_block =3D le32_to_cpu(ex->ee_block);
=A0 =A0 =A0 =A0ee_len =3D ext4_ext_get_actual_len(ex);
--
1.7.5.1




--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
