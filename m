From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Wed, 20 Apr 2011 16:39:30 +0200
Message-ID: <87d3khugv1.fsf@rho.meyering.net>
References: <20110414102608.GA1678@x4.trippels.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreutils-mXXj517/zsQ@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
To: Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <20110414102608.GA1678-tLCgZGx+iJ+kxVt8IV0GqQ@public.gmane.org> (Markus Trippelsdorf's
	message of "Thu, 14 Apr 2011 12:26:08 +0200")
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Markus Trippelsdorf wrote:
> I trashed my system this morning when I installed coreutils-8.11.
>
> What happened is that coreutils compiles and links correctly, but then
> the following command (during the installation phase):
>
> ./ginstall chroot hostid nice who users pinky stty df stdbuf [ base64
...
>
> apparently produces files which have the length of the originals but are
> full of zeros. (and these were then installed to my live system, thereby
> trashing it).
...

Thanks again for the report.
I believe that the following series addresses this problem
and have confirmed that tests pass with 2.6.39-rc3 on all
of ext3, ext4, btrfs and xfs -- though there was what appears
to be a spurious failure in tests/cp/sparse-fiemap when run on xfs.
On one iteration of this loop, with j=3D31, in these loops

  for i in $(seq 1 2 21); do
    for j in 1 2 31 100; do

[in http://git.savannah.gnu.org/cgit/coreutils.git/tree/tests/cp/sparse-fie=
map]
the two files compared equal, yet their extents did not match,
even after merging.  I'm inclined to skip the extent-comparing check
at least for XFS, now.

Here's the unusually-technical-for-NEWS summary:

** Changes in behavior

  cp's extent-based (FIEMAP) copying code is more reliable in the face
  of varying and undocumented file system semantics:
  - it no longer treats unwritten extents specially
  - a FIEMAP-based extent copy always uses the FIEMAP_FLAG_SYNC flag.
      Before, it would incur the performance penalty of that sync only
      for 2.6.38 and older kernels.  We thought all problems would be
      resolved for 2.6.39.
  - it now attempts a FIEMAP copy only on a file that appears sparse.
      Sparse files are relatively unusual, and the copying code incurs
      the performance penalty of the now-mandatory sync only for them.




From=202783b52b273dd8fca824d8e1a64f8c4f41a54c00 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 09:49:15 +0200
Subject: [PATCH 1/4] copy: always use FIEMAP_FLAG_SYNC, for now

* src/extent-scan.c (extent_need_sync): Always return true,
to make the sole caller always use FIEMAP_FLAG_SYNC.
This will doubtless have an undesirable performance impact,
but we'll mitigate that shortly, by using extent_copy only on
files with holes.
=2D--
 src/extent-scan.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/src/extent-scan.c b/src/extent-scan.c
index da7eb9d..596e7f7 100644
=2D-- a/src/extent-scan.c
+++ b/src/extent-scan.c
@@ -36,6 +36,13 @@
 static bool
 extent_need_sync (void)
 {
+  /* For now always return true, to be on the safe side.
+     If/when FIEMAP semantics are well defined (before SEEK_HOLE support
+     is usable) and kernels implementing them are in use, we may relax
+     this once again.  */
+  return true;
+
+#if FIEMAP_BEHAVIOR_IS_DEFINED_AND_USABLE
   static int need_sync =3D -1;

   if (need_sync =3D=3D -1)
@@ -57,6 +64,7 @@ extent_need_sync (void)
     }

   return need_sync;
+#endif
 }

 /* Allocate space for struct extent_scan, initialize the entries if
=2D-
1.7.5.rc2.295.g19c42


From=20f35019b45e2b1ff6e1940db7b452dcb8f674f190 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 10:15:15 +0200
Subject: [PATCH 2/4] copy: do not treat unwritten extents specially (avoid
 XFS corruption)

* src/copy.c (extent_copy): Do not treat "unwritten extents" specially.
Otherwise, with XFS and a release-candidate 2.6.39-rc3 kernel, and
when using gold as your linker[*], and if you don't run "make check",
you could end up installing files full of zeros instead of the
expected binaries.  For a lot of discussion, see
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895

[*] Gold preallocates space for the files it writes, which is good.
However, on XFS, that conspired with the other conditions to result
the malfunctioning of the just-built install binary.
=2D--
 src/copy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index 9b53127..f6f9ea6 100644
=2D-- a/src/copy.c
+++ b/src/copy.c
@@ -398,7 +398,10 @@ extent_copy (int src_fd, int dest_fd, char *buf, size_=
t buf_size,
           /* Treat an unwritten but allocated extent much like a hole.
              I.E. don't read, but don't convert to a hole in the destinati=
on,
              unless SPARSE_ALWAYS.  */
