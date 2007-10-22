From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] badblocks: Factor out calls to strtoul to a helper function
Date: Mon, 22 Oct 2007 11:19:22 -0400
Message-ID: <1193066362-11222-3-git-send-email-tytso@mit.edu>
References: <20071022141641.GA6619@thunk.org>
 <1193066362-11222-1-git-send-email-tytso@mit.edu>
 <1193066362-11222-2-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbXJVPTe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 11:19:34 -0400
In-Reply-To: <1193066362-11222-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The strtoul() function has a lot of messy error checking that needs to
be done; by factoring it out into one place we can make sure it's done
right in all of the places where it is called.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/badblocks.c |   61 ++++++++++++++++++++++-------------------------------
 1 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index a768a8a..709effe 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -819,11 +819,27 @@ static void check_mount(char *device_name)
 
 }
 
+/*
+ * This function will convert a string to an unsigned long, printing
+ * an error message if it fails, and returning success or failure in err.
+ */
+static unsigned int parse_uint(const char *str, const char *descr)
+{
+	char		*tmp;
+	unsigned long	ret;
+	
+	ret = strtoul(str, &tmp, 0);
+	if (*tmp || errno || (ret > UINT_MAX) ||
+	    (ret == ULONG_MAX && errno == ERANGE)) {
+		com_err (program_name, 0, _("invalid %s - %s"), descr, str);
+		exit (1);
+	}
+	return ret;
+}
 
 int main (int argc, char ** argv)
 {
 	int c;
-	char * tmp;
 	char * device_name;
 	char * host_device_name = NULL;
 	char * input_file = NULL;
@@ -871,8 +887,8 @@ int main (int argc, char ** argv)
 	while ((c = getopt (argc, argv, "b:fi:o:svwnc:p:h:t:X")) != EOF) {
 		switch (c) {
 		case 'b':
-			block_size = strtoul (optarg, &tmp, 0);
-			if (*tmp || block_size > 4096) {
+			block_size = parse_uint(optarg, "block size");
+			if (block_size > 4096) {
 				com_err (program_name, 0,
 					 _("bad block size - %s"), optarg);
 				exit (1);
@@ -906,20 +922,11 @@ int main (int argc, char ** argv)
 			w_flag = 2;
 			break;
 		case 'c':
-			blocks_at_once = strtoul (optarg, &tmp, 0);
-			if (*tmp) {
-				com_err (program_name, 0,
-					 "bad simultaneous block count - %s", optarg);
-				exit (1);
-			}
+			blocks_at_once = parse_uint(optarg, "blocks at once");
 			break;
 		case 'p':
-			num_passes = strtoul (optarg, &tmp, 0);
-			if (*tmp) {
-				com_err (program_name, 0,
-				    "bad number of clean passes - %s", optarg);
-				exit (1);
-			}
+			num_passes = parse_uint(optarg, 
+						"number of clean passes");
 			break;
 		case 'h':
 			host_device_name = optarg;
@@ -942,13 +949,7 @@ int main (int argc, char ** argv)
 			if (!strcmp(optarg, "r") || !strcmp(optarg,"random")) {
 				t_patts[t_flag++] = ~0;
 			} else {
-				pattern = strtoul(optarg, &tmp, 0);
-				if (*tmp) {
-					com_err(program_name, 0,
-					_("invalid test_pattern: %s\n"),
-						optarg);
-					exit(1);
-				}
+				pattern = parse_uint(optarg, "test pattern");
 				if (pattern == (unsigned int) ~0)
 					pattern = 0xffff;
 				t_patts[t_flag++] = pattern;
@@ -995,27 +996,15 @@ int main (int argc, char ** argv)
 		}
 	} else {
 		errno = 0;
-		last_block = strtoul (argv[optind], &tmp, 0);
+		last_block = parse_uint(argv[optind], "last block");
 		printf("last_block = %d (%s)\n", last_block, argv[optind]);
-		if (*tmp || errno || 
-		    (last_block == ULONG_MAX && errno == ERANGE)) {
-			com_err (program_name, 0, _("invalid blocks count - %s"),
-				 argv[optind]);
-			exit (1);
-		}
 		last_block++;
 		optind++;
 	}
 	if (optind <= argc-1) {
 		errno = 0;
-		from_count = strtoul (argv[optind], &tmp, 0);
+		from_count = parse_uint(argv[optind], "start block");
 		printf("from_count = %d\n", from_count);
-		if (*tmp || errno ||
-		    (from_count == ULONG_MAX && errno == ERANGE)) {
-			com_err (program_name, 0, _("invalid starting block - %s"),
-				 argv[optind]);
-			exit (1);
-		}
 	} else from_count = 0;
 	if (from_count >= last_block) {
 	    com_err (program_name, 0, _("invalid starting block (%lu): must be less than %lu"),
-- 
1.5.3.4.1232.g9991d-dirty
