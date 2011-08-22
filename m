From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: e2p_blocks_count () vs. ext2fs_blocks_count ()
Date: Mon, 22 Aug 2011 10:25:19 +0700
Message-ID: <864o1at9eo.fsf@gray.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55919 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1HVDZe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Aug 2011 23:25:34 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QvL8m-0006qt-Pw
	for linux-ext4@vger.kernel.org; Mon, 22 Aug 2011 05:25:32 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 05:25:32 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 05:25:32 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	Apparently, e2p_blocks_count (), a =E2=80=98static=E2=80=99 function i=
n
	lib/e2p/ls.c, duplicates the public ext2fs_blocks_count () one
	(lib/ext2fs/blknum.c) as of d4c0d8e5.  The same holds for
	e2p_r_blocks_count () and e2p_free_blocks_count ().

	The code is, as it seems, exactly the same.

	I wonder, isn't there a problem?

	TIA.

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
