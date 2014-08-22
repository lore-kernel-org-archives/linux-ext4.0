From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Fri, 22 Aug 2014 12:38:29 -0500
Message-ID: <53F78015.1000003@redhat.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com> <53F247D5.4030502@redhat.com> <CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com> <53F360FB.1090809@redhat.com> <CAMJSjjs=gRuoi5gYeR2hp4Nd9kT6TJb4xxH0cTv2zSEh976UHA@mail.gmail.com> <53F76B51.5090709@redhat.com> <CAMJSjjtQ742ngjxxfjPW_9H4J6Wr=yt_fCOGv-Hj4nie_q9R3Q@mail.gmail.com> <20140822171912.GA10163@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Mark Ballard <markjballard@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbaHVRiZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 13:38:25 -0400
In-Reply-To: <20140822171912.GA10163@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/22/14, 12:19 PM, Darrick J. Wong wrote:
> On Fri, Aug 22, 2014 at 05:40:02PM +0100, Mark Ballard wrote:
>> No, Eric. I can see it's accurate in its own context. I mean accurate
>> in relaying enough information to convey the situation accurately to
>> the user. That requires something like e2label to see a wider context,
>> and I can see that might actually be an unreasonable expectation. But
>> this is what I was getting at: information accurate enough to allow
>> non-educated users to get an instant grip of the environment when they
>> are forced to go delving under the bonnet (hood) of their computer.
>> None of the os componenets were made -- or documented -- with that
>> sort of user in mind: someone with less time and experience than is
>> really required to work efficiently under there. Yet the application
>> environment is such a tangle that users are left with little choice
>> but to get their hands dirty. And when you look under there, you see
>> that it was made by Heath Robinson but that the drawings were burned
>> in a fire.
> 
> Perhaps just use a little bit of libmagic to spit out what we might be looking
> at if the ext4 sb looks wrong?
> 
> # dumpe2fs -h /dev/sda2
> dumpe2fs 1.42.11 (09-Jul-2014)
> dumpe2fs: Bad magic number in super-block while trying to open /dev/sda
> Couldn't find valid filesystem superblock:
> /dev/sda2: LUKS encrypted file, ver 1 [aes, xts-plain64, sha1] UUID: <snip>

yeah, that's ... what I did, and showed, in my previous email.  ;)

this isn't great because it uses util.o in new places, and that's tough
to do from resize2fs/* etc, but anyway, here's the hack.

I could see how this could be useful (and your more verbose suggestion
above is probably better)


diff --git a/misc/Makefile.in b/misc/Makefile.in
index d3c8f5b..e779ee9 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -48,9 +48,9 @@ CHATTR_OBJS=	chattr.o
 LSATTR_OBJS=	lsattr.o
 UUIDGEN_OBJS=	uuidgen.o
 UUIDD_OBJS=	uuidd.o
-DUMPE2FS_OBJS=	dumpe2fs.o
+DUMPE2FS_OBJS=	dumpe2fs.o util.o
 BADBLOCKS_OBJS=	badblocks.o
-E2IMAGE_OBJS=	e2image.o
+E2IMAGE_OBJS=	e2image.o util.o
 FSCK_OBJS=	fsck.o base_device.o ismounted.o
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
@@ -198,12 +198,13 @@ blkid.profiled: $(BLKID_OBJS) $(DEPPROFILED_LIBBLKID) \
 e2image: $(E2IMAGE_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2image $(E2IMAGE_OBJS) $(LIBS) \
-		$(LIBINTL) $(SYSLIBS)
+		$(LIBBLKID) $(LIBINTL) $(SYSLIBS)
 
 e2image.profiled: $(E2IMAGE_OBJS) $(PROFILED_DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
-		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL) $(SYSLIBS)
+		$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LIBS) $(LIBINTL) $(SYSLIBS) \
+		$(PROFILED_LIBBLKID)
 
 e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
@@ -296,13 +297,13 @@ uuidd.profiled: $(UUIDD_OBJS) $(PROFILED_DEPLIBUUID)
 dumpe2fs: $(DUMPE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBUUID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o dumpe2fs $(DUMPE2FS_OBJS) $(LIBS) \
-		$(LIBS_E2P) $(LIBUUID) $(LIBINTL) $(SYSLIBS)
+		$(LIBS_E2P) $(LIBBLKID) $(LIBUUID) $(LIBINTL) $(SYSLIBS)
 
 dumpe2fs.profiled: $(DUMPE2FS_OBJS) $(PROFILED_DEPLIBS) \
 		$(PROFILED_LIBE2P) $(PROFILED_DEPLIBUUID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o dumpe2fs.profiled \
-		$(PROFILED_DUMPE2FS_OBJS) $(PROFILED_LIBS) \
+		$(PROFILED_DUMPE2FS_OBJS) $(PROFILED_LIBS) $(PROFILED_LIBBLKID) \
 		$(PROFILED_LIBE2P) $(PROFILED_LIBUUID) $(LIBINTL) $(SYSLIBS)
 
 fsck: $(FSCK_OBJS) $(DEPLIBBLKID)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 0b84ece..d11fe4d 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -38,6 +38,7 @@ extern int optind;
 #include "ext2fs/ext2fs.h"
 #include "e2p/e2p.h"
 #include "jfs_user.h"
+#include "util.h"
 #include <uuid/uuid.h>
 
 #include "../version.h"
@@ -50,6 +51,9 @@ static char * device_name = NULL;
 static int hex_format = 0;
 static int blocks64 = 0;
 
+int journal_size, journal_flags;		/* BLEAH!  BOO util.c!  */
+char *journal_device;
+
 static void usage(void)
 {
 	fprintf (stderr, _("Usage: %s [-bfhixV] [-o superblock=<num>] "
@@ -639,6 +643,7 @@ int main (int argc, char ** argv)
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
 		printf("%s", _("Couldn't find valid filesystem superblock.\n"));
+		check_plausibility(device_name, CHECK_FS_EXIST, NULL);
 		exit (1);
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
diff --git a/misc/e2image.c b/misc/e2image.c
index e1c63a7..f84b937 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -44,6 +44,7 @@ extern int optind;
 #include "e2p/e2p.h"
 #include "ext2fs/e2image.h"
 #include "ext2fs/qcow2.h"
+#include "util.h"
 
 #include "../version.h"
 #include "nls-enable.h"
@@ -72,6 +73,8 @@ static char move_mode;
 static char show_progress;
 static char *check_buf;
 static int skipped_blocks;
+int journal_size, journal_flags;		/* BLEAH!  BOO util.c!  */
+char *journal_device;
 
 static blk64_t align_offset(blk64_t offset, unsigned int n)
 {
@@ -1578,6 +1581,7 @@ int main (int argc, char ** argv)
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
 		fputs(_("Couldn't find valid filesystem superblock.\n"), stdout);
+		check_plausibility(device_name, CHECK_FS_EXIST, NULL);
 		exit(1);
 	}
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5aaea5e..c188182 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2560,9 +2560,11 @@ retry_open:
 			fprintf(stderr,
 				_("MMP block magic is bad. Try to fix it by "
 				  "running:\n'e2fsck -f %s'\n"), device_name);
-		else if (retval != EXT2_ET_MMP_FAILED)
+		else if (retval != EXT2_ET_MMP_FAILED) {
 			fprintf(stderr, "%s",
 			     _("Couldn't find valid filesystem superblock.\n"));
+			check_plausibility(device_name, CHECK_FS_EXIST, NULL);
+		}
 
 		ext2fs_free(fs);
 		exit(1);



