From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/6] RFC: introduce extended inode owner identifier v8
Date: Sun,  2 Oct 2011 23:44:36 +0400
Message-ID: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1JBTlO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, I've updated old standing project quota id patch-set.
Please take a look at it and replay me your opinion, especially if you
do not like it by some reason :) This is really important because i do
want this feature to be merged sooner or later.

*Feature description*
1) Inode may has a project identifier which has same meaning as uid/gid.
2) Id is stored in inode's xattr named "system.project_id"
3) Id is inherent from parent inode on creation.
4) This id is cached in memory fs_inode structure and may be accessible
   via s_op->get_prjid(). This field it restricted by CONFIG_PROJECT_ID.
   So no wasting of memory happens.

5) Since id is cached in memory it may be used for different purposes
   such as:
5A) Implement additional quota id space orthogonal to uid/gid. This is
    useful in managing quota for some filesystem hierarchy(chroot or
    container over bindmount)

*User interface *
Project id is managed via generic xattr interface "system.project_id"
This good because
 1) We may use already existing interface.
 2) xattr already supported by generic utilities tar/rsync and etc

PATCH SET TOC:
1) generic projectid support
2) generic project quota support
3) ext4: small mount flags cleanup
4) ext4 project support implementation
 4A) ext4: generic project support
 4B) ext4: project quota support

Patch against 3.1.0-rc8-next-20110930
Actually vfs part is really small, and most changes happen in ext4-tree

Changes against V7
 - Small fix for project switch error path
 - Remove usless macro expressions
Changes against v6
 - get rid of iattr stuff, current __dquot_transfer() provides sane interface
   for quota manipulation. i_prjid can must be changed only by fs-speciffic
   methods so only get() method is really necessery.
 - remove #ifdef tricks from generic code.
 - move i_prjid from vfs_inode to fs_inode, to prevent inode bloating.
 - get rid of isolation logic, because this feature confuse most users.
Changes against v5
 - convert dquota_transfer to struct iattr interface. Not it is possible
   to change i_prjid via notify_changes()
 - some bugfixes.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
