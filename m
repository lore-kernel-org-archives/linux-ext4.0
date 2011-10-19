From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/8] xfstests: add different logging option to fsstress
Date: Wed, 19 Oct 2011 14:29:43 +0400
Message-ID: <1319020189-13584-3-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently the only way to log fsstress's output is to redirect it's shared
stdout to pipe which is very painfull because:

1) Pipe writers are serialized via i_mutex so we waste cpu-cores power on stupid
   sinchronization for loging purpose, instead of hunting real race conditions,
   and bugs inside file system.
2) Usually output is corrupted due to luck of sychronization on shared stdout.

Since fsstress's children operate on independend paths, let's just open didicated
log file for each child and simply avoid useless sycnhronization.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 34adacc..385d5a0 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -265,6 +265,8 @@ int main(int argc, char **argv)
 	char		buf[10];
 	int		c;
 	char		*dirname = NULL;
+	char		*logname = NULL;
+	char		rpath[PATH_MAX];
 	int		fd;
 	int		i;
 	int		j;
@@ -281,7 +283,7 @@ int main(int argc, char **argv)
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, "d:e:f:i:m:n:p:rs:vwzHS")) != -1) {
+	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:vwzHS")) != -1) {
 		switch (c) {
 		case 'd':
 			dirname = optarg;
@@ -319,6 +321,10 @@ int main(int argc, char **argv)
 		case 'n':
 			operations = atoi(optarg);
 			break;
+		case 'o':
+			logname = optarg;
+			break;
+
 		case 'p':
 			nproc = atoi(optarg);
 			break;
@@ -359,10 +365,26 @@ int main(int argc, char **argv)
         }
 
 	(void)mkdir(dirname, 0777);
+	if (logname && logname[0] != '/') {
+		if (getcwd(rpath, sizeof(rpath)) < 0){
+			perror("getcwd failed");
+			exit(1);
+		}
+	} else {
+		rpath[0] = '\0';
+	}
 	if (chdir(dirname) < 0) {
 		perror(dirname);
 		exit(1);
 	}
+	if (logname) {
+		char path[PATH_MAX];
+		snprintf(path, sizeof(path), "%s/%s", rpath, logname);
+		if (freopen(path, "a", stdout) == NULL) {
+			perror("freopen logfile failed");
+			exit(1);
+		}
+	}
 	sprintf(buf, "fss%x", (unsigned int)getpid());
 	fd = creat(buf, 0666);
 	if (lseek64(fd, (off64_t)(MAXFSIZE32 + 1ULL), SEEK_SET) < 0)
@@ -436,6 +458,14 @@ int main(int argc, char **argv)
 			if (getppid() == 1) /* parent died already? */
 				return 0;
 #endif
+			if (logname) {
+				char path[PATH_MAX];
+				snprintf(path, sizeof(path), "%s/%s.%d", rpath, logname, i);
+				if (freopen(path, "a", stdout) == NULL) {
+					perror("freopen logfile failed");
+					exit(1);
+				}
+			}
 			procid = i;
 			doproc();
 			return 0;
-- 
1.7.1

