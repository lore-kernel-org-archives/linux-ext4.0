From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/5] RFC: introduce extended inode owner identifier v5
Date: Thu,  4 Mar 2010 21:34:32 +0300
Message-ID: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is next generation of attempt to add extended inode identifier.
Again i've change the name of the identified, but this is the last
time, i promise.
Now it's called similar to XFS project_id feature, in fact both
features are almost equal.

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

6) It is possible to create isolated inode subtree.
   (2 AlViro) please do not blame isolation feature before you read
          the isolation patch description, and then please wellcome.

*User interface *
Project id is managed via generic xattr interface "system.project_id"

PATCH SET TOC:
1) generic projectid support
2) generic project quota support
3) ext4 project support implementation
 3A) ext4: generic project support
 3B) ext4: project isolation support
 3C) ext4: project quota support

Patch agains linux-next-20100304
The patchset survived basic stress testing.

