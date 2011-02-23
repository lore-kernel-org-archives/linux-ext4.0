From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5 00/24]  New ACL format for better NFSv4 acl interoperability
Date: Wed, 23 Feb 2011 19:21:47 +0530
Message-ID: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
	sandeen@redhat.com, tytso@mit.edu, bfields@fieldses.org,
	jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

The following set of patches implements VFS and ext4 changes needed to implement
a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
extended by file masks to fit into the standard POSIX file permission model.
They are designed to work seamlessly locally as well as across the NFSv4 and
CIFS/SMB2 network file system protocols.

Full patch series including NFS server and client changes can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git  richacl
or
git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-richacl.git richacl

A user-space utility for displaying and changing richacls is available at [4]
(a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).

[4] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/richacl.git master

To test richacl on ext4 use -o richacl mount option. This mount option may later be
dropped in favour of a feature flag.

More details regarding richacl can be found at
http://acl.bestbits.at/richacl/

Changes from v4:
a) rebase to 2.6.38-rc6
b) Fixes for MAY_DELETE_CHILD and MAY_DELETE_SELF when directory have sticky bits
c) Fixes for NFsv4  permission checking to make it work better with new MAY_* flags


-aneesh

