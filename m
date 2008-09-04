From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] resend : badblocks - Print progress in percent complete and time elapsed in verbose mode.
Date: Thu, 4 Sep 2008 14:44:38 +0530
Message-ID: <ea11fea30809040214r5d5d3e41ifa32118b2e93660d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:1227 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYIDJOl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2008 05:14:41 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1916449tic.23
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2008 02:14:38 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previous patch that I sent had some redundant unused variables.
Removing them and also removing the file sys/time.h which is included
twice.


Make badblocks -v print percent complete and time elapsed. Addresses
debian bug# 429739.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 misc/badblocks.8.in |    5 +++-
 misc/badblocks.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/misc/badblocks.8.in b/misc/badblocks.8.in
index 5a10f8a..34e1bbd 100644
--- a/misc/badblocks.8.in
+++ b/misc/badblocks.8.in
@@ -5,7 +5,7 @@ badblocks \- search a device for bad blocks
 .SH SYNOPSIS
 .B badblocks
 [
-.B \-svwnf
+.B \-svVwnf
 ]
 [
 .B \-b
@@ -181,6 +181,9 @@ are checked.
 .B \-v
 Verbose mode.
 .TP
+.B \-V
+Verbose mode showing progress in percent complete and time elapsed.
+.TP
 .B \-w
 Use write-mode test. With this option,
 .B badblocks
diff --git a/misc/badblocks.c b/misc/badblocks.c
index 1d0f95a..59e5eee 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -55,7 +55,6 @@ extern int optind;
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <sys/time.h>

 #include "et/com_err.h"
 #include "ext2fs/ext2_io.h"
@@ -64,9 +63,10 @@ extern int optind;
 #include "nls-enable.h"

 const char * program_name = "badblocks";
-const char * done_string = N_("done                                \n");
+const char * done_string = N_("done
           \n");

 static int v_flag = 0;			/* verbose */
+static int V_flag = 0;			/* verbose with percentages and time elapsed*/
 static int w_flag = 0;			/* do r/w test: 0=no, 1=yes,
 					 * 2=non-destructive */
 static int s_flag = 0;			/* show progress of test */
@@ -78,15 +78,18 @@ static int current_O_DIRECT = 0;	/* Current status
of O_DIRECT flag */
 static int exclusive_ok = 0;
 static unsigned int max_bb = 0;		/* Abort test if more than this
number of bad blocks has been encountered */
 static unsigned int d_flag = 0;		/* delay factor between reads */
+static struct timeval time_start;

 #define T_INC 32
+#define MAX_STATUS_LEN 21
+#define SPACE_CHAR ' '

 unsigned int sys_page_size = 4096;

 static void usage(void)
 {
 	fprintf(stderr, _(
-"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnf]\n"
+"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svVwnf]\n"
 "       [-c blocks_at_once] [-d delay_factor_between_reads] [-e
max_bad_blocks]\n"
 "       [-p num_passes] [-t test_pattern [-t test_pattern [...]]]\n"
 "       device [last_block [first_block]]\n"),
@@ -109,6 +112,32 @@ static FILE *out;
 static blk_t next_bad = 0;
 static ext2_badblocks_iterate bb_iter = NULL;

+static __inline__ void init_resource()
+{
+	gettimeofday(&time_start, 0);
+	return;
+}
+
+static __inline__ void timeval_format(struct timeval *tv1,
+			      struct timeval *tv2,char *elapsed)
+{
+        __time_t diff = (tv1->tv_sec - tv2->tv_sec);
+	char *tmp = elapsed;
+	if (diff/3600) {
+		sprintf(tmp,"%3dh:",diff/3600);
+		diff %= 3600;
+		tmp +=5;
+	}
+	if (diff/60) {
+		sprintf(tmp,"%02dm:",diff/60);
+		diff %= 60;
+		tmp +=4;
+	}
+	sprintf(tmp,"%02ds elapsed",diff);
+	tmp[11] = SPACE_CHAR;
+	return;
+}
+
 static void *allocate_buffer(size_t size)
 {
 	void	*ret = 0;
@@ -161,11 +190,35 @@ static int bb_output (blk_t bad)
 	return 1;
 }

+static float calc_percent(unsigned long current, unsigned long total) {
+	float percent = 0.0;
+	if (total <= 0)
+		return percent;
+	if (current >= total) {
+		percent = 100.0;
+	} else {
+		percent=(100.0*(float)current/(float)total);
+	}
+	return percent;
+}
+
 static void print_status(void)
 {
-	fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing,
-		(unsigned long) num_blocks);
-	fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
stderr);
+	if(V_flag) {
+		struct timeval time_end;
+		char elapsed[MAX_STATUS_LEN];
+		memset(elapsed,SPACE_CHAR,MAX_STATUS_LEN);
+		elapsed[MAX_STATUS_LEN] = 0;
+		gettimeofday(&time_end, 0);
+		timeval_format(&time_end,&time_start,elapsed);
+		fprintf(stderr, "  %6.2f%% done, %s", calc_percent((unsigned long)
currently_testing,
+					(unsigned long) num_blocks),elapsed);
+		fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b""\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
stderr);
+	} else {
+		fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing,
+				(unsigned long) num_blocks);
+		fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
stderr);
+	}
 	fflush (stderr);
 }