=2D          if (scan.ext_info[i].ext_flags & FIEMAP_EXTENT_UNWRITTEN)
+          /* For now, do not treat FIEMAP_EXTENT_UNWRITTEN specially,
+             because that (in combination with no sync) would lead to data
+             loss at least on XFS and ext4 when using 2.6.39-rc3 kernels. =
 */
+          if (0 && (scan.ext_info[i].ext_flags & FIEMAP_EXTENT_UNWRITTEN))
             {
               empty_extent =3D true;
               last_ext_len =3D 0;
=2D-
1.7.5.rc2.295.g19c42


From=20489261905dfee95cc1ebb708e8302bb246519b8b Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 10:23:32 +0200
Subject: [PATCH 3/4] copy: factor out a tiny sparse-testing function

* src/copy.c (HAVE_STRUCT_STAT_ST_BLOCKS): Define to 0 if undefined,
so we can use it in the return expression, here:
(is_probably_sparse): New function, factored out of...
(copy_reg): ...here.  Use the new function.
=2D--
 src/copy.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index f6f9ea6..3db07b5 100644
=2D-- a/src/copy.c
+++ b/src/copy.c
@@ -764,6 +764,23 @@ fchmod_or_lchmod (int desc, char const *name, mode_t m=
ode)
   return lchmod (name, mode);
 }

+#ifndef HAVE_STRUCT_STAT_ST_BLOCKS
+# define HAVE_STRUCT_STAT_ST_BLOCKS 0
+#endif
+
+/* Use a heuristic to determine whether stat buffer SB comes from a file
+   with sparse blocks.  If the file has fewer blocks than would normally
+   be needed for a file of its size, then at least one of the blocks in
+   the file is a hole.  In that case, return true.  */
+static bool
+is_probably_sparse (struct stat const *sb)
+{
+  return (HAVE_STRUCT_STAT_ST_BLOCKS
+          && S_ISREG (sb->st_mode)
+          && ST_NBLOCKS (*sb) < sb->st_size / ST_NBLOCKSIZE);
+}
+
+
 /* Copy a regular file from SRC_NAME to DST_NAME.
    If the source file contains holes, copies holes and blocks of zeros
    in the source file as holes in the destination file.
@@ -984,15 +1001,13 @@ copy_reg (char const *src_name, char const *dst_name,
           if (x->sparse_mode =3D=3D SPARSE_ALWAYS)
             make_holes =3D true;

=2D#if HAVE_STRUCT_STAT_ST_BLOCKS
           /* Use a heuristic to determine whether SRC_NAME contains any sp=
arse
              blocks.  If the file has fewer blocks than would normally be
              needed for a file of its size, then at least one of the block=
s in
              the file is a hole.  */
=2D          if (x->sparse_mode =3D=3D SPARSE_AUTO && S_ISREG (src_open_sb.=
st_mode)
=2D              && ST_NBLOCKS (src_open_sb) < src_open_sb.st_size / ST_NBL=
OCKSIZE)
+          if (x->sparse_mode =3D=3D SPARSE_AUTO
+              && is_probably_sparse (&src_open_sb))
             make_holes =3D true;
