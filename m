From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] xfstests-bld: Split system images in two parts
Date: Wed, 22 Oct 2014 20:48:12 -0400
Message-ID: <20141023004812.GA7841@thunk.org>
References: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org>
 <20141022212535.GC6295@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, root <root@deb7build>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38270 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbaJWAsS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 20:48:18 -0400
Content-Disposition: inline
In-Reply-To: <20141022212535.GC6295@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2014 at 05:25:35PM -0400, Theodore Ts'o wrote:
> So what I suggest instead is that we have a new script, update-image,
> which takes an existing root_fs.img, and installs the updated
> xfstests, the configuration files, and startup files, leaving the
> existing debian base image intact.

Here's an enhancement to the gen-image script which adds a new
--update option.

					- Ted

commit debd9734bc23108f37c6f62914cb5f9e16da20cc
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Oct 22 20:42:32 2014 -0400

    test-appliance: add --update option to the gen-image script
    
    This allows gen-image to to update the xfstests.tar.gz tarball and the
    xfstests driver scripts into an existing root_fs.img file, keeping the
    original operating systems files unchanged.  This takes less than 15
    seconds, compared to about 90 seconds to do a full gen-image build
    using a local disk debian mirror.  It also allows a xfstests developer
    to generate new versions of the root_fs.img more simply on a system
    that does not have debootstrap installed or has access to a Debian
    archive or mirror.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/kvm-xfstests/test-appliance/gen-image b/kvm-xfstests/test-appliance/gen-image
index 550d070..27f9d96 100755
--- a/kvm-xfstests/test-appliance/gen-image
+++ b/kvm-xfstests/test-appliance/gen-image
@@ -12,6 +12,7 @@ ROOT_FS=$DIR/root_fs.img
 COMPAT="-o compat=0.10"
 SAVE_RAW_ROOT=no
 DO_GCE=no
+DO_UPDATE=no
 
 if test -r config.custom ; then
    . $(pwd)/config.custom
@@ -29,8 +30,11 @@ while [ "$1" != "" ]; do
       DO_GCE=yes
       SAVE_RAW_ROOT=yes;
       ;;
+    --update)
+      DO_UPDATE=yes
+      ;;
     *)
-      echo "usage: gen-image [--save_raw_root] [--do_gce] [--mirror MIRROR_LOC]"
+      echo "usage: gen-image [--save_raw_root] [--do_gce] [--update] [--mirror MIRROR_LOC]"
       exit 1
       ;;
   esac
@@ -42,6 +46,31 @@ then
     RAW_ROOT_FS=/tmp/root_fs.raw.$$
 fi
 
+update_xfstests()
+{
+   tar -C $ROOTDIR/root -xf ../../xfstests.tar.gz
+   rsync -avH files/* $ROOTDIR
+}
+
+finalize_rootfs()
+{
+   e2fsck -fyD $RAW_ROOT_FS
+   e2fsck -fy -E discard $RAW_ROOT_FS
+   qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS
+}
+
+mkdir -p $ROOTDIR
+if test $DO_UPDATE = "yes" ; then
+   qemu-img convert -f qcow2 -O raw $ROOT_FS $RAW_ROOT_FS
+   mount -t ext4 -o loop $RAW_ROOT_FS $ROOTDIR
+   rm -rf $ROOTDIR/xfstests
+   update_xfstests
+   umount $ROOTDIR
+   rmdir $ROOTDIR
+   finalize_rootfs
+   exit 0
+fi
+
 mkdir -p gce
 if test $DO_GCE = "yes" ; then
     sh get-gce-debs
@@ -51,7 +80,6 @@ else
     variant=xfstests
 fi
 
-mkdir -p $ROOTDIR
 mkdir -p var.cache.apt.archives
 mkdir -p var.lib.apt.lists
 mkdir -p debs
@@ -69,9 +97,7 @@ mount --bind gce $ROOTDIR/gce
 mkdir -p $ROOTDIR/imgdir
 mount --bind $(dirname $RAW_ROOT_FS) $ROOTDIR/imgdir
 debootstrap --variant=$variant $ARCH $SUITE $ROOTDIR $MIRROR $DIR/kvm-xfstest.script
-cp -r files/* rootdir
-echo "untaring xfstests"
-tar -C rootdir/root -xf ../../xfstests.tar.gz
+update_xfstests
 for i in vda vdb vdc vdd vde vdf results
 do
 	mkdir $ROOTDIR/$i
@@ -139,9 +165,7 @@ rmdir $ROOTDIR
 
 if test $DO_GCE != "yes" ; then
    tune2fs -O has_journal $RAW_ROOT_FS
-   e2fsck -fyD $RAW_ROOT_FS
-   e2fsck -fy -E discard $RAW_ROOT_FS
-   qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS
+   finalize_rootfs
 fi
 
 if test "$SAVE_RAW_ROOT" = "yes" ; then
