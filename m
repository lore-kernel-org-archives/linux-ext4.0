From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Sat,  3 Jul 2010 00:13:31 +0530
Message-ID: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37628 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0GBSoM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jul 2010 14:44:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The following set of patches implements a new acl model for linux. Rich ACLs
are an implementation of NFSv4 ACLs, extended by file masks to fit into the
standard POSIX file permission model.  They are designed to work seamlessly
locally as well as across the NFSv4 and CIFS/SMB2 network file system protocols.

Since posting the patches the previous time [0], Andreas Gruenbacher and I have 
worked on cleaning up the code, splitting things up into smaller pieces, and 
adding more documentation.

[0] http://article.gmane.org/gmane.comp.file-systems.ext4/17414

The patch set consists of three parts.

The first set of patches, posted as a follow up, contains the Rich ACL model
and Ext4 implementation. The second set [1] contains mapping of Rich ACL to
NFSv4 ACL (how to apply file mask to access mask) and implementation of
Richacl ACL for NFS server and client. The third set [2] contains POSIX ACL
to Rich ACL mapping and its ext4 usage.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-upstream
[2] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-fullset

A user-space utility for displaying and changing richacls is available at [3]
(a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).

[3] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/richacl.git master

To test richacl on ext4 use -o richacl mount option. This mount option may later be
dropped in favour of a feature flag.

More details regarding richacl can be found at 
http://acl.bestbits.at/richacl/

Changes from V1:
1) Split the patches into smaller patches
2) Added extensive documentation to the patches.

-aneesh

