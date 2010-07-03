From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Sat, 03 Jul 2010 16:20:33 +0530
Message-ID: <87d3v42612.fsf@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45135 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0GCKuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jul 2010 06:50:51 -0400
In-Reply-To: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  3 Jul 2010 00:13:31 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Hi,
> 
> The following set of patches implements a new acl model for linux. Rich ACLs
> are an implementation of NFSv4 ACLs, extended by file masks to fit into the
> standard POSIX file permission model.  They are designed to work seamlessly
> locally as well as across the NFSv4 and CIFS/SMB2 network file system protocols.
> 
> Since posting the patches the previous time [0], Andreas Gruenbacher and I have 
> worked on cleaning up the code, splitting things up into smaller pieces, and 
> adding more documentation.
> 
> [0] http://article.gmane.org/gmane.comp.file-systems.ext4/17414
> 
> The patch set consists of three parts.
> 
> The first set of patches, posted as a follow up, contains the Rich ACL model
> and Ext4 implementation. The second set [1] contains mapping of Rich ACL to
> NFSv4 ACL (how to apply file mask to access mask) and implementation of
> Richacl ACL for NFS server and client. The third set [2] contains POSIX ACL
> to Rich ACL mapping and its ext4 usage.
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-upstream
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-2.6-richacl.git richacl-fullset
> 
> A user-space utility for displaying and changing richacls is available at [3]
> (a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).
> 
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/richacl.git master
> 
> To test richacl on ext4 use -o richacl mount option. This mount option may later be
> dropped in favour of a feature flag.
> 
> More details regarding richacl can be found at 
> http://acl.bestbits.at/richacl/
> 
> Changes from V1:
> 1) Split the patches into smaller patches
> 2) Added extensive documentation to the patches.
> 

We also need the below patch set to make sure the permission check
function does the right thing. This patch is a part of second patch set
[1] pointed above. We add it as a part of the later series because it is
better explained with isolate owner and group patchset. 

commit 01a3a0c12dc4b87cdee11cd101b3ceefaa331e41
Author: Andreas Gruenbacher <agruen@suse.de>
Date:   Mon Jun 28 21:32:24 2010 +0530

    richacl: Restrict access check algorithm
    
    We want to avoid applying the file masks to an acl when changing the
    file permission bits or performing an access check.  On the other hand,
    when we *do* apply the file masks to the acl, we want the resulting acl
    to produce the same access check results with the standard nfs4 access
    check algorithm as the richacl access check algorithm with the original
    acl.  This is already the case, except in the following scenario:
    
    With file masks equivalent to file mode 0600, the following acl would
    grant the owner rw access if the owner is in the owning group:
    
       group@:rw::allow
    
    There is no way to express this in an nfs4 acl; the result is always a
    more restrictive acl.  There are two approaches to deal with this
    difference: either accept that it exists and that applying the file
    masks is imperfect, or change the richacl access check algorithm so that
    such accesses are denied.
    
    This patch denies such accesses and makes sure that the richacl access
    check algorithm grants the same accesses as the nfsv4 acl with the file
    masks applied.
    
    Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index b368b51..79fb00f 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -424,6 +424,16 @@ richacl_permission(struct inode *inode, const struct richacl *acl,
 		} else
 			goto is_everyone;
 
+		/*
+		 * Apply the group file mask to entries other than OWNER@ and
+		 * EVERYONE@. This is not required for correct access checking
+		 * but ensures that we grant the same permissions as the acl
+		 * computed by richacl_apply_masks() would grant.  See
+		 * richacl_apply_masks() for a more detailed explanation.
+		 */
+		if (richace_is_allow(ace))
+			ace_mask &= acl->a_group_mask;
+
 is_owner:
 		/* The process is in the owner or group file class. */
 		in_owner_or_group_class = 1;

