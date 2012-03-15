From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: sb_dirt question
Date: Thu, 15 Mar 2012 17:00:40 +0200
Message-ID: <1331823640.3730.40.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0D/YZ83XZp+PNhb3CJkF"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab2COO6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Mar 2012 10:58:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-0D/YZ83XZp+PNhb3CJkF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

could you please commend on this commit of yours a bit:

commit a0375156ca1041574b5d47cc7e32f10b891151b0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jun 11 23:14:04 2010 -0400

    ext4: Clean up s_dirt handling
   =20
    We don't need to set s_dirt in most of the ext4 code when journaling
    is enabled.  In ext3/4 some of the summary statistics for # of free
    inodes, blocks, and directories are calculated from the per-block
    group statistics when the file system is mounted or unmounted.  As a
    result the superblock doesn't have to be updated, either via the
    journal or by setting s_dirt.  There are a few exceptions, most
    notably when resizing the file system, where the superblock needs to
    be modified --- and in that case it should be done as a journalled
    operation if possible, and s_dirt set only in no-journal mode.
   =20
    This patch will optimize out some unneeded disk writes when using ext4
    with a journal.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Let's take this hunk (I preserved more context than usual)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..bd411c1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -110,33 +110,33 @@ static int ext4_file_open(struct inode * inode, struc=
t file * filp)
        if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
                     !(sb->s_flags & MS_RDONLY))) {
                sbi->s_mount_flags |=3D EXT4_MF_MNTDIR_SAMPLED;
                /*
                 * Sample where the filesystem has been mounted and
                 * store it in the superblock for sysadmin convenience
                 * when trying to sort through large numbers of block
                 * devices or filesystem images.
                 */
                memset(buf, 0, sizeof(buf));
                path.mnt =3D mnt;
                path.dentry =3D mnt->mnt_root;
                cp =3D d_path(&path, buf, sizeof(buf));
                if (!IS_ERR(cp)) {
                        memcpy(sbi->s_es->s_last_mounted, cp,
                               sizeof(sbi->s_es->s_last_mounted));
-                       sb->s_dirt =3D 1;
+                       ext4_mark_super_dirty(sb);
                }

As I read this, it means that if do have journal, do not bother writing
out the updated superblock at all. When the superblock will be written
out then?

Thanks!

P.S. The reason I look at this is because I am trying to make sure ext4
does not use s_dirty and does not rely on VFS calling 'write_super()' at
all. I guess I will try to use a delayed work instead and move 's_dirt'
to sbi. The reason of this exercise is that I want to eliminate
'sync_supers()' completely, because it wakes up every 5 seconds no
matter what, and Al wanted me to push SB handling down to file-systems.

--=20
Best Regards,
Artem Bityutskiy

--=-0D/YZ83XZp+PNhb3CJkF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYgQYAAoJECmIfjd9wqK0qnEP/ipe0NMmlgnwzpDcLG+vUcJF
hwEebkexSkDDl/5GCV8W/Q8dR+GjgdOtQWWpH9zbYTFrKcuWwX3FBgj4OSAP2wvO
y6m6Ifl3wt/VggEzduURm9RdsgoimGGMCQ3mY552Q/6eJVTXWZLGNmzqcLZF5I9P
jyhIIIqrgFUpL9OlBt2a3Qpo181l7SwdVIi+Q9oHjnxIdVsCO9FVrXLtUJNreq1s
5J0OHmdbKFkTXbyz1BwdGtJWSRG+pZ1RYe4frE5RBGFLFL7uK39y0JVq7GGz4/Xb
KLaGAYJBc9qL4/anzxnLskoj4QY6D8u8TqdaMxnkQAVC74XsD+Qo8rjANhbIeobV
a8eHtiOV5zHJaf8r8nkwwVOc03Igs7zu8S8DBZ6MP2g+UTB1o+R+h21mH1MzyXu1
YhuQ5DjqX7nC0CBwTbsWBPocKhq4lPqgxPoxFbDSJzkMOs+gl+QvUrySAm9x+boa
mJZURGE0JPrcf/zVT4drUsD0Ps/odLiJkEHijkCClvpgg8hYSSeYm2kixvVbhpXr
2fxeT4WR6VD8Bj+5yam1NsLn+WVg5D4Jko40cutvu2fqzPBrTqWqd21xuO0slDhr
lLd2l3TvBFkWqaGqTVo28fgdSN5PjzfHc4+csZx61IvHdCI05+1HGc6thM5d8GYQ
SGUlPgUKADTSkHigZH0E
=ZrK5
-----END PGP SIGNATURE-----

--=-0D/YZ83XZp+PNhb3CJkF--

