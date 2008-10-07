From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] logsave : Avoid unnecessary backgrounding of logsave in case of failures
Date: Tue, 7 Oct 2008 23:14:11 +0530
Message-ID: <ea11fea30810071044l6d8887e0udb52342f82412e4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:29704 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYJGRoN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 13:44:13 -0400
Received: by ti-out-0910.google.com with SMTP id b6so2012393tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2008 10:44:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I am not sure why we wan't to background the logsave and keep retrying
opening the fd in case of failures. But there may be situations when
we
will never be able to succeed and thus create unnecessary process. For
example invoking it

/home/mkatiyar/sbin> ./logsave /testfile ls

as a normal user will never succeed. Below patch adds some of the
error conditions where we can just avoid it.

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

---
 misc/logsave.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/misc/logsave.c b/misc/logsave.c
index f0011f8..77a0a16 100644
--- a/misc/logsave.c
+++ b/misc/logsave.c
@@ -203,6 +203,17 @@ static int copy_from_stdin(void)
 	return 0;
 }

+static void should_background(int err, int *nobackground) {
+	switch (err) {
+		case EPERM:
+		case EACCES:
+			*nobackground = err;
+			break;
+		default :
+			*nobackground = 0;
+	}
+	return ;
+}


 int main(int argc, char **argv)
@@ -211,7 +222,7 @@ int main(int argc, char **argv)
 	char	*outfn, **cpp;
 	int	openflags = O_CREAT|O_WRONLY|O_TRUNC;
 	int	send_flag = SEND_LOG;
-	int	do_stdin;
+	int	do_stdin, nobackground = 0;
 	time_t	t;

 	while ((c = getopt(argc, argv, "+asv")) != EOF) {
@@ -237,6 +248,8 @@ int main(int argc, char **argv)
 	argc -= optind;

 	outfd = open(outfn, openflags, 0644);
+	if (outfd < 0)
+		should_background(errno, &nobackground);
 	do_stdin = !strcmp(argv[0], "-");

 	send_output("Log of ", 0, send_flag);
@@ -263,7 +276,7 @@ int main(int argc, char **argv)
 	send_output(ctime(&t), 0, send_flag);
 	send_output("----------------\n", 0, send_flag);

-	if (outbuf) {
+	if (!nobackground) {
 		pid = fork();
 		if (pid < 0) {
 			perror("fork");
@@ -282,6 +295,8 @@ int main(int argc, char **argv)
 		}
 		write(outfd, outbuf, outbufsize);
 		free(outbuf);
+	} else {
+		printf("Unable to save log to %s : %s\n", outfn, strerror(nobackground));
 	}
 	close(outfd);

-- 
1.5.4.3


Thanks -
Manish
