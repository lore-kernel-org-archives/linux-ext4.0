From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: check for bogus new_size in resize2fs
Date: Fri, 10 Oct 2008 17:38:15 -0500
Message-ID: <48EFD957.3000406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYJJWiR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 18:38:17 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMcGlT006931
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:38:16 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9AMcGWK026733
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:38:16 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMcFN6023844
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:38:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resolves RH Bug 465984 - resize2fs doesn't recognize bogus argument, ending in infinite loop

If we don't check for new_size == 0, bogus values send resize2fs into
a tailspin:

resize2fs 1.41.0 (10-Jul-2008)
Illegal block number passed to ext2fs_test_block_bitmap #1 for block bitmap for
/tmp/tmp.lntZtMFvz8/fake-disk
...the same message repeated zillion times...

Probably should see where that loop is, but at any rate we should
error-check parse_num_blocks.

Thanks to Petr Muller for reporting this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

Index: e2fsprogs/resize/main.c
===================================================================
--- e2fsprogs.orig/resize/main.c
+++ e2fsprogs/resize/main.c
@@ -376,6 +376,11 @@ int main (int argc, char ** argv)
 	else if (new_size_str) {
 		new_size = parse_num_blocks(new_size_str,
 					    fs->super->s_log_block_size);
+		if (new_size == 0) {
+			com_err(program_name, 0,
+				_("Invalid new size: %s\n"), new_size_str);
+			exit(1);
+		}
 	} else {
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */

