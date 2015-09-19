From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] subst: use 0644 perms
Date: Fri, 18 Sep 2015 21:43:07 -0400
Message-ID: <20150919014307.GA2921@thunk.org>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org>
 <E093072B-F995-496D-BE3D-B14EB5A1C27A@dilger.ca>
 <20150918180824.GE2213@vapier.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbbISBnL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 21:43:11 -0400
Content-Disposition: inline
In-Reply-To: <20150918180824.GE2213@vapier.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:08:24PM -0400, Mike Frysinger wrote:
> 
> i think you misread my report.  this has nothing to do with people trying
> to modify the files after the fact.  NFS can (and sometimes does) throw an
> error at the time of the *open* call even if the file doesn't exist.

I believe Andreas did understand your report; he was just objecting to
the claim in the git description that there is "no reason" to have the
files generated subst to be read-only.

> if you want to try to "protect" people, then it needs to be a chmod after
> all the data has been written & closed.  this is how it used to behave,
> but commit 2873927d15ffb9ee9ed0e2700791a0e519c715aa changed it.

I think Andreas was asking you to make this change to the patch.  I
had a bit of spare time (thanks to perfcrastination :-), so I took
care of it.

      	   	      		       	       - Ted

commit e5a82003d1b3b7ea01f60dadb49c3bbc60e4ebb7
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Sep 18 21:37:53 2015 -0400

    subst: work around an NFS bug
    
    When running on NFS, opening files with 0444 perms for writing can
    sometimes fail.  This is arguably an NFS server bug, but work around
    it by creating the file with 0644 permissions, and only change the
    permissions to be 0444 right before we close the file.
    
    URL: https://bugs.gentoo.org/550986
    Reported-by: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/util/subst.c b/util/subst.c
index f36adb4..70dc0bc 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -319,7 +319,7 @@ int main(int argc, char **argv)
 {
 	char	line[2048];
 	int	c;
-	int	fd;
+	int	fd, ofd = -1;
 	FILE	*in, *out, *old = NULL;
 	char	*outfn = NULL, *newfn = NULL;
 	int	verbose = 0;
@@ -370,12 +370,12 @@ int main(int argc, char **argv)
 		}
 		strcpy(newfn, outfn);
 		strcat(newfn, ".new");
-		fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0444);
-		if (fd < 0) {
+		ofd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0644);
+		if (ofd < 0) {
 			perror(newfn);
 			exit(1);
 		}
-		out = fdopen(fd, "w+");
+		out = fdopen(ofd, "w+");
 		if (!out) {
 			perror("fdopen");
 			exit(1);
@@ -429,12 +429,16 @@ int main(int argc, char **argv)
 					printf("Using original atime\n");
 				set_utimes(outfn, fileno(old), tv);
 			}
+			if (ofd >= 0)
+				(void) fchmod(ofd, 0444);
 			fclose(out);
 			if (unlink(newfn) < 0)
 				perror("unlink");
 		} else {
 			if (verbose)
 				printf("Creating or replacing %s.\n", outfn);
+			if (ofd >= 0)
+				(void) fchmod(ofd, 0444);
 			fclose(out);
 			if (old)
 				fclose(old);
