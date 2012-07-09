From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/3] RFC: introduce extended inode owner identifier v10
Date: Mon,  9 Jul 2012 19:28:42 +0400
Message-ID: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Here is updated version subtree-quota pachset

*Feature description*
1) Inode may has a subtree identifier which has same meaning as uid/gid.
2) In general case Id is stored in inode's xattr named "system.subtree"
3) Id is inherent from parent inode on creation.
4) This id is cached in memory fs_inode structure and may be accessible
   via s_op->get_subtree(). This field it restricted by CONFIG_SUBTREE.
   So no wasting of memory happens.

5) Since id is cached in memory it may be used for different purposes
   such as:
5A) Implement additional quota id space orthogonal to uid/gid. This is
    useful in managing quota for some filesystem hierarchy(chroot or
    container over bindmount)

6) In comparison to XFS's project ID feature it does not affect
   rename(2)/link(2) in case of cross tries transfer

*User interface *
Subtree id is managed via generic xattr interface "system.subtree"
This good because
 1) We may use already existing interface.
 2) xattr already supported by generic utilities tar/rsync and etc

PATCH SET TOC:
1) generic subtree support
2) ext4: generic subtree support
3) ext4: subtree quota support
 NOTE:Ext4 quota is now managed via e2fsprogs, changes which add prjquota suppport for
 e2fsprogs will be submitted as separate patch-set.

Patch against next-20120605-1-g20a6ee4
Actually vfs part is really small, and most changes happen in fs/ext4/

Changes agains V9
 1) Change the name of the id from "project_id" to "subtree" accordings to Dave's
    comments.
 2) Fixes according to Jan's comments
   -  coalapse first and second patch
   -  get rid-of didicated mount point for subtree_id support
   -  code style changes
 3) Drop XFS stuff, since it require nontrivial changes in disk structures.

Changes against V7
 - Small fix for subtree switch error path
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
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 0d718ed..8dbcc39 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@ VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 0
 EXTRAVERSION = -rc1
-NAME = Saber-toothed Squirrel
+NAME = Saber-toothed Squirrel-tree-quota
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
-- 
1.7.1

