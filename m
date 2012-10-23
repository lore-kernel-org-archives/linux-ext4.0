From: peter@notatla.org.uk
Subject: patch for lsattr: adds -b option similar to ls -b
Date: Tue, 23 Oct 2012 23:47:04 +0100
Message-ID: <20121023224704.8F8BB80046@notatla.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl-217-155-246-43.zen.co.uk ([217.155.246.43]:64498 "EHLO
	notatla.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933464Ab2JWW5Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 18:57:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


commit bedcccca5ce90c5de2beb493e12e413b72500cea
Author: Peter Allan <peter@notatla.org.uk>
Date:   Fri Jun 15 07:54:50 2012 +0100

    Add to lsattr a "-b" switch (similar to ls -b)
    to show nonprinting characters in filenames.
    Signed-off-by: Peter Allan <peter@notatla.org.uk>



*** e2fsprogs/misc/lsattr.c	2012-06-15 08:51:29.050093165 +0100
--- e2fsprogs/misc/lsattr.c.new	2012-06-15 08:52:10.527524115 +0100
***************
*** 15,20 ****
--- 15,21 ----
   * 93/11/13	- Replace stat() calls by lstat() to avoid loops
   * 94/02/27	- Integrated in Ted's distribution
   * 98/12/29	- Display version info only when -V specified (G M Sipe)
+  * 12/06/15	- Added -b similar to that of ls. (Peter Allan)
   */
  
  #define _LARGEFILE64_SOURCE
***************
*** 56,61 ****
--- 57,63 ----
  
  static int all;
  static int dirs_opt;
+ static int nonprint;
  static unsigned pf_options;
  static int recursive;
  static int verbose;
***************
*** 100,106 ****
  		fputc('\n', stdout);
  	} else {
  		print_flags(stdout, flags, pf_options);
! 		printf(" %s\n", name);
  	}
  	return 0;
  }
--- 102,139 ----
  		fputc('\n', stdout);
  	} else {
  		print_flags(stdout, flags, pf_options);
! 		if (nonprint) {
!                     char *cp=name;
! 		    fputc(' ', stdout);
! 		    while (*cp) {
!                        switch (*cp) {
! 			   case '\\':
!                                printf("\\\\");
!                                break;
! 			   case '\n':
!                                printf("\\n");
!                                break;
! 			   case '\t':
!                                printf("\\t");
!                                break;
! 			   case ' ':
!                                printf("\\ ");
!                                break;
! 			   default:
! 			       if (isprint(*cp)) {
! 		                   fputc(*cp, stdout);
! 			       } else {
! 			           printf("\%3o",*cp);
! 			       }
!                                break;
! 		       }
! 		       fflush(stdout);
! 		       cp++;
! 		    }
! 		    fputc('\n', stdout);
!                 } else {
! 		    printf(" %s\n", name);
!                 }
  	}
  	return 0;
  }
***************
*** 171,177 ****
  #endif
  	if (argc && *argv)
  		program_name = *argv;
! 	while ((c = getopt (argc, argv, "RVadlv")) != EOF)
  		switch (c)
  		{
  			case 'R':
--- 204,210 ----
  #endif
  	if (argc && *argv)
  		program_name = *argv;
! 	while ((c = getopt (argc, argv, "RVabdlv")) != EOF)
  		switch (c)
  		{
  			case 'R':
***************
*** 183,188 ****
--- 216,224 ----
  			case 'a':
  				all = 1;
  				break;
+ 			case 'b':
+ 				nonprint = 1;
+ 				break;
  			case 'd':
  				dirs_opt = 1;
  				break;
*** e2fsprogs/misc/lsattr.1.in	2012-06-15 08:51:29.046093412 +0100
--- e2fsprogs/misc/lsattr.1.in.new	2012-06-15 08:51:54.192535862 +0100
***************
*** 5,11 ****
  .SH SYNOPSIS
  .B lsattr
  [
! .B \-RVadv
  ]
  [
  .I files...
--- 5,11 ----
  .SH SYNOPSIS
  .B lsattr
  [
! .B \-RVabdv
  ]
  [
  .I files...
***************
*** 26,31 ****
--- 26,34 ----
  .B \-a
  List all files in directories, including files that start with `.'.
  .TP
+ .B \-b
+ Show nonprinting characters in filenames (similar to ls -b).
+ .TP
  .B \-d
  List directories like other files, rather than listing their contents.
  .TP



Signed-off-by: Peter Allan <peter@notatla.org.uk>
