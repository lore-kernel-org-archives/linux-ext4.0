From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Subject: Re: [PATCH] badblocks: Add options for parseable status output
Date: Mon, 6 Nov 2017 14:21:12 -0500
Message-ID: <91b8b7f5-6054-77c9-d1f8-aa6ad6408a2d@keepertech.com>
References: <75e965d0-a9a4-a50d-5d54-429e3751cdc4@keepertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:48165 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932576AbdKFTVP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Nov 2017 14:21:15 -0500
Received: by mail-qk0-f194.google.com with SMTP id a142so3573781qkb.5
        for <linux-ext4@vger.kernel.org>; Mon, 06 Nov 2017 11:21:15 -0800 (PST)
Received: from wills-mbp-3.keepertech.com (50-245-231-209-static.hfc.comcastbusiness.net. [50.245.231.209])
        by smtp.gmail.com with ESMTPSA id c64sm8510425qkd.67.2017.11.06.11.21.12
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Nov 2017 11:21:13 -0800 (PST)
In-Reply-To: <75e965d0-a9a4-a50d-5d54-429e3751cdc4@keepertech.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(Resubmitting with proper formatting)

This patch adds a couple of new command line arguments
to make it easier to control the frequency of the status output and make the
output more parseable.

[-a alarm_interval ]   Control the frequency of status output (in seconds)
[-P] makes the output more parseable by external programs
     (comma separated, LF terminated)
 

Signed-off-by: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
---
 misc/badblocks.8.in | 16 +++++++++++++++-
 misc/badblocks.c    | 52
++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/misc/badblocks.8.in b/misc/badblocks.8.in
index ca4359382..043e420db 100644
--- a/misc/badblocks.8.in
+++ b/misc/badblocks.8.in
@@ -5,7 +5,11 @@ badblocks \- search a device for bad blocks
 .SH SYNOPSIS
 .B badblocks
 [
-.B \-svwnfBX
+.B \-svwnfBXP
+]
+[
+.B \-a
+.I alarm_interval
 ]
 [
 .B \-b
@@ -83,6 +87,9 @@ and
 programs.
 .SH OPTIONS
 .TP
+.BI \-a " alarm_interval"
+Interval (in seconds) used for displaying status updates. The default is 1.
+.TP
 .BI \-b " block_size"
 Specify the size of blocks in bytes.  The default is 1024.
 .TP
@@ -199,6 +206,13 @@ option, as they are mutually exclusive.
 .B \-B
 Use buffered I/O and do not use Direct I/O, even if it is available.
 .TP
+.B \-P
+Display status in machine parseable format. The data is comma separated and
+LF terminated to make it easier to parsing by external applications. The
+data format is:
+% completed, time elapsed, read errors, write errors, corruption errors.
+Example: 10.06, 1:22, 0, 0, 0
+.TP
 .B \-X
 Internal flag only to be used by
 .BR e2fsck (8)
diff --git a/misc/badblocks.c b/misc/badblocks.c
index e45939187..571856c21 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -84,6 +84,8 @@ static int t_max;            /* allocated test patterns */
 static unsigned int *t_patts;        /* test patterns */
 static int use_buffered_io;
 static int exclusive_ok;
+static int parseable_output = 0;  /* print output that can be easily
parsed */
+static int alarm_interval = 1;
 static unsigned int max_bb = MAX_BAD_BLOCKS;    /* Abort test if more
than this
                          * number of bad blocks has been
                          * encountered */
@@ -97,9 +99,10 @@ static unsigned int sys_page_size = 4096;
 static void usage(void)
 {
     fprintf(stderr, _(
-"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnf]\n"
+"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnfP]\n"
 "       [-c blocks_at_once] [-d delay_factor_between_reads] [-e
max_bad_blocks]\n"
 "       [-p num_passes] [-t test_pattern [-t test_pattern [...]]]\n"
+"       [-a alarm_interval]\n"
 "       device [last_block [first_block]]\n"),
          program_name);
     exit (1);
@@ -223,17 +226,23 @@ static void print_status(void)
     wchar_t wline_buf[128];
 #endif
     int len;
+    char format_str[128];
+
+    if (parseable_output) {
+        strcpy(format_str, "%6.2f, %s, %d, %d, %d");
+    } else {
+        strcpy(format_str, "%6.2f%% done, %s elapsed. (%d/%d/%d errors)");
+    }
 
     gettimeofday(&time_end, 0);
     len = snprintf(line_buf, sizeof(line_buf),
-               _("%6.2f%% done, %s elapsed. "
-                 "(%d/%d/%d errors)"),
-               calc_percent((unsigned long) currently_testing,
-                    (unsigned long) num_blocks),
-               time_diff_format(&time_end, &time_start, diff_buf),
-               num_read_errors,
-               num_write_errors,
-               num_corruption_errors);
+            _(format_str),
+            calc_percent((unsigned long) currently_testing,
+            (unsigned long) num_blocks),
+            time_diff_format(&time_end, &time_start, diff_buf),
+            num_read_errors,
+            num_write_errors,
+            num_corruption_errors);
 #ifdef HAVE_MBSTOWCS
     mbstowcs(wline_buf, line_buf, sizeof(line_buf));
     len = wcswidth(wline_buf, sizeof(line_buf));
@@ -241,16 +250,20 @@ static void print_status(void)
         len = strlen(line_buf); /* Should never happen... */
 #endif
     fputs(line_buf, stderr);
-    memset(line_buf, '\b', len);
-    line_buf[len] = 0;
-    fputs(line_buf, stderr);   
+    if (!parseable_output) {
+        memset(line_buf, '\b', len);
+        line_buf[len] = 0;
+        fputs(line_buf, stderr);
+    } else {
+        fputs("\n", stderr);
+    }
     fflush (stderr);
 }
 
 static void alarm_intr(int alnum EXT2FS_ATTR((unused)))
 {
     signal (SIGALRM, alarm_intr);
-    alarm(1);
+    alarm(alarm_interval);
     if (!num_blocks)
         return;
     print_status();
@@ -1094,7 +1107,7 @@ int main (int argc, char ** argv)
 
     if (argc && *argv)
         program_name = *argv;
-    while ((c = getopt (argc, argv, "b:d:e:fi:o:svwnc:p:h:t:BX")) != EOF) {
+    while ((c = getopt (argc, argv, "a:b:d:e:fi:o:svwnc:p:h:t:BXP")) !=
EOF) {
         switch (c) {
         case 'b':
             block_size = parse_uint(optarg, "block size");
@@ -1183,6 +1196,17 @@ int main (int argc, char ** argv)
         case 'X':
             exclusive_ok++;
             break;
+        case 'P':
+            parseable_output = 1;
+            break;
+        case 'a':
+            alarm_interval = parse_uint(optarg, "status alarm interval
(seconds)");
+            if (alarm_interval == 0) {
+                com_err(program_name, 0, "%s",
+                    _("Minimum alarm interval is 1 second"));
+                exit(1);
+            }
+            break;
         default:
             usage();
         }
