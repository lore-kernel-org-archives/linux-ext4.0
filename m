From: akpm@linux-foundation.org
Subject: [patch 156/196] tree-wide: convert open calls to remove spaces to skip_spaces() lib function
Date: Mon, 14 Dec 2009 18:01:06 -0800
Message-ID: <200912150201.nBF216rr021758@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, andre.goddard@gmail.com,
	dhowells@redhat.com, hmh@hmh.eng.br, hpa@zytor.com,
	jdike@addtoit.com, julia@diku.dk, kaber@trash.net,
	kyle@mcmartin.ca, linux-ext4@vger.kernel.org, mingo@elte.hu,
	neilb@suse.de, rpurdie@rpsys.net, samuel@sortiz.org,
	schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.de
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543AbZLOCDI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 21:03:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Makes use of skip_spaces() defined in lib/string.c for removing leading
spaces from strings all over the tree.

It decreases lib.a code size by 47 bytes and reuses the function tree-w=
ide:
   text    data     bss     dec     hex filename
  64688     584     592   65864   10148 (TOTALS-BEFORE)
  64641     584     592   65817   10119 (TOTALS-AFTER)

Also, while at it, if we see (*str && isspace(*str)), we can be sure to
remove the first condition (*str) as the second one (isspace(*str)) als=
o
evaluates to 0 whenever *str =3D=3D 0, making it redundant. In other wo=
rds,
"a char equals zero is never a space".

