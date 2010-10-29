From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] RFC: introduce extended inode owner identifier v7
Date: Fri, 29 Oct 2010 17:03:36 +0400
Message-ID: <1288357420-7178-1-git-send-email-dmonakhov@openvz.org>
Cc: viro@ZenIV.linux.org.uk, jack@suse.cz, linux-ext4@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61064 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0J2NDx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 09:03:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
5B) Export dedicated fs hierarchy (only inode which has some project_id
    will be accessible)

*User interface *
Project id is managed via generic xattr interface "system.project_id"
This good because
 1) We may use already existing interface.
 2) xattr already supported by generic utilities tar/rsync and etc

PATCH SET TOC:
1) generic projectid support
2) generic project quota support
3) ext4 project support implementation
 3A) ext4: generic project support
 3B) ext4: project quota support

Patch against -next-20101028.
Actually vfs part is really small, and most changes happen in ext4-tree

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

