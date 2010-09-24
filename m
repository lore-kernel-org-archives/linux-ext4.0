From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 00/11]  New ACL format for better NFSv4 acl interoperability
Date: Fri, 24 Sep 2010 18:18:03 +0530
Message-ID: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42516 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0IXMsd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 08:48:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

The following set of patches implements VFS changes needed to implement
a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
extended by file masks to fit into the standard POSIX file permission model.
They are designed to work seamlessly locally as well as across the NFSv4 and
CIFS/SMB2 network file system protocols.

The patch set consists of four parts:

The first set of patches, posted as a follow up, contains VFS changes needed
to implement the Rich ACL model. The second set [1] contains the Rich ACL model
and Ext4 implementation. The third set [2] contains mapping of Rich ACL to
NFSv4 ACL (how to apply file mask to access mask) and implementation of
Richacl ACL for NFS server and client. The fourth set [3] contains POSIX ACL
to Rich ACL mapping and its ext4 usage.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-minimal
[2] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-upstream
[3] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-fullset

A user-space utility for displaying and changing richacls is available at [4]
(a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).

[4] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/richacl.git master

To test richacl on ext4 use -o richacl mount option. This mount option may later be
dropped in favour of a feature flag.

More details regarding richacl can be found at 
http://acl.bestbits.at/richacl/

Changes from V3:
a) Droped may_delete and may_create inode operations callback and reworked
   the patch series to use additional check flags. 
b) Rebased to the latest kernel
c) The patch series now contain only the minimal VFS changes.

Changes from V2:
1) Git repo include check-acl branch that drop newly added inode_operations
   callback in favour for additional access check flags (MAY_CREATE_FILE,
   MAY_CREATE_DIR, MAY_DELETE_CHILD, MAY_DELETE_SELF, MAY_TAKE_OWNERSHIP,
   MAY_CHMOD, and MAY_SET_TIMES)
2) richacl is now cached in the vfs inode instead of file system inode.
   (currently kept as a separate patch. We may want to fold that later)
3) Added a new acl flag ACL4_MASKED. richacl_apply_masks() can skip transforming acls
   without this flag, which speeds things up and avoids modifying those acls unnecessarily.
4) Owner always allowed permissions are now explicitly included when synthesizing an acl
   from file mode.

Changes from V1:
1) Split the patches into smaller patches
2) Added extensive documentation to the patches.

-aneesh