=2D#endif
         }

       /* If not making a sparse file, try to use a more-efficient
=2D-
1.7.5.rc2.295.g19c42


From=2039fdf629729319ab4011cf15c0a16cba4e4aba1b Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 11:21:09 +0200
Subject: [PATCH 4/4] copy: use FIEMAP (extent_copy) only for
 apparently-sparse files,

to avoid the expense of extent_copy's unconditional use of
FIEMAP_FLAG_SYNC.
* src/copy.c (copy_reg): Do not attempt extent_copy on a file
that appears to have no holes.
* NEWS (Changes in behavior): Document this.  At first I labeled this
as a bug fix, but that would be inaccurate, considering there is no
documentation of FIEMAP semantics, nor even consensus among kernel
FS developers.  Here's hoping SEEK_HOLE/SEEK_DATA support will soon
make it into the linux kernel.
=2D--
 NEWS       |   13 +++++++++++++
 src/copy.c |   37 +++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/NEWS b/NEWS
index 4873b5a..7bc2ef3 100644
=2D-- a/NEWS
+++ b/NEWS
@@ -2,6 +2,19 @@ GNU coreutils NEWS                                    -*- =
outline -*-

 * Noteworthy changes in release ?.? (????-??-??) [?]

+** Changes in behavior
+
+  cp's extent-based (FIEMAP) copying code is more reliable in the face
+  of varying and undocumented file system semantics:
+  - it no longer treats unwritten extents specially
+  - a FIEMAP-based extent copy always uses the FIEMAP_FLAG_SYNC flag.
+      Before, it would incur the performance penalty of that sync only
+      for 2.6.38 and older kernels.  We thought all problems would be
+      resolved for 2.6.39.
+  - it now attempts a FIEMAP copy only on a file that appears sparse.
+      Sparse files are relatively unusual, and the copying code incurs
+      the performance penalty of the now-mandatory sync only for them.
+

 * Noteworthy changes in release 8.11 (2011-04-13) [stable]

diff --git a/src/copy.c b/src/copy.c
index 3db07b5..6edf52e 100644
=2D-- a/src/copy.c
+++ b/src/copy.c
@@ -993,6 +993,7 @@ copy_reg (char const *src_name, char const *dst_name,

       /* Deal with sparse files.  */
       bool make_holes =3D false;
+      bool sparse_src =3D false;

       if (S_ISREG (sb.st_mode))
         {
@@ -1005,8 +1006,8 @@ copy_reg (char const *src_name, char const *dst_name,
              blocks.  If the file has fewer blocks than would normally be
              needed for a file of its size, then at least one of the block=
s in
              the file is a hole.  */
=2D          if (x->sparse_mode =3D=3D SPARSE_AUTO
=2D              && is_probably_sparse (&src_open_sb))
+          sparse_src =3D is_probably_sparse (&src_open_sb);
+          if (x->sparse_mode =3D=3D SPARSE_AUTO && sparse_src)
             make_holes =3D true;
         }

@@ -1038,21 +1039,25 @@ copy_reg (char const *src_name, char const *dst_nam=
e,
       buf_alloc =3D xmalloc (buf_size + buf_alignment_slop);
       buf =3D ptr_align (buf_alloc, buf_alignment);

=2D      bool normal_copy_required;
=2D      /* Perform an efficient extent-based copy, falling back to the
=2D         standard copy only if the initial extent scan fails.  If the
=2D         '--sparse=3Dnever' option is specified, write all data but use
=2D         any extents to read more efficiently.  */
=2D      if (extent_copy (source_desc, dest_desc, buf, buf_size,
=2D                       src_open_sb.st_size,
=2D                       S_ISREG (sb.st_mode) ? x->sparse_mode : SPARSE_NE=
VER,
=2D                       src_name, dst_name, &normal_copy_required))
=2D        goto preserve_metadata;
=2D
=2D      if (! normal_copy_required)
+      if (sparse_src)
         {
=2D          return_val =3D false;
=2D          goto close_src_and_dst_desc;
+          bool normal_copy_required;
+
+          /* Perform an efficient extent-based copy, falling back to the
+             standard copy only if the initial extent scan fails.  If the
+             '--sparse=3Dnever' option is specified, write all data but use
+             any extents to read more efficiently.  */
+          if (extent_copy (source_desc, dest_desc, buf, buf_size,
+                           src_open_sb.st_size,
+                           S_ISREG (sb.st_mode) ? x->sparse_mode : SPARSE_=
NEVER,
+                           src_name, dst_name, &normal_copy_required))
+            goto preserve_metadata;
+
+          if (! normal_copy_required)
+            {
+              return_val =3D false;
+              goto close_src_and_dst_desc;
+            }
         }

       off_t n_read;
=2D-
1.7.5.rc2.295.g19c42
