From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 124651] ext4 bugon panic when I mmap a file
Date: Tue, 19 Jul 2016 01:39:03 +0000
Message-ID: <bug-124651-13602-8p0nfiWBQP@https.bugzilla.kernel.org/>
References: <bug-124651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbcGSBjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2016 21:39:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 148932022D
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2016 01:39:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E141C20220
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2016 01:39:03 +0000 (UTC)
In-Reply-To: <bug-124651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D124651

--- Comment #2 from wangguang <35445233@qq.com> ---
fs/ext4/inode.c:2263=EF=BC=9Ampage_prepare_extent_to_map=EF=BC=9A

          2261=EF=BC=9A        lblk =3D ((ext4_lblk_t)page->index) <<
                (PAGE_CACHE_SHIFT - blkbits);
          2263=EF=BC=9A        head =3D page_buffers(page);



EXT4 BUG_ON page_buffers() because a page goes to writeback without
buffer-heads attached.

I think unmap_page_range set the page dirty again Cause the problem=E3=80=
=82

I can recurrent the bug by:
=EF=BC=881=EF=BC=89 mmap a file=20
 addr =3D (char *)mmap(NULL, MAPLEN, PROT_READ|PROT_WRITE, MAP_SHARED, =
fd, 0);
 memset(addr, 'i', MAPLEN);
=EF=BC=882=EF=BC=89 return err at
ext4_writepages->mpage_map_and_submit_extent->mpage_map_one_extent  Cau=
se the
log:
        ext4_msg(sb, KERN_CRIT,
                 "Delayed block allocation failed for "
                 "inode %lu at logical offset %llu with"
                 " max blocks %u with error %d",
                 inode->i_ino,
                 (unsigned long long)map->m_lblk,
                 (unsigned)map->m_len, -err);

(3=EF=BC=89 Unmap case warning:
WARNING: at fs/buffer.c:661 __set_page_dirty+0xaa/0xc0()

(4) wait for sync=EF=BC=8Cthen bugon

see the attachment please.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
