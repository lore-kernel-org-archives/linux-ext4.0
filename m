From: Vasily Averin <vvs@sw.ru>
Subject: [Fwd: [Devel] [PATCH] ext3: wrong error behavior]
Date: Sat, 02 Sep 2006 16:02:19 +0400
Message-ID: <44F972CB.1090106@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060507010205090101030302"
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:37418 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1751092AbWIBMCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Sep 2006 08:02:22 -0400
Received: from [192.168.0.157] ([192.168.0.157])
	by relay.sw.ru (8.13.4/8.13.6) with ESMTP id k82C2JPe032370
	for <linux-ext4@vger.kernel.org>; Sat, 2 Sep 2006 16:02:20 +0400 (MSD)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------060507010205090101030302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------060507010205090101030302
Content-Type: message/rfc822;
 name="[Devel] [PATCH] ext3: wrong error behavior"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[Devel] [PATCH] ext3: wrong error behavior"

X-Account-Key: account2
Received: from swgw.sw.ru (swgw-dmz-if.sw.ru [195.214.233.2])
	by relay.sw.ru (8.13.4/8.13.6) with ESMTP id k82BiHKt002478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Sat, 2 Sep 2006 15:44:18 +0400 (MSD)
Received: from vzorg.swsoft.net (openvz.org [69.64.46.7])
	by swgw.sw.ru (8.13.6/8.13.6) with ESMTP id k82BhJAn028936;
	Sat, 2 Sep 2006 15:43:25 +0400 (MSD)
Received: from vzorg.swsoft.net (vzorg.swsoft.net [127.0.0.1])
	by vzorg.swsoft.net (8.13.1/8.13.1) with ESMTP id k82BfCR7014238;
	Sat, 2 Sep 2006 07:41:26 -0400
Received: from relay.sw.ru (mailhub.sw.ru [195.214.233.200])
	by vzorg.swsoft.net (8.13.1/8.13.1) with ESMTP id k82Bf9Bw014231
	for <devel@openvz.org>; Sat, 2 Sep 2006 07:41:10 -0400
Received: from [192.168.0.157] ([192.168.0.157])
	by relay.sw.ru (8.13.4/8.13.6) with ESMTP id k82Bf4X0032112;
	Sat, 2 Sep 2006 15:41:05 +0400 (MSD)
Message-ID: <44F96DD0.30608@sw.ru>
Date: Sat, 02 Sep 2006 15:41:04 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.5 (X11/20060725)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Stephen Tweedie <sct@redhat.com>,
        Andrew Morton <akpm@osdl.org>, adilger@clusterfs.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ext2-devel@lists.sourceforge.net, devel@openvz.org
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed; boundary="------------090209060903080509060206"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (vzorg.swsoft.net [127.0.0.1]); Sat, 02 Sep 2006 07:41:31 -0400 (EDT)
X-Greylist: Sender e-mail whitelisted, not delayed by milter-greylist-2.0.2
	(vzorg.swsoft.net [69.64.46.7]);
	Sat, 02 Sep 2006 07:41:10 -0400 (EDT)
Cc: 
Subject: [Devel] [PATCH] ext3: wrong error behavior
X-BeenThere: devel@openvz.org
X-Mailman-Version: 2.1.5
Precedence: list
Reply-To: devel@openvz.org
List-Id: devel.openvz.org
List-Unsubscribe: <https://openvz.org/mailman/listinfo/devel>,
	<mailto:devel-request@openvz.org?subject=unsubscribe>
List-Archive: <http://openvz.org/pipermail/devel>
List-Post: <mailto:devel@openvz.org>
List-Help: <mailto:devel-request@openvz.org?subject=help>
List-Subscribe: <https://openvz.org/mailman/listinfo/devel>,
	<mailto:devel-request@openvz.org?subject=subscribe>
Sender: devel-bounces@openvz.org
Errors-To: devel-bounces@openvz.org

This is a multi-part message in MIME format.
--------------090209060903080509060206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

SWsoft Virtuozzo/OpenVZ Linux kernel team has discovered that ext3 error
behavior was broken in linux kernels since 2.5.x versions by the following patch:

2002/10/31 02:15:26-05:00 tytso@snap.thunk.org
Default mount options from superblock for ext2/3 filesystems
http://linux.bkbits.net:8080/linux-2.6/gnupatch@3dc0d88eKbV9ivV4ptRNM8fBuA3JBQ

In case ext3 file system is mounted with errors=continue (EXT3_ERRORS_CONTINUE)
errors should be ignored when possible. However at present in case of any error
kernel aborts journal and remounts filesystem to read-only. Such behavior was
hit number of times and noted to differ from that of 2.4.x kernels.

This patch fixes this:
- do nothing in case of EXT3_ERRORS_CONTINUE,
- set EXT3_MOUNT_ABORT and call journal_abort() in all other cases
- panic() should be called after ext3_commit_super() to save
 sb marked as EXT3_ERROR_FS

Signed-off-by: Vasily Averin <vvs@sw.ru>
Ack-by:	Kirill Korotaev <dev@sw.ru>

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team

--------------090209060903080509060206
Content-Type: text/plain;
 name="diff-ext3-errorbehaviour-20060902"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-ext3-errorbehaviour-20060902"

--- linux-2.6.18-rc5/fs/ext3/super.c.orig	2006-09-02 12:54:01.000000000 +0400
+++ linux-2.6.18-rc5/fs/ext3/super.c	2006-09-02 13:10:02.000000000 +0400
@@ -159,20 +159,21 @@ static void ext3_handle_error(struct sup
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	if (test_opt (sb, ERRORS_RO)) {
-		printk (KERN_CRIT "Remounting filesystem read-only\n");
-		sb->s_flags |= MS_RDONLY;
-	} else {
+	if (!test_opt (sb, ERRORS_CONT)) {
 		journal_t *journal = EXT3_SB(sb)->s_journal;
 
 		EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
 		if (journal)
 			journal_abort(journal, -EIO);
 	}
+	if (test_opt (sb, ERRORS_RO)) {
+		printk (KERN_CRIT "Remounting filesystem read-only\n");
+		sb->s_flags |= MS_RDONLY;
+	}
+	ext3_commit_super(sb, es, 1);
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT3-fs (device %s): panic forced after error\n",
 			sb->s_id);
-	ext3_commit_super(sb, es, 1);
 }
 
 void ext3_error (struct super_block * sb, const char * function,

--------------090209060903080509060206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Devel mailing list
Devel@openvz.org
https://openvz.org/mailman/listinfo/devel

--------------090209060903080509060206--



--------------060507010205090101030302--

-- 
VGER BF report: U 0.499829
