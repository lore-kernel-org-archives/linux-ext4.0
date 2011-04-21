From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 21 Apr 2011 22:01:43 +0200
Message-ID: <87r58vqspk.fsf@rho.meyering.net>
References: <20110414102608.GA1678@x4.trippels.de>
	<87d3khugv1.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreutils-mXXj517/zsQ@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
To: Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <87d3khugv1.fsf-CybKA8TIZ99x3y/oJEDuiw@public.gmane.org> (Jim Meyering's message of
	"Wed, 20 Apr 2011 16:39:30 +0200")
List-Unsubscribe: <https://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Jim Meyering wrote:
> Markus Trippelsdorf wrote:
>> I trashed my system this morning when I installed coreutils-8.11.
>>
>> What happened is that coreutils compiles and links correctly, but then
>> the following command (during the installation phase):
>>
>> ./ginstall chroot hostid nice who users pinky stty df stdbuf [ base64
> ...
>>
>> apparently produces files which have the length of the originals but are
>> full of zeros. (and these were then installed to my live system, thereby
>> trashing it).
> ...
>
> Thanks again for the report.
> I believe that the following series addresses this problem
> and have confirmed that tests pass with 2.6.39-rc3 on all
> of ext3, ext4, btrfs and xfs -- though there was what appears
> to be a spurious failure in tests/cp/sparse-fiemap when run on xfs.
> On one iteration of this loop, with j=3D31, in these loops
>
>   for i in $(seq 1 2 21); do
>     for j in 1 2 31 100; do
>
> [in http://git.savannah.gnu.org/cgit/coreutils.git/tree/tests/cp/sparse-f=
iemap]
> the two files compared equal, yet their extents did not match,
> even after merging.  I'm inclined to skip the extent-comparing check
> at least for XFS, now.
>
> Here's the unusually-technical-for-NEWS summary:

[slightly updated and pushed, along with test-adjusting changes]

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


From=209bcd045f812a75cf96ba392bc45529422f87c088 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 09:49:15 +0200
Subject: [PATCH 1/6] copy: always use FIEMAP_FLAG_SYNC, for now

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
1.7.5.rc3.291.g63e4e


From=20bef4fa1e1a20c636979db159647a93e5954bc542 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 10:15:15 +0200
Subject: [PATCH 2/6] copy: do not treat unwritten extents specially: avoid
 XFS/ext4 data loss

* src/copy.c (extent_copy): Do not treat "unwritten extents" specially.
Otherwise, with a release-candidate 2.6.39-rc3 kernel, XFS or ext4,
when using gold as your linker, and if you forget to run "make check",
you could end up installing files full of zeros instead of the expected
binaries.  For a lot of discussion, see
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895
* tests/cp/fiemap-empty: Disable this test.
=2D--
 src/copy.c            |    5 ++++-
 tests/cp/fiemap-empty |    5 +++++
 2 files changed, 9 insertions(+), 1 deletions(-)

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
diff --git a/tests/cp/fiemap-empty b/tests/cp/fiemap-empty
index 64c3254..836668e 100755
=2D-- a/tests/cp/fiemap-empty
+++ b/tests/cp/fiemap-empty
@@ -19,6 +19,11 @@
 . "${srcdir=3D.}/init.sh"; path_prepend_ ../src
 print_ver_ cp

+# FIXME: enable any part of this test that is still relevant,
+# or, if none are relevant (now that cp does not handle unwritten
+# extents), just remove the test altogether.
+skip_test_ 'disabled for now'
+
 touch fiemap_chk
 fiemap_capable_ fiemap_chk ||
   skip_test_ 'this file system lacks FIEMAP support'
=2D-
1.7.5.rc3.291.g63e4e


From=20846d826096fc8fb621d751f8b3db1da68a8bbd06 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 10:23:32 +0200
Subject: [PATCH 3/6] copy: factor out a tiny sparse-testing function

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
1.7.5.rc3.291.g63e4e


From=2018a474d755aa10d881243d9457d2c420c5e4ea77 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 Apr 2011 11:21:09 +0200
Subject: [PATCH 4/6] copy: use FIEMAP (extent_copy) only for
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
1.7.5.rc3.291.g63e4e


From=20223e3832eb5a9b1aadf0a69d076f40116389565c Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 21 Apr 2011 18:08:20 +0200
Subject: [PATCH 5/6] tests: sparse-fiemap: report more detail upon failure;
 ignore an FP

* tests/cp/sparse-fiemap: Fail right away with details, when cmp fails.
When extent maps are found to differ, display them and merely warn.
=2D--
 tests/cp/sparse-fiemap |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/cp/sparse-fiemap b/tests/cp/sparse-fiemap
index 2c6a250..2e8c95b 100755
=2D-- a/tests/cp/sparse-fiemap
+++ b/tests/cp/sparse-fiemap
@@ -75,7 +75,7 @@ for i in $(seq 1 2 21); do
     # for the same reasons.
     cp --sparse=3Dalways j1 j2 || fail=3D1

=2D    cmp j1 j2 || fail=3D1
+    cmp j1 j2 || fail_ "data loss i=3D$i j=3D$j"
     if ! filefrag -vs j1 | grep -F extent >/dev/null; then
       test $skip !=3D 1 && warn_ 'skipping part; you lack filefrag'
       skip=3D1
@@ -98,8 +98,12 @@ for i in $(seq 1 2 21); do
       # exclude the physical block numbers; they always differ
       filefrag -v j1 > ff1 || framework_failure
       filefrag -vs j2 > ff2 || framework_failure
=2D      { f ff1; f ff2; } | $PERL $abs_top_srcdir/tests/filefrag-extent-co=
mpare ||
=2D        fail=3D1
+      { f ff1; f ff2; } | $PERL $abs_top_srcdir/tests/filefrag-extent-comp=
are \
+        || {
+             warn_ ignoring filefrag-reported extent map differences
+             # Show the differing extent maps.
+             head -99 ff1 ff2
+           }
     fi
     test $fail =3D 1 && break 2
   done
=2D-
1.7.5.rc3.291.g63e4e


From=208c0b1de42c615a82ce7e32901ad1e4dca95b3657 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 21 Apr 2011 21:01:13 +0200
Subject: [PATCH 6/6] tests: sparse-fiemap: with root/ext3, do not create an
 ext4 FS

* tests/cp/sparse-fiemap: When this test was run as root on an ext3
file system, (ext3 had known problems), it would trickily create and
mount a loopback ext4 file system and use that instead.  However, due
to a bug in 2.6.39-rc1..rc3, this loopback test (when run in another
loopback FS) exposed a bug with 1k-blocksize ext4 whereby non-NUL
data would be read from a hole.  For details, see this:
http://thread.gmane.org/gmane.comp.file-systems.ext4/24495
=2D--
 tests/cp/sparse-fiemap |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tests/cp/sparse-fiemap b/tests/cp/sparse-fiemap
index 2e8c95b..1394060 100755
=2D-- a/tests/cp/sparse-fiemap
+++ b/tests/cp/sparse-fiemap
@@ -26,6 +26,10 @@ touch fiemap_chk
 if fiemap_capable_ fiemap_chk && ! df -t ext3 . >/dev/null; then
   : # Current partition has working extents.  Good!
 else
+  # FIXME: temporarily(?) skip this variant, at least until after this bug
+  # is fixed: http://thread.gmane.org/gmane.comp.file-systems.ext4/24495
+  skip_test_ "current file system has insufficient FIEMAP support"
+
   # It's not;  we need to create one, hence we need root access.
   require_root_

=2D-
1.7.5.rc3.291.g63e4e
