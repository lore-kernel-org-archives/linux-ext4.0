From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/5] RFC: introduce extended inode owner identifier v6
Date: Thu, 18 Mar 2010 17:02:45 +0300
Message-ID: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	hch@infradead.org, jack@suse.cz, david@fromorbit.com,
	viro@ZenIV.linux.org.uk, xemul@openvz.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55608 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0CROC6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 10:02:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is 6'th version of extened inode owner patch-set.
Please review it tell me what do you think about all this.
 Are you agree with this approach?
 Are you worry about some implementation details?
 Is it ready for merge to some devel's tree?

*Feature description*
1) Inode may has a project identifier which has same meaning as uid/gid.
2) Id is stored in inode's xattr named "system.project_id"
3) Id is inherent from parent inode on creation.
4) This id is cached in memory inode structure vfs_inode->i_prjid
   This field it restricted by CONFIG_PROJECT_ID. So no wasting
   of memory happens.

5) Since id is cached in memory it may be used for different purposes
   such as:
5A) Implement additional quota id space orthogonal to uid/gid. This is
    useful in managing quota for some filesystem hierarchy(chroot or
    container over bindmount)
5B) Export dedicated fs hierarchy to nfsd (only inode which has some
    project_id will be accessible via nfsd)

6) It is possible to create isolated project's subtree.
   Note: Please do not blame isolation feature before you read the
         isolation patch description, and than please wellcome.

*User interface *
Project id is managed via generic xattr interface "system.project_id"
This good because
 1) We may use already existing interface.
 2) xattr already supported by generic urils tar/rsync and etc

PATCH SET TOC:
1) generic projectid support
2) generic project quota support
3) ext4 project support implementation
 3A) ext4: generic project support
 3B) ext4: project quota support
 3C) ext4: project isolation support. This patch is not principal
           but makes ext4 implementation rename behaviour equotals
	   to XFS

Patch against linux-next-20100318
Changes against v5
 - convert dquota_transfer to struct iattr interface. Not it is possible
   to change i_prjid via notify_changes()
 - some bugfixes.
