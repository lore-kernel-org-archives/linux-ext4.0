From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 00/11] [RFC] Introduce subtree quota support This patch set
 introduce subtree and subtree-quota support for ext4
Date: Mon, 08 Feb 2010 16:28:02 +0300
Message-ID: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33220 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0BHO20 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:26 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A subtree of a directory tree T is a tree consisting of a directory
(the subtree root) in T and all of its descendants in T.

Subtree assumptions:
* Each inode has subtree id.
* Subtree id is inherent from parent directory
* Inode can not belongs to different subtree

Subtree with id == 0 has special meaning. It may contains roots of
other subtrees (this feature is used for cross subtree renames)
This feature has much in common with XFS project_id.

In fact subtrees support may be implemented in generic vfs layer (may be
sometimes it will be)

There are many usecases for such subtrees

1) Choroot environment or Containers on common file-system
   administrator creates a subtree,and setup quota
   #mkdir chroot-env
   #chattr -Q ${subtree_id} chroot-env
   #tar jxf /tmp/fedora-x86_64.tar.bz2 -C chroot-env
   #### as soon as subtree id inherented from parent untared content
   #### automatically belongs to ${subtree_id}
   #quotactl --type=subtree --id=${subtree_id} --bsoft=1000000 --bhard=1000000
   ###
   #chroot chroot-env /bin/bash
2) NFS quota on server side
   Administrator perform exactly the same stages, but instead of chroot
   hi just export result subtree to nfs server


One may imagine it's own usecase.

Usually we already have some content which we want to see as subtree
In this case we have to in-depth traverse it from the subtree root.
add_to_subtree(dir, subtree_id) /* in-depth  tree traversal */
{
	while(de = getdents(dir)) {
	     if (IS_DIR(de))
		    add_to_subtree(de, subtree_id)
             else
	            set_subtree_id(de, subtree);
       }
       set_subtree_id(de, subtree);
}
It is possible to manipulate subtree content

For example we have following hierarchy
/root/subtree-1/a/b/c/d/e/f/g
/root/subtree-2/dir/
want rename /root/subtree-1/a to /root/subtree-2/dir/AA
first we have to move "a" to default tree "root"
 #rename /root/subtree-1/a /root/a-1
Then we have assign to default subtree. Do it in width traverse order
Because otherwise this result in subtree assumptions violation.
 #walk_in_width(/root/AA, 0 /* default subtree */)
Then  assign target subtree_id
 #walk_in_depth(/root/AA, 2)
Ok now all content from /root/a-1 belongs to subtree_id == 2 so it is possible
rename it in to target place
 #rename /root/a-1 /root/subtree-2/dir/AA

If you still reading this then i'll give comment about patch set organization

## Patch set prepared against ext4.git:next
## Following two patches already acceped by Jan Kara,
## but not yet in ext4 tree
##
ext4-mount-flags-manipulation-cleanup.patch
ext4-trivial-quota-cleanup.patch
## Following for patches perform necessety generic quota changes
## in order to new quota type
quota-sb_quota-state-flags-cleanup.patch
quota-generalize-quota-transfer-interface.patch
quota-introduce-get_id-callback.patch
quota-add-generic-subtree-quota-support.patch
## ext4 is so feature rich so there is no enouth space to store
## all it's mount flags
ext4-enlarge-mount-option-field.patch
## subtree support for ext4
ext4-introduce-subtree-logic.patch
ext4-subtree-add-kconfig-options.patch
ext4-add-subtree-support.patch
## subtree quota support for ext3
ext4-add-subtree-quota-support.patch
