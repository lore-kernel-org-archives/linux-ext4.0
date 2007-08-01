From: Bernd Schubert <bschubert@q-leap.de>
Subject: [PATCH] e2fsck/e2fsprogs: answer yes/no to a group of questions
Date: Wed, 01 Aug 2007 14:57:20 +0200
Message-ID: <f8pvvg$3uo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1267773.4c0XVc5Y3c"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:36270 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760630AbXHANAP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2007 09:00:15 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IGDo2-0008C6-DJ
	for linux-ext4@vger.kernel.org; Wed, 01 Aug 2007 15:00:02 +0200
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2007 15:00:02 +0200
Received: from bschubert by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2007 15:00:02 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--nextPart1267773.4c0XVc5Y3c
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit

Hi,

saying yes or no to all e2fsck questions can be rather annoying (yes I
know -p and -y), so here's a patch to answer yes or no to a group of
questions.

Cheers,
Bernd

--nextPart1267773.4c0XVc5Y3c
Content-Type: text/x-diff; name="yes_no_to_all.patch"
Content-Transfer-Encoding: 8Bit
Content-Disposition: attachment; filename="yes_no_to_all.patch"

diff -r 9a2f051a0a1d e2fsck/e2fsck.h
--- a/e2fsck/e2fsck.h	Fri Jun 29 23:09:16 2007 -0400
+++ b/e2fsck/e2fsck.h	Fri Jul 27 16:08:50 2007 +0200
@@ -349,6 +349,14 @@ extern int e2fsck_strnlen(const char * s
 extern int e2fsck_strnlen(const char * s, int count);
 #endif
 
+typedef enum answer {
+	NO         = 0,
+	YES        = 1,
+	YES_TO_ALL = 2,
+	NO_TO_ALL  = 3
+} answer_t;
+
+
 /*
  * Procedure declarations
  */
diff -r 9a2f051a0a1d e2fsck/problem.c
--- a/e2fsck/problem.c	Fri Jun 29 23:09:16 2007 -0400
+++ b/e2fsck/problem.c	Fri Jul 27 16:08:50 2007 +0200
@@ -1608,7 +1608,8 @@ int fix_problem(e2fsck_t ctx, problem_t 
 	struct e2fsck_problem *ptr;
 	struct latch_descr *ldesc = 0;
 	const char *message;
-	int 		def_yn, answer, ans;
+	int 		def_yn, ans;
+	answer_t	answer;
 	int		print_answer = 0;
 	int		suppress = 0;
 
@@ -1617,6 +1618,15 @@ int fix_problem(e2fsck_t ctx, problem_t 
 		printf(_("Unhandled error code (0x%x)!\n"), code);
 		return 0;
 	}
+
+	if (ptr->flags & PR_YES_TO_ALL) {
+		printf("%s: yes\n", _(prompt[(int) ptr->prompt]));
+		return YES;
+	} else if (ptr->flags & PR_NO_TO_ALL) {
+		printf("%s: no\n", _(prompt[(int) ptr->prompt]));
+		return NO;
+	}
+
 	if (!(ptr->flags & PR_CONFIG)) {
 		char	key[9], *new_desc;
 
@@ -1638,11 +1648,11 @@ int fix_problem(e2fsck_t ctx, problem_t 
 
 		ptr->flags |= PR_CONFIG;
 	}
-	def_yn = 1;
+	def_yn = YES;
 	if ((ptr->flags & PR_NO_DEFAULT) ||
 	    ((ptr->flags & PR_PREEN_NO) && (ctx->options & E2F_OPT_PREEN)) ||
 	    (ctx->options & E2F_OPT_NO))
-		def_yn= 0;
+		def_yn= NO;
 
 	/*
 	 * Do special latch processing.  This is where we ask the
@@ -1652,9 +1662,9 @@ int fix_problem(e2fsck_t ctx, problem_t 
 		ldesc = find_latch(ptr->flags & PR_LATCH_MASK);
 		if (ldesc->question && !(ldesc->flags & PRL_LATCHED)) {
 			ans = fix_problem(ctx, ldesc->question, pctx);
-			if (ans == 1)
+			if (ans == YES)
 				ldesc->flags |= PRL_YES;
-			if (ans == 0)
+			if (ans == NO)
 				ldesc->flags |= PRL_NO;
 			ldesc->flags |= PRL_LATCHED;
 		}
@@ -1698,9 +1708,9 @@ int fix_problem(e2fsck_t ctx, problem_t 
 			if (!suppress)
 				print_answer = 1;
 			if (ldesc->flags & PRL_YES)
-				answer = 1;
+				answer = YES;
 			else
-				answer = 0;
+				answer = NO;
 		} else
 			answer = ask(ctx, _(prompt[(int) ptr->prompt]), def_yn);
 		if (!answer && !(ptr->flags & PR_NO_OK))
@@ -1709,7 +1719,14 @@ int fix_problem(e2fsck_t ctx, problem_t 
 		if (print_answer)
 			printf("%s.\n", answer ?
 			       _(preen_msg[(int) ptr->prompt]) : _("IGNORED"));
-	
+
+		if (answer == YES_TO_ALL) {
+			ptr->flags |= PR_YES_TO_ALL;
+			answer = YES;
+		} else if (answer == NO_TO_ALL) {
+			ptr->flags |= PR_NO_TO_ALL;
+			answer = YES;
+		}
 	}
 
 	if ((ptr->prompt == PROMPT_ABORT) && answer)
diff -r 9a2f051a0a1d e2fsck/problemP.h
--- a/e2fsck/problemP.h	Fri Jun 29 23:09:16 2007 -0400
+++ b/e2fsck/problemP.h	Fri Jul 27 16:08:50 2007 +0200
@@ -41,3 +41,5 @@ struct latch_descr {
 #define PR_PREEN_NOHDR	0x040000 /* Don't print the preen header */
 #define PR_CONFIG	0x080000 /* This problem has been customized 
 				    from the config file */
+#define PR_NO_TO_ALL    0x100000 /* Yes to all questions of this type */
+#define PR_YES_TO_ALL   0x200000 /* Yes to all questions of this type */
diff -r 9a2f051a0a1d e2fsck/util.c
--- a/e2fsck/util.c	Fri Jun 29 23:09:16 2007 -0400
+++ b/e2fsck/util.c	Fri Jul 27 16:08:50 2007 +0200
@@ -129,7 +129,10 @@ int ask_yn(const char * string, int def)
 	int		c;
 	const char	*defstr;
 	const char	*short_yes = _("yY");
-	const char	*short_no = _("nN");
+	const char	*short_no  = _("nN");
+	const char	*yes_all   = _("aA");
+	const char      *no_all    = _("oO");
+	const char	*help      = _("y = yes, n = no, a = yes to all, o = no to all");
 
 #ifdef HAVE_TERMIOS_H
 	struct termios	termios, tmp;
@@ -143,12 +146,12 @@ int ask_yn(const char * string, int def)
 #endif
 
 	if (def == 1)
-		defstr = _(_("<y>"));
+		defstr = _(_("Ynao"));
 	else if (def == 0)
-		defstr = _(_("<n>"));
+		defstr = _(_("yNao"));
 	else
-		defstr = _(" (y/n)");
-	printf("%s%s? ", string, defstr);
+		defstr = _("ynao");
+	printf("%s (%s?)? ", string, defstr);
 	while (1) {
 		fflush (stdout);
 		if ((c = read_a_char()) == EOF)
@@ -163,23 +166,42 @@ int ask_yn(const char * string, int def)
 				longjmp(e2fsck_global_ctx->abort_loc, 1);
 			}
 			puts(_("cancelled!\n"));
-			return 0;
+			return NO;
 		}
 		if (strchr(short_yes, (char) c)) {
-			def = 1;
+			def = YES;
 			break;
 		}
 		else if (strchr(short_no, (char) c)) {
-			def = 0;
-			break;
-		}
-		else if ((c == ' ' || c == '\n') && (def != -1))
-			break;
-	}
-	if (def)
+			def = NO;
+			break;
+		} else if (strchr(yes_all, (char) c)){
+			def = YES_TO_ALL;
+			break;
+		} else if (strchr(no_all, (char) c)){
+			def = NO_TO_ALL;
+			break;
+		} else if (c == '?') {
+			printf("\n%s\n", help);
+		} else if ((c == ' ' || c == '\n') && (def != -1))
+			break;
+	}
+
+	switch (def) {
+	case YES:
 		puts(_("yes\n"));
-	else
+		break;
+	case YES_TO_ALL:
+		puts(_("Yes to all\n"));
+		break;
+	case NO_TO_ALL:
+		puts(_("Yes to all\n"));
+		break;
+	case NO:
+	default:
 		puts (_("no\n"));
+	}
+
 #ifdef HAVE_TERMIOS_H
 	tcsetattr (0, TCSANOW, &termios);
 #endif


--nextPart1267773.4c0XVc5Y3c--