@@ -965,7 +1018,7 @@ int main (int argc, char ** argv)

 	if (argc && *argv)
 		program_name = *argv;
-	while ((c = getopt (argc, argv, "b:d:e:fi:o:svwnc:p:h:t:X")) != EOF) {
+	while ((c = getopt (argc, argv, "b:d:e:fi:o:svVwnc:p:h:t:X")) != EOF) {
 		switch (c) {
 		case 'b':
 			block_size = parse_uint(optarg, "block size");
@@ -987,6 +1040,9 @@ int main (int argc, char ** argv)
 		case 's':
 			s_flag = 1;
 			break;
+		case 'V':
+			V_flag++;
+			init_resource();
 		case 'v':
 			v_flag++;
 			break;
-- 
1.5.4.3


Thanks -
Manish

On Thu, Sep 4, 2008 at 12:32 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Hi Ted,
>
> I am trying to address debian bug# 429739 to print the progress of
> badblocks in percent and time elapsed. I have added a new option '-V'
> which instead of showing progress in blocks gives output as below.
>
> /home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ./badblocks -V myfs
> Checking blocks 0 to 2353935
> Checking for bad blocks (read-only test):    16.68% done, 14s elapsed
>
> /home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ./badblocks -V myfs
> Checking blocks 0 to 2353935
> Checking for bad blocks (read-only test):    86.79% done, 01m:04s elapsed
>
>
> Appreciate your comments on the below patch.
>
> Make badblocks -v print percent complete and time elapsed. Addresses
> debian bug# 429739.
>
> Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>
>
> ---
>  misc/badblocks.8.in |    5 +++-
>  misc/badblocks.c    |   71 ++++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 69 insertions(+), 7 deletions(-)
>
> diff --git a/misc/badblocks.8.in b/misc/badblocks.8.in
> index 5a10f8a..34e1bbd 100644
> --- a/misc/badblocks.8.in
> +++ b/misc/badblocks.8.in
> @@ -5,7 +5,7 @@ badblocks \- search a device for bad blocks
>  .SH SYNOPSIS
>  .B badblocks
>  [
> -.B \-svwnf
> +.B \-svVwnf
>  ]
>  [
>  .B \-b
> @@ -181,6 +181,9 @@ are checked.
>  .B \-v
>  Verbose mode.
>  .TP
> +.B \-V
> +Verbose mode showing progress in percent complete and time elapsed.
> +.TP
>  .B \-w
>  Use write-mode test. With this option,
>  .B badblocks
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index 1d0f95a..902745e 100644
> --- a/misc/badblocks.c
> +++ b/misc/badblocks.c
> @@ -56,6 +56,7 @@ extern int optind;
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
>  #include <sys/time.h>
> +#include <sys/resource.h>
>
>  #include "et/com_err.h"
>  #include "ext2fs/ext2_io.h"
> @@ -64,9 +65,10 @@ extern int optind;
>  #include "nls-enable.h"
>
>  const char * program_name = "badblocks";
> -const char * done_string = N_("done                                \n");
> +const char * done_string = N_("done
>           \n");
>
>  static int v_flag = 0;                 /* verbose */
> +static int V_flag = 0;                 /* verbose with percentage and time elapsed*/
>  static int w_flag = 0;                 /* do r/w test: 0=no, 1=yes,
>                                         * 2=non-destructive */
>  static int s_flag = 0;                 /* show progress of test */
> @@ -78,15 +80,18 @@ static int current_O_DIRECT = 0;    /* Current status
> of O_DIRECT flag */
>  static int exclusive_ok = 0;
>  static unsigned int max_bb = 0;                /* Abort test if more than this
> number of bad blocks has been encountered */
>  static unsigned int d_flag = 0;                /* delay factor between reads */
> +static struct timeval time_start;
>
>  #define T_INC 32
> +#define MAX_STATUS_LEN 21
> +#define SPACE_CHAR ' '
>
>  unsigned int sys_page_size = 4096;
>
>  static void usage(void)
>  {
>        fprintf(stderr, _(
> -"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svwnf]\n"
> +"Usage: %s [-b block_size] [-i input_file] [-o output_file] [-svVwnf]\n"
>  "       [-c blocks_at_once] [-d delay_factor_between_reads] [-e
> max_bad_blocks]\n"
>  "       [-p num_passes] [-t test_pattern [-t test_pattern [...]]]\n"
>  "       device [last_block [first_block]]\n"),
> @@ -109,6 +114,32 @@ static FILE *out;
>  static blk_t next_bad = 0;
>  static ext2_badblocks_iterate bb_iter = NULL;
>
> +static __inline__ void init_resource()
> +{
> +       gettimeofday(&time_start, 0);
> +       return;
> +}
> +
> +static __inline__ void timeval_format(struct timeval *tv1,
> +                             struct timeval *tv2,char *elapsed)
> +{
> +     __time_t diff = (tv1->tv_sec - tv2->tv_sec);
> +       char *tmp = elapsed;
> +       if (diff/3600) {
> +               sprintf(tmp,"%3dh:",diff/3600);
> +               diff %= 3600;
> +               tmp +=5;
> +       }
> +       if (diff/60) {
> +               sprintf(tmp,"%02dm:",diff/60);
> +               diff %= 60;
> +               tmp +=4;
> +       }
> +       sprintf(tmp,"%02ds elapsed",diff);
> +       tmp[11] = SPACE_CHAR;
> +       return;
> +}
> +
>  static void *allocate_buffer(size_t size)
>  {
>        void    *ret = 0;
> @@ -161,11 +192,36 @@ static int bb_output (blk_t bad)
>        return 1;
>  }
>
> +static float calc_percent(unsigned long current, unsigned long total) {
> +       float percent = 0.0;
> +       if (total <= 0)
> +               return percent;
> +       if (current >= total) {
> +               percent = 100.0;
> +       } else {
> +               percent=(100.0*(float)current/(float)total);
> +       }
> +       return percent;
> +}
> +
>  static void print_status(void)
>  {
> -       fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing,
> -               (unsigned long) num_blocks);
> -       fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
> stderr);
> +       if(V_flag) {
> +               struct rusage r;
> +               struct timeval time_end;
> +               char elapsed[MAX_STATUS_LEN];
> +               memset(elapsed,SPACE_CHAR,MAX_STATUS_LEN);
> +               elapsed[MAX_STATUS_LEN] = 0;
> +               gettimeofday(&time_end, 0);
> +               timeval_format(&time_end,&time_start,elapsed);
> +               fprintf(stderr, "  %6.2f%% done, %s", calc_percent((unsigned long)
> currently_testing,
> +                                       (unsigned long) num_blocks),elapsed);
> +               fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b""\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
> stderr);
> +       } else {
> +               fprintf(stderr, "%15lu/%15lu", (unsigned long) currently_testing,
> +                               (unsigned long) num_blocks);
> +               fputs("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b",
> stderr);
> +       }
>        fflush (stderr);
>  }
>
> @@ -965,7 +1021,7 @@ int main (int argc, char ** argv)
>
>        if (argc && *argv)
>                program_name = *argv;
> -       while ((c = getopt (argc, argv, "b:d:e:fi:o:svwnc:p:h:t:X")) != EOF) {
> +       while ((c = getopt (argc, argv, "b:d:e:fi:o:svVwnc:p:h:t:X")) != EOF) {
>                switch (c) {
>                case 'b':
>                        block_size = parse_uint(optarg, "block size");
> @@ -987,6 +1043,9 @@ int main (int argc, char ** argv)
>                case 's':
>                        s_flag = 1;
>                        break;
> +               case 'V':
> +                       V_flag++;
> +                       init_resource();
>                case 'v':
>                        v_flag++;
>                        break;
> --
> 1.5.4.3
>
>
>
> Thanks -
> Manish
>
