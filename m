From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] New ACL format for better NFSv4 acl interoperability
Date: Mon,  1 Feb 2010 11:04:42 +0530
Message-ID: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48663 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0BAFfV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
	**** RFC patch. Not for inclusion ****

The following set of patches implements a new acl format
for linux. Rich-acl format is proposed so that we can have
better acl interoperability with CIFS and NFSv4 acl.

Posix acl should still be considered as the default acl on
any file system because of its simplicity. File systems
should provide a migration mechanism to rich-acl format if
they ever want to export these file systems via CIFS or NFSv4.

Some of the patches in the series are earlier published as
NFSv4 acl patches at http://www.suse.de/~agruen/nfs4acl/
and http://oss.sgi.com/projects/nfs/nfs4acl/. Linux kernel
already supports "system.nfs4_acl" via NFSv4 client. NFSv4
client provides byte sequence representation of the acl value
to the userspace. The userspace then use this array and build
the acl structure. Linux native NFSv4acl work done by
Andreas Gruenbacher on the other hand provided an acl struct
to the userspace. Since both the implementation used NFSv4
acl format it was decided to rename non upstream implementation as
rich-acl even though the acl model is NFSv4.

Rich-acl also adds some exception to the NFSv4 specified 
access rules. The access rules are modified in a way that
make sense in posix environment. For example with patches applied

      a) we always allow read attributes
      b) we always allow read acl.
      c) execute doesn't imply read.

That implies even if the file system object have acl values that
deny read attribute access, local file system still allows read
attributes access to make sure we don't break posix semantics. This
gives an opportunity for nfsd to use the attribute value and
deny read attribute access as per NFSv4 RFC

Patches are done in way that changes done by me are kept
as separate patches. This make sure I don't end up breaking
the access check algorithm done by Andreas Gruenbacher. This also
helps in collecting review feedback on some of the changes done
by me in the access check algorithm. Before merging this upstream
most of these patches have to folded back into relevant patches.

Userspace changes needed for acl tools can be found at
http://git.kernel.org/?p=fs/acl/kvaneesh/acl.git;a=summary
I have updated getfacl to print rich-acl format if rich-acl is
enabled. Only Ext4 is updated to support the new acl format. To
enable rich-acl format one should use tune2fs to enabled the
richacl file system feature. The relevant patches can be found
at http://www.kernel.org/pub/linux/kernel/people/kvaneesh/richaclv2/e2fsprogs/

NFSD is also updated to save and read richacl format if the local
file system supports the new acl format.

git repo for the kernel change is at
http://git.kernel.org/?p=linux/kernel/git/kvaneesh/linux-richacl.git;a=summary

git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-richacl.git for-upstream

-aneesh

