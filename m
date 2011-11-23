From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests: mount other filesystems with selinux context as
 well
Date: Wed, 23 Nov 2011 11:50:26 -0600
Message-ID: <4ECD3262.105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1KWRua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Nov 2011 12:50:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

For some reason, non-xfs filesystems aren't getting mounted with
the selinux context; perhaps because none of the xattr tests used
to work on anything but xfs?

Anyway, 062 fails for extN unless we mount with the fs-wide
context.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
- ---

diff --git a/common.rc b/common.rc
index cab0b64..5998ff2 100644
- --- a/common.rc
+++ b/common.rc
@@ -86,14 +86,17 @@ _mount_opts()
 	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 	;;
     ext2|ext3|ext4|ext4dev)
- -	# acls & xattrs aren't turned on by default on ext$FOO
+	export SELINUX_MOUNT_OPTIONS
+	# acls & xattrs aren't turned on by default on ext$FOO in old kernels
 	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
 	;;
     reiserfs)
+	export SELINUX_MOUNT_OPTIONS
 	# acls & xattrs aren't turned on by default on reiserfs
 	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
 	;;
     gfs2)
+	export SELINUX_MOUNT_OPTIONS
 	# acls aren't turned on by default on gfs2
 	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
 	;;

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzTJgAAoJECCuFpLhPd7gv14QAJPmvzzrv7hTUq6Fuw5uLrnY
AJ/h2dxdJyKfcdSQe6InI9EmDOt6kD3GPR5PnfWn06tvNz2vHDeKwb8m29vaidcW
2RGvTdtxEl/3z7ePv2PBuPqib+Ns27aaOL6cXZbv9aikN6QwDOEdja99aH6ALyN/
4sVHlyabTUS3858KDtlYlSsVm9StvMNKf3BsKhaGOBfgN1tAQkgLc4PekGiY4uFn
Dkm7G8uLgqIOuzEP0mwodAvFtDaFOuxmlJrWsKc2hzb9n6fqNBR8qb2XkpYJjoc/
8KLCNu8o1TvEVYrObRq6bRfGbLRLjbfdVBWC2382BtZnGgF5jONR6xP9CN8bKAkk
Cns7AYGIndRzXy46d1U1lxrPtHw7VTIUUPuKf3iNICQc/voiSlpEL/R3RH5rFgaw
nRA1y+ufQNxNjFBKw9FwjuQ3+Eq+NZeytFoUETZVptxgtD+hkKl5oVGsTtqS2gpq
pJoWBMb7agQdARVBgOXNQ937KFwP5NV4fMZ157K0pwp1QPkCiV6ueP23T/XRAFhU
zAHPN22h4Ab1g5xiQWVZwfqCYkm8CjV0h6GAi2uwXCij1sqiv5IYehy/XIv171y4
lEVYkQl390wpaMtmpO6xDHRMlGPQX2T00JEGoUqIpATFX6h3JkX3LdB+FIvdzh06
AtgjqsaI8FmcvMfZlcBi
=6s9a
-----END PGP SIGNATURE-----
