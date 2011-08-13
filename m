From: "Theodore Ts'o" <tytso@mit.edu>
Subject: xfstests #62 broken on ext4
Date: Sat, 13 Aug 2011 10:38:51 -0400
Message-ID: <E1QsFMR-0001iq-Vt@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55219 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab1HMOi5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 10:38:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Xfstests #62 was recently enabled by commit b2b36d0a4.

However, this test is failing for ext4 because ext4 doesn't support
extended attributes on anything other than regular files and
directories.  This is behavior is documented in the attr(5) man page:

   Extended user attributes
       Extended user attributes may be assigned to files and  directori=
es  for
       storing arbitrary additional information such as the mime type, =
charac=E2=80=90
       ter set or  encoding  of  a  file.  The  access  permissions  fo=
r  user
       attributes are defined by the file permission bits.

       The  file  permission  bits of regular files and directories are=
 inter=E2=80=90
       preted differently from the file permission bits of special  fil=
es  and
       symbolic  links.  For regular files and directories the file per=
mission
       bits define access to the file's contents,  while  for  device  =
special
       files  they  define access to the device described by the specia=
l file.
       The file permissions of symbolic links are not used in  access  =
checks.
       These  differences would allow users to consume filesystem resou=
rces in
       a way not controllable by disk quotas for group or world writabl=
e  spe=E2=80=90
       cial files and directories.

       For  this reason, extended user attributes are only allowed for =
regular
       files and directories,  and  access  to  extended  user  attribu=
tes  is
       restricted  to the owner and to users with appropriate capabilit=
ies for
       directories with the sticky bit set (see the chmod(1) manual  pa=
ge  for
       an explanation of Sticky Directories).

=2E.. and it is enforced by the generic fs/xattr.c code in
xattr_permission():

	/*
	 * In the user.* namespace, only regular files and directories can hav=
e
	 * extended attributes. For sticky directories, only the owner and
	 * privileged users can write attributes.
	 */
	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
		    (mask & MAY_WRITE) && !inode_owner_or_capable(inode))
			return -EPERM;
	}



It looks like XFS is not conformant to documented behaviour and the fil=
e
system generic code.   The question is how should we fix this?  I can
think of a couple of different options

(1) Back out commit b2b36d0a4 and make test #62 XFS-specific again.

(2) Option #1, above, and then also create another test for file system=
s
with the standard/generic Linux behavior

(3) Modify test #62 so that it can support both the XFS and Linux
generic behavior.

(4) Change the generic code to match what XFS does (despite the design
rationale mentioned in the attr(5) man page).

(5) Change XFS to match the generic behavior, and then change test #62.

What do people think?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