Julia Lawall tried the semantic patch (http://coccinelle.lip6.fr) below=
,
and found occurrences of this pattern on 3 more files:
    drivers/leds/led-class.c
    drivers/leds/ledtrig-timer.c
    drivers/video/output.c

@@
expression str;
@@

( // ignore skip_spaces cases
while (*str &&  isspace(*str)) { \(str++;\|++str;\) }
|
- *str &&
isspace(*str)
)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Julia Lawall <julia@diku.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/debug.c              |    3 +-
 arch/um/drivers/mconsole_kern.c       |   16 ++++------
 arch/x86/kernel/cpu/mtrr/if.c         |   11 ++-----
 drivers/leds/led-class.c              |    2 -
 drivers/leds/ledtrig-timer.c          |    4 +-
 drivers/md/dm-table.c                 |    6 +---
 drivers/md/md.c                       |    4 +-
 drivers/parisc/pdc_stable.c           |    9 ++----
 drivers/platform/x86/thinkpad_acpi.c  |    7 +---
 drivers/pnp/interface.c               |   36 ++++++------------------
 drivers/s390/block/dasd_proc.c        |    5 ++-
 drivers/video/backlight/lcd.c         |    4 +-
 drivers/video/display/display-sysfs.c |    2 -
 drivers/video/output.c                |    2 -
 fs/cachefiles/daemon.c                |    4 +-
 fs/ext4/super.c                       |    7 +---
 kernel/params.c                       |    8 ++---
 lib/argv_split.c                      |   13 ++------
 lib/dynamic_debug.c                   |    4 +-
 lib/vsprintf.c                        |   15 ++--------
 net/irda/irnet/irnet.h                |    1=20
 net/irda/irnet/irnet_ppp.c            |    8 ++---
 net/netfilter/xt_recent.c             |    3 --
 sound/pci/hda/hda_hwdep.c             |    7 ++--
 24 files changed, 66 insertions(+), 115 deletions(-)

diff -puN arch/s390/kernel/debug.c~tree-wide-convert-open-calls-to-remo=
ve-spaces-to-skip_spaces-lib-function arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~tree-wide-convert-open-calls-to-remove-s=
paces-to-skip_spaces-lib-function
+++ a/arch/s390/kernel/debug.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
@@ -1178,7 +1179,7 @@ debug_get_uint(char *buf)
 {
 	int rc;
=20
-	for(; isspace(*buf); buf++);
+	buf =3D skip_spaces(buf);
 	rc =3D simple_strtoul(buf, &buf, 10);
 	if(*buf){
 		rc =3D -EINVAL;
diff -puN arch/um/drivers/mconsole_kern.c~tree-wide-convert-open-calls-=
to-remove-spaces-to-skip_spaces-lib-function arch/um/drivers/mconsole_k=
ern.c
--- a/arch/um/drivers/mconsole_kern.c~tree-wide-convert-open-calls-to-r=
emove-spaces-to-skip_spaces-lib-function
+++ a/arch/um/drivers/mconsole_kern.c
@@ -6,6 +6,7 @@
=20
 #include <linux/console.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -131,7 +132,7 @@ void mconsole_proc(struct mc_request *re
 	char *ptr =3D req->request.data, *buf;
=20
 	ptr +=3D strlen("proc");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	proc =3D get_fs_type("proc");
 	if (proc =3D=3D NULL) {
@@ -212,8 +213,7 @@ void mconsole_proc(struct mc_request *re
 	char *ptr =3D req->request.data;
=20
 	ptr +=3D strlen("proc");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
 	snprintf(path, sizeof(path), "/proc/%s", ptr);
=20
 	fd =3D sys_open(path, 0, 0);
@@ -560,8 +560,7 @@ void mconsole_config(struct mc_request *
 	int err;
=20
 	ptr +=3D strlen("config");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
 	dev =3D mconsole_find_dev(ptr);
 	if (dev =3D=3D NULL) {
 		mconsole_reply(req, "Bad configuration option", 1, 0);
@@ -588,7 +587,7 @@ void mconsole_remove(struct mc_request *
 	int err, start, end, n;
=20
 	ptr +=3D strlen("remove");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
 	dev =3D mconsole_find_dev(ptr);
 	if (dev =3D=3D NULL) {
 		mconsole_reply(req, "Bad remove option", 1, 0);
@@ -712,7 +711,7 @@ void mconsole_sysrq(struct mc_request *r
 	char *ptr =3D req->request.data;
=20
 	ptr +=3D strlen("sysrq");
-	while (isspace(*ptr)) ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	/*
 	 * With 'b', the system will shut down without a chance to reply,
@@ -757,8 +756,7 @@ void mconsole_stack(struct mc_request *r
 	 */
=20
 	ptr +=3D strlen("stack");
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	/*
 	 * Should really check for multiple pids or reject bad args here
diff -puN arch/x86/kernel/cpu/mtrr/if.c~tree-wide-convert-open-calls-to=
-remove-spaces-to-skip_spaces-lib-function arch/x86/kernel/cpu/mtrr/if.=
c
--- a/arch/x86/kernel/cpu/mtrr/if.c~tree-wide-convert-open-calls-to-rem=
ove-spaces-to-skip_spaces-lib-function
+++ a/arch/x86/kernel/cpu/mtrr/if.c
@@ -4,6 +4,7 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/init.h>
=20
 #define LINE_SIZE 80
@@ -133,8 +134,7 @@ mtrr_write(struct file *file, const char
 		return -EINVAL;
=20
 	base =3D simple_strtoull(line + 5, &ptr, 0);
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	if (strncmp(ptr, "size=3D", 5))
 		return -EINVAL;
@@ -142,14 +142,11 @@ mtrr_write(struct file *file, const char
 	size =3D simple_strtoull(ptr + 5, &ptr, 0);
 	if ((base & 0xfff) || (size & 0xfff))
 		return -EINVAL;
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr);
=20
 	if (strncmp(ptr, "type=3D", 5))
 		return -EINVAL;
-	ptr +=3D 5;
-	while (isspace(*ptr))
-		ptr++;
+	ptr =3D skip_spaces(ptr + 5);
=20
 	for (i =3D 0; i < MTRR_NUM_TYPES; ++i) {
 		if (strcmp(ptr, mtrr_strings[i]))
diff -puN drivers/leds/led-class.c~tree-wide-convert-open-calls-to-remo=
ve-spaces-to-skip_spaces-lib-function drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~tree-wide-convert-open-calls-to-remove-s=
paces-to-skip_spaces-lib-function
+++ a/drivers/leds/led-class.c
@@ -50,7 +50,7 @@ static ssize_t led_brightness_store(stru
 	unsigned long state =3D simple_strtoul(buf, &after, 10);
 	size_t count =3D after - buf;
=20
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
=20
 	if (count =3D=3D size) {
diff -puN drivers/leds/ledtrig-timer.c~tree-wide-convert-open-calls-to-=
remove-spaces-to-skip_spaces-lib-function drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~tree-wide-convert-open-calls-to-remo=
ve-spaces-to-skip_spaces-lib-function
+++ a/drivers/leds/ledtrig-timer.c
@@ -83,7 +83,7 @@ static ssize_t led_delay_on_store(struct
 	unsigned long state =3D simple_strtoul(buf, &after, 10);
 	size_t count =3D after - buf;
=20
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
=20
 	if (count =3D=3D size) {
@@ -127,7 +127,7 @@ static ssize_t led_delay_off_store(struc
 	unsigned long state =3D simple_strtoul(buf, &after, 10);
 	size_t count =3D after - buf;
=20
-	if (*after && isspace(*after))
+	if (isspace(*after))
 		count++;
=20
 	if (count =3D=3D size) {
diff -puN drivers/md/dm-table.c~tree-wide-convert-open-calls-to-remove-=
spaces-to-skip_spaces-lib-function drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~tree-wide-convert-open-calls-to-remove-spac=
es-to-skip_spaces-lib-function
+++ a/drivers/md/dm-table.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
@@ -600,11 +601,8 @@ int dm_split_args(int *argc, char ***arg
 		return -ENOMEM;
=20
 	while (1) {
-		start =3D end;
-
 		/* Skip whitespace */
-		while (*start && isspace(*start))
-			start++;
+		start =3D skip_spaces(end);
=20
 		if (!*start)
 			break;	/* success, we hit the end */
diff -puN drivers/md/md.c~tree-wide-convert-open-calls-to-remove-spaces=
-to-skip_spaces-lib-function drivers/md/md.c
--- a/drivers/md/md.c~tree-wide-convert-open-calls-to-remove-spaces-to-=
skip_spaces-lib-function
+++ a/drivers/md/md.c
@@ -39,6 +39,7 @@
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
 #include <linux/random.h>
@@ -3246,8 +3247,7 @@ bitmap_store(mddev_t *mddev, const char=20
 		}
 		if (*end && !isspace(*end)) break;
 		bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
-		buf =3D end;
-		while (isspace(*buf)) buf++;
+		buf =3D skip_spaces(end);
 	}
 	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
 out:
diff -puN drivers/parisc/pdc_stable.c~tree-wide-convert-open-calls-to-r=
emove-spaces-to-skip_spaces-lib-function drivers/parisc/pdc_stable.c
--- a/drivers/parisc/pdc_stable.c~tree-wide-convert-open-calls-to-remov=
e-spaces-to-skip_spaces-lib-function
+++ a/drivers/parisc/pdc_stable.c
@@ -779,12 +779,9 @@ static ssize_t pdcs_auto_write(struct ko
 	read_unlock(&pathentry->rw_lock);
 =09
 	DPRINTK("%s: flags before: 0x%X\n", __func__, flags);
-		=09
-	temp =3D in;
-=09
-	while (*temp && isspace(*temp))
-		temp++;
-=09
+
+	temp =3D skip_spaces(in);
+
 	c =3D *temp++ - '0';
 	if ((c !=3D 0) && (c !=3D 1))
 		goto parse_error;
diff -puN drivers/platform/x86/thinkpad_acpi.c~tree-wide-convert-open-c=
alls-to-remove-spaces-to-skip_spaces-lib-function drivers/platform/x86/=
thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~tree-wide-convert-open-calls=
-to-remove-spaces-to-skip_spaces-lib-function
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -1006,11 +1006,8 @@ static int parse_strtoul(const char *buf
 {
 	char *endp;
=20
-	while (*buf && isspace(*buf))
-		buf++;
-	*value =3D simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value =3D simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp =3D skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
=20
diff -puN drivers/pnp/interface.c~tree-wide-convert-open-calls-to-remov=
e-spaces-to-skip_spaces-lib-function drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~tree-wide-convert-open-calls-to-remove-sp=
aces-to-skip_spaces-lib-function
+++ a/drivers/pnp/interface.c
@@ -310,8 +310,7 @@ static ssize_t pnp_set_current_resources
 		goto done;
 	}
=20
-	while (isspace(*buf))
-		++buf;
+	buf =3D skip_spaces(buf);
 	if (!strnicmp(buf, "disable", 7)) {
 		retval =3D pnp_disable_dev(dev);
 		goto done;
@@ -353,19 +352,13 @@ static ssize_t pnp_set_current_resources
 		pnp_init_resources(dev);
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
-			while (isspace(*buf))
-				++buf;
+			buf =3D skip_spaces(buf);
 			if (!strnicmp(buf, "io", 2)) {
-				buf +=3D 2;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 2);
 				start =3D simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf);
 				if (*buf =3D=3D '-') {
-					buf +=3D 1;
-					while (isspace(*buf))
-						++buf;
+					buf =3D skip_spaces(buf + 1);
 					end =3D simple_strtoul(buf, &buf, 0);
 				} else
 					end =3D start;
@@ -373,16 +366,11 @@ static ssize_t pnp_set_current_resources
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf);
 				if (*buf =3D=3D '-') {
-					buf +=3D 1;
-					while (isspace(*buf))
-						++buf;
+					buf =3D skip_spaces(buf + 1);
 					end =3D simple_strtoul(buf, &buf, 0);
 				} else
 					end =3D start;
@@ -390,17 +378,13 @@ static ssize_t pnp_set_current_resources
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
 				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
-				buf +=3D 3;
-				while (isspace(*buf))
-					++buf;
+				buf =3D skip_spaces(buf + 3);
 				start =3D simple_strtoul(buf, &buf, 0);
 				pnp_add_dma_resource(dev, start, 0);
 				continue;
diff -puN drivers/s390/block/dasd_proc.c~tree-wide-convert-open-calls-t=
o-remove-spaces-to-skip_spaces-lib-function drivers/s390/block/dasd_pro=
c.c
--- a/drivers/s390/block/dasd_proc.c~tree-wide-convert-open-calls-to-re=
move-spaces-to-skip_spaces-lib-function
+++ a/drivers/s390/block/dasd_proc.c
@@ -14,6 +14,7 @@
 #define KMSG_COMPONENT "dasd"
=20
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
@@ -272,10 +273,10 @@ dasd_statistics_write(struct file *file,
 	DBF_EVENT(DBF_DEBUG, "/proc/dasd/statictics: '%s'\n", buffer);
=20
 	/* check for valid verbs */
-	for (str =3D buffer; isspace(*str); str++);
+	str =3D skip_spaces(buffer);
 	if (strncmp(str, "set", 3) =3D=3D 0 && isspace(str[3])) {
 		/* 'set xxx' was given */
-		for (str =3D str + 4; isspace(*str); str++);
+		str =3D skip_spaces(str + 4);
 		if (strcmp(str, "on") =3D=3D 0) {
 			/* switch on statistics profiling */
 			dasd_profile_level =3D DASD_PROFILE_ON;
diff -puN drivers/video/backlight/lcd.c~tree-wide-convert-open-calls-to=
-remove-spaces-to-skip_spaces-lib-function drivers/video/backlight/lcd.=
c
--- a/drivers/video/backlight/lcd.c~tree-wide-convert-open-calls-to-rem=
ove-spaces-to-skip_spaces-lib-function
+++ a/drivers/video/backlight/lcd.c
@@ -101,7 +101,7 @@ static ssize_t lcd_store_power(struct de
 	int power =3D simple_strtoul(buf, &endp, 0);
 	size_t size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size !=3D count)
 		return -EINVAL;
@@ -140,7 +140,7 @@ static ssize_t lcd_store_contrast(struct
 	int contrast =3D simple_strtoul(buf, &endp, 0);
 	size_t size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size !=3D count)
 		return -EINVAL;
diff -puN drivers/video/display/display-sysfs.c~tree-wide-convert-open-=
calls-to-remove-spaces-to-skip_spaces-lib-function drivers/video/displa=
y/display-sysfs.c
--- a/drivers/video/display/display-sysfs.c~tree-wide-convert-open-call=
s-to-remove-spaces-to-skip_spaces-lib-function
+++ a/drivers/video/display/display-sysfs.c
@@ -67,7 +67,7 @@ static ssize_t display_store_contrast(st
 	contrast =3D simple_strtoul(buf, &endp, 0);
 	size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
=20
 	if (size !=3D count)
diff -puN drivers/video/output.c~tree-wide-convert-open-calls-to-remove=
-spaces-to-skip_spaces-lib-function drivers/video/output.c
--- a/drivers/video/output.c~tree-wide-convert-open-calls-to-remove-spa=
ces-to-skip_spaces-lib-function
+++ a/drivers/video/output.c
@@ -50,7 +50,7 @@ static ssize_t video_output_store_state(
 	int request_state =3D simple_strtoul(buf,&endp,0);
 	size_t size =3D endp - buf;
=20
-	if (*endp && isspace(*endp))
+	if (isspace(*endp))
 		size++;
 	if (size !=3D count)
 		return -EINVAL;
diff -puN fs/cachefiles/daemon.c~tree-wide-convert-open-calls-to-remove=
-spaces-to-skip_spaces-lib-function fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~tree-wide-convert-open-calls-to-remove-spa=
ces-to-skip_spaces-lib-function
+++ a/fs/cachefiles/daemon.c
@@ -21,6 +21,7 @@
 #include <linux/mount.h>
 #include <linux/statfs.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/fs_struct.h>
 #include "internal.h"
=20
@@ -257,8 +258,7 @@ static ssize_t cachefiles_daemon_write(s
 		if (args =3D=3D data)
 			goto error;
 		*args =3D '\0';
-		for (args++; isspace(*args); args++)
-			continue;
+		args =3D skip_spaces(++args);
 	}
=20
 	/* run the appropriate command handler */
diff -puN fs/ext4/super.c~tree-wide-convert-open-calls-to-remove-spaces=
-to-skip_spaces-lib-function fs/ext4/super.c
--- a/fs/ext4/super.c~tree-wide-convert-open-calls-to-remove-spaces-to-=
skip_spaces-lib-function
+++ a/fs/ext4/super.c
@@ -2137,11 +2137,8 @@ static int parse_strtoul(const char *buf
 {
 	char *endp;
=20
-	while (*buf && isspace(*buf))
-		buf++;
-	*value =3D simple_strtoul(buf, &endp, 0);
-	while (*endp && isspace(*endp))
-		endp++;
+	*value =3D simple_strtoul(skip_spaces(buf), &endp, 0);
+	endp =3D skip_spaces(endp);
 	if (*endp || *value > max)
 		return -EINVAL;
=20
diff -puN kernel/params.c~tree-wide-convert-open-calls-to-remove-spaces=
-to-skip_spaces-lib-function kernel/params.c
--- a/kernel/params.c~tree-wide-convert-open-calls-to-remove-spaces-to-=
skip_spaces-lib-function
+++ a/kernel/params.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
=20
 #if 0
 #define DEBUGP printk
@@ -122,9 +123,7 @@ static char *next_arg(char *args, char *
 		next =3D args + i;
=20
 	/* Chew up trailing spaces. */
-	while (isspace(*next))
-		next++;
-	return next;
+	return skip_spaces(next);
 }
=20
 /* Args looks like "foo=3Dbar,bar2 baz=3Dfuz wiz". */
@@ -139,8 +138,7 @@ int parse_args(const char *name,
 	DEBUGP("Parsing ARGS: %s\n", args);
=20
 	/* Chew leading spaces */
-	while (isspace(*args))
-		args++;
+	args =3D skip_spaces(args);
=20
 	while (*args) {
 		int ret;
diff -puN lib/argv_split.c~tree-wide-convert-open-calls-to-remove-space=
s-to-skip_spaces-lib-function lib/argv_split.c
--- a/lib/argv_split.c~tree-wide-convert-open-calls-to-remove-spaces-to=
-skip_spaces-lib-function
+++ a/lib/argv_split.c
@@ -4,17 +4,10 @@
=20
 #include <linux/kernel.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/module.h>
=20
-static const char *skip_sep(const char *cp)
-{
-	while (*cp && isspace(*cp))
-		cp++;
-
-	return cp;
-}
-
 static const char *skip_arg(const char *cp)
 {
 	while (*cp && !isspace(*cp))
@@ -28,7 +21,7 @@ static int count_argc(const char *str)
 	int count =3D 0;
=20
 	while (*str) {
-		str =3D skip_sep(str);
+		str =3D skip_spaces(str);
 		if (*str) {
 			count++;
 			str =3D skip_arg(str);
@@ -82,7 +75,7 @@ char **argv_split(gfp_t gfp, const char=20
 	argvp =3D argv;
=20
 	while (*str) {
-		str =3D skip_sep(str);
+		str =3D skip_spaces(str);
=20
 		if (*str) {
 			const char *p =3D str;
diff -puN lib/dynamic_debug.c~tree-wide-convert-open-calls-to-remove-sp=
aces-to-skip_spaces-lib-function lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~tree-wide-convert-open-calls-to-remove-spaces=
-to-skip_spaces-lib-function
+++ a/lib/dynamic_debug.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
@@ -209,8 +210,7 @@ static int ddebug_tokenize(char *buf, ch
 		char *end;
=20
 		/* Skip leading whitespace */
-		while (*buf && isspace(*buf))
-			buf++;
+		buf =3D skip_spaces(buf);
 		if (!*buf)
 			break;	/* oh, it was trailing whitespace */
=20
diff -puN lib/vsprintf.c~tree-wide-convert-open-calls-to-remove-spaces-=
to-skip_spaces-lib-function lib/vsprintf.c
--- a/lib/vsprintf.c~tree-wide-convert-open-calls-to-remove-spaces-to-s=
kip_spaces-lib-function
+++ a/lib/vsprintf.c
@@ -1766,13 +1766,6 @@ EXPORT_SYMBOL_GPL(bprintf);
=20
 #endif /* CONFIG_BINARY_PRINTF */
=20
-static noinline char *skip_space(const char *str)
-{
-	while (isspace(*str))
-		++str;
-	return (char *)str;
-}
-
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1794,8 +1787,8 @@ int vsscanf(const char *buf, const char=20
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			fmt =3D skip_space(fmt);
-			str =3D skip_space(str);
+			fmt =3D skip_spaces(++fmt);
+			str =3D skip_spaces(str);
 		}
=20
 		/* anything that is not a conversion must match exactly */
@@ -1865,7 +1858,7 @@ int vsscanf(const char *buf, const char=20
 			if (field_width =3D=3D -1)
 				field_width =3D INT_MAX;
 			/* first, skip leading white space in buffer */
-			str =3D skip_space(str);
+			str =3D skip_spaces(str);
=20
 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1907,7 +1900,7 @@ int vsscanf(const char *buf, const char=20
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		str =3D skip_space(str);
+		str =3D skip_spaces(str);
=20
 		digit =3D *str;
 		if (is_sign && digit =3D=3D '-')
diff -puN net/irda/irnet/irnet.h~tree-wide-convert-open-calls-to-remove=
-spaces-to-skip_spaces-lib-function net/irda/irnet/irnet.h
--- a/net/irda/irnet/irnet.h~tree-wide-convert-open-calls-to-remove-spa=
ces-to-skip_spaces-lib-function
+++ a/net/irda/irnet/irnet.h
@@ -249,6 +249,7 @@
 #include <linux/poll.h>
 #include <linux/capability.h>
 #include <linux/ctype.h>	/* isspace() */
+#include <linux/string.h>	/* skip_spaces() */
 #include <asm/uaccess.h>
 #include <linux/init.h>
=20
diff -puN net/irda/irnet/irnet_ppp.c~tree-wide-convert-open-calls-to-re=
move-spaces-to-skip_spaces-lib-function net/irda/irnet/irnet_ppp.c
--- a/net/irda/irnet/irnet_ppp.c~tree-wide-convert-open-calls-to-remove=
-spaces-to-skip_spaces-lib-function
+++ a/net/irda/irnet/irnet_ppp.c
@@ -76,9 +76,8 @@ irnet_ctrl_write(irnet_socket *	ap,
       /* Look at the next command */
       start =3D next;
=20
-      /* Scrap whitespaces before the command */
-      while(isspace(*start))
-	start++;
+	/* Scrap whitespaces before the command */
+	start =3D skip_spaces(start);
=20
       /* ',' is our command separator */
       next =3D strchr(start, ',');
@@ -133,8 +132,7 @@ irnet_ctrl_write(irnet_socket *	ap,
 	      char *	endp;
=20
 	      /* Scrap whitespaces before the command */
-	      while(isspace(*begp))
-		begp++;
+	      begp =3D skip_spaces(begp);
=20
 	      /* Convert argument to a number (last arg is the base) */
 	      addr =3D simple_strtoul(begp, &endp, 16);
diff -puN net/netfilter/xt_recent.c~tree-wide-convert-open-calls-to-rem=
ove-spaces-to-skip_spaces-lib-function net/netfilter/xt_recent.c
--- a/net/netfilter/xt_recent.c~tree-wide-convert-open-calls-to-remove-=
spaces-to-skip_spaces-lib-function
+++ a/net/netfilter/xt_recent.c
@@ -482,8 +482,7 @@ static ssize_t recent_old_proc_write(str
 	if (copy_from_user(buf, input, size))
 		return -EFAULT;
=20
-	while (isspace(*c))
-		c++;
+	c =3D skip_spaces(c);
=20
 	if (size - (c - buf) < 5)
 		return c - buf;
diff -puN sound/pci/hda/hda_hwdep.c~tree-wide-convert-open-calls-to-rem=
ove-spaces-to-skip_spaces-lib-function sound/pci/hda/hda_hwdep.c
--- a/sound/pci/hda/hda_hwdep.c~tree-wide-convert-open-calls-to-remove-=
spaces-to-skip_spaces-lib-function
+++ a/sound/pci/hda/hda_hwdep.c
@@ -24,6 +24,7 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/firmware.h>
 #include <sound/core.h>
 #include "hda_codec.h"
@@ -428,8 +429,7 @@ static int parse_hints(struct hda_codec=20
 	char *key, *val;
 	struct hda_hint *hint;
=20
-	while (isspace(*buf))
-		buf++;
+	buf =3D skip_spaces(buf);
 	if (!*buf || *buf =3D=3D '#' || *buf =3D=3D '\n')
 		return 0;
 	if (*buf =3D=3D '=3D')
@@ -444,8 +444,7 @@ static int parse_hints(struct hda_codec=20
 		return -EINVAL;
 	}
 	*val++ =3D 0;
-	while (isspace(*val))
-		val++;
+	val =3D skip_spaces(val);
 	remove_trail_spaces(key);
 	remove_trail_spaces(val);
 	hint =3D get_hint(codec, key);
_
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
