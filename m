From: Zach Carter <linux@zachcarter.com>
Subject: [PATCH] trivial: update broken URLs in Documentation/filesystems
Date: Sun, 06 May 2007 12:16:30 -0700
Message-ID: <463E298E.5020109@zachcarter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, trivial@kernel.org,
	Marco.Baye@tu-clausthal.de
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755111AbXEFTQd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


update several broken URLs in Documentation/filesystems.

Signed-off-by: Zach Carter <linux@zachcarter.com>
---
Documentation/filesystems/befs.txt  |    4 ++--
Documentation/filesystems/ext2.txt  |    2 +-
Documentation/filesystems/ext3.txt  |    4 ++--
Documentation/filesystems/isofs.txt |    2 +-
4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/befs.txt b/Documentation/filesystems/befs.txt
index 67391a1..ea954f2 100644
--- a/Documentation/filesystems/befs.txt
+++ b/Documentation/filesystems/befs.txt
@@ -61,7 +61,7 @@ step 2.  Configuration & make kernel

The linux kernel has many compile-time options. Most of them are beyond the
scope of this document. I suggest the Kernel-HOWTO document as a good general
-reference on this topic. <http://www.linux.com/howto/Kernel-HOWTO.html>
+reference on this topic. <http://www.linuxdocs.org/HOWTOs/Kernel-HOWTO.html>

However, to use the BeFS module, you must enable it at configure time.

@@ -79,7 +79,7 @@ Save your kernel configuration and then build your kernel.

step 3.  Install

-See the kernel howto <http://www.linux.com/howto/Kernel-HOWTO.html> for
+See the kernel howto <http://www.linuxdocs.org/HOWTOs/Kernel-HOWTO.html> for
instructions on this critical step.

USING BFS
diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 4333e83..e1dbcaa 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -377,6 +377,6 @@ Windows 95/98/NT/2000	http://uranus.it.swin.edu.au/~jn/linux/Explore2fs.htm
Windows 95 (*)		http://www.yipton.demon.co.uk/content.html#FSDEXT2
DOS client (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
OS/2			http://perso.wanadoo.fr/matthieu.willm/ext2-os2/
-RISC OS client		ftp://ftp.barnet.ac.uk/pub/acorn/armlinux/iscafs/
+RISC OS client		http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/IscaFS/

(*) no longer actively developed/supported (as of Apr 2001)
diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 4aecc9b..37aaa22 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -194,5 +194,5 @@ programs: 	http://e2fsprogs.sourceforge.net/
		http://ext2resize.sourceforge.net

useful links:	http://www.zip.com.au/~akpm/linux/ext3/ext3-usage.html
-		http://www-106.ibm.com/developerworks/linux/library/l-fs7/
-		http://www-106.ibm.com/developerworks/linux/library/l-fs8/
+		http://www.ibm.com/developerworks/linux/library/l-fs7.html
+		http://www.ibm.com/developerworks/linux/library/l-fs8.html
diff --git a/Documentation/filesystems/isofs.txt b/Documentation/filesystems/isofs.txt
index 758e504..9c93324 100644
--- a/Documentation/filesystems/isofs.txt
+++ b/Documentation/filesystems/isofs.txt
@@ -36,7 +36,7 @@ Mount options unique to the isofs filesystem.

Recommended documents about ISO 9660 standard are located at:
http://www.y-adagio.com/public/standards/iso_cdromr/tocont.htm
-ftp://ftp.ecma.ch/ecma-st/Ecma-119.pdf
+http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-119.pdf
Quoting from the PDF "This 2nd Edition of Standard ECMA-119 is technically 
identical with ISO 9660.", so it is a valid and gratis substitute of the
official ISO specification.
-- 
1.5.0.6
