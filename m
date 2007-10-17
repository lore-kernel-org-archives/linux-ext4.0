From: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: ext3 warnings from LTP rename14
Date: Wed, 17 Oct 2007 01:20:09 +0100
Message-ID: <20071017002009.GA2966@palantir8>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from earth.karoo.kcom.com ([212.50.160.55]:12980 "EHLO
	earth.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760959AbXJQA03 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2007 20:26:29 -0400
Received: from mhabets by palantir8.mph.eclipse.net with local (Exim 3.36 #1 (Debian))
	id 1Ihwdt-0000mL-00
	for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2007 01:20:09 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I ran the ltp-full-20070930 tests on 2.6.23-rc9-mph4 (sparc32 SMP), and am
seeing the following warnings:

EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
cEXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
oEXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
mEXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs warning (device sdb5): ext3_rename: Deleting old file (215845), 2, error=-2
EXT3-fs error (device sdb5): ext3_add_entry: bad entry in directory #215845: rec_len is smaller than minimal - offset=56, inode=8026488, rec_len=0, name_len=0
Aborting journal on device sdb5.
EXT3-fs error (device sdb5) in start_transaction: Readonly filesystem
Aborting journal on device sdb5.
ext3_abort called.

The first ones are triggered the rename14 test (code attached), but I cannot
reproduce the latter issue so far.
Could it be a result of the earlier warnings?

An attempt to avoid the warning is also attached. But with that I see:
EXT3-fs warning (device sdb4): ext3_unlink: Deleting nonexistent file (305412), 0

Best regards,
Martin
---------------------------------------------------------------------------
30 years from now GNU/Linux will be as redundant a term as MERT/UNIX is 
today. - Martin Habets
---------------------------------------------------------------------------

--dDRMvlgZJXvWKvBx
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="rename14.c"

/*
 *
 *   Copyright (c) International Business Machines  Corp., 2002
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

/* 11/12/2002   Port to LTP     robbiew@us.ibm.com */
/* 06/30/2001	Port to Linux	nsharoff@us.ibm.com */

/*
 * NAME
 *	rename14.c - create and rename files
 *
 * CALLS
 *	create, unlink, rename
 *
 * ALGORITHM
 *	Creates two processes.  One creates and unlinks a file.
 *	The other renames that file.
 *
 */

#include <stdio.h>	
#include <errno.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/** LTP Port **/
#include "test.h"
#include "usctest.h"

#define FAILED 0
#define PASSED 1

int local_flag = PASSED;

char *TCID="rename14";            /* Test program identifier.    */
int TST_TOTAL=1;                /* Total number of test cases. */
extern int Tst_count;           /* Test Case counter for tst_* routines */
/**************/


#define RUNTIME	45

int kidpid[2];
int parent_pid;


int main (argc, argv)
	int  argc;
	char *argv[];
{
	int pid;
	sigset_t set;
	struct sigaction act, oact;
	int	term();
	int	al();
	void dochild1();
	void dochild2();

#ifdef UCLINUX
	char *msg;		/* message returned from parse_opts */

	/* Parse standard options given to run the test. */
	msg = parse_opts(argc, argv, (option_t *)NULL, NULL);
	if (msg != (char *)NULL) {
		tst_brkm(TBROK, NULL, "OPTION PARSING ERROR - %s", msg);
	}

	maybe_run_child(&dochild1, "n", 1);
	maybe_run_child(&dochild2, "n", 2);
#endif
	sigemptyset(&set);
	act.sa_handler = (void(*)())term;
	act.sa_mask = set;
	act.sa_flags = 0;
	if (sigaction(SIGTERM, &act, &oact)) {
		tst_resm(TBROK,"Sigaction(SIGTERM)");
		tst_exit();
	}

	sigemptyset(&set);
	act.sa_handler = (void(*)())al;
	act.sa_mask = set;
	act.sa_flags = 0;
	if (sigaction(SIGALRM, &act, 0)) {
		tst_resm(TBROK,"Sigaction(SIGALRM)");
		tst_exit();
	} 
	parent_pid = getpid();
	tst_tmpdir();
/*--------------------------------------------------------------*/

	pid = FORK_OR_VFORK();
	if (pid < 0) {
		tst_resm(TBROK,"fork() returned %d", pid);
		tst_exit();	
	}
	if (pid == 0) {
#ifdef UCLINUX
		if (self_exec(argv[0], "n", 1) < 0) {
			tst_resm(TBROK,"self_exec failed");
		}
#else
		dochild1();
#endif
	}
	kidpid[0] = pid;
	pid = FORK_OR_VFORK();
	if (pid < 0) {
		(void)kill(kidpid[0], SIGTERM);
		(void)unlink("./rename14");
		tst_resm(TBROK,"fork() returned %d", pid);
		tst_exit();	
	}
	if (pid == 0) {
#ifdef UCLINUX
		if (self_exec(argv[0], "n", 1) < 0) {
			tst_resm(TBROK,"self_exec failed");
		}
#else
		dochild2();
#endif
	}
	kidpid[1] = pid;

	alarm(RUNTIME);

	/* Collect child processes. */
	/* Wait for timeout */
	pause();
 
	kill(kidpid[0], SIGTERM);
	kill(kidpid[1], SIGTERM);

	unlink("./rename14");
	unlink("./rename14xyz");
	(local_flag == PASSED) ?
	    tst_resm(TPASS, "Test Passed")
	:   tst_resm(TFAIL, "Test Failed");

	tst_rmdir();
/*--------------------------------------------------------------*/
	tst_exit();	/* THIS CALL DOES NOT RETURN - EXITS!!	*/
/*--------------------------------------------------------------*/
	return(0);
}
/* FUNCTIONS GO HERE */

int term()
{
	if (parent_pid != getpid())
		exit(0);
	if (kidpid[0])
		return(kill(kidpid[0], SIGTERM));
	if (kidpid[1])
		return(kill(kidpid[1], SIGTERM));
        return(0);
}

int al()
{
	if (kidpid[0])
		return(kill(kidpid[0], SIGTERM));
	if (kidpid[1])
		return(kill(kidpid[1], SIGTERM));
        return(0);
}

void dochild1()
{
	int fd;

	for (;;) {
		fd = creat("./rename14", 0666);
		unlink("./rename14");
		close(fd);
	}
}

void dochild2()
{
	for (;;) {
		rename("./rename14", "./rename14xyz");
	}
}

--dDRMvlgZJXvWKvBx
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="namei.c.patch"

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index c1fa190..4b7b8a8 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2373,24 +2373,25 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (le32_to_cpu(old_de->inode) != old_inode->i_ino ||
 	    old_de->name_len != old_dentry->d_name.len ||
 	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext3_delete_entry(handle, old_dir,
 					old_de, old_bh)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
 		 * make sure that we are deleting the right entry.  We might
 		 * also be pointing to a stale entry in the unused part of
 		 * old_bh so just checking inum and the name isn't enough. */
 		struct buffer_head *old_bh2;
 		struct ext3_dir_entry_2 *old_de2;
 
+		retval = 0;
 		old_bh2 = ext3_find_entry(old_dentry, &old_de2);
 		if (old_bh2) {
 			retval = ext3_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
 			brelse(old_bh2);
 		}
 	}
 	if (retval) {
 		ext3_warning(old_dir->i_sb, "ext3_rename",
 				"Deleting old file (%lu), %d, error=%d",
 				old_dir->i_ino, old_dir->i_nlink, retval);
 	}

--dDRMvlgZJXvWKvBx--
