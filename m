From: Eric Sandeen <sandeen@redhat.com>
Subject: build warning in e2fsprogs...
Date: Tue, 17 Jul 2007 13:47:46 -0500
Message-ID: <469D0ED2.2070101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXGQSwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2007 14:52:55 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6HIqsYq019590
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 14:52:54 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6HIqrOE019349
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 14:52:53 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l6HIqr7n012570
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 14:52:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

on x86_64:

badblocks.c:995: warning: comparison is always false due to limited range of data type
badblocks.c:1008: warning: comparison is always false due to limited range of data type

due to this sort of thing:

    if (*tmp || errno ||
        (last_block == ULONG_MAX && errno == ERANGE)) {
            com_err (program_name, 0, _("invalid blocks count - %s"),         
                     argv[optind]);
            exit (1);

last_block (and from_count) are both blk_t, or __u32... shouldn't 
this be UINT_MAX instead?  (though I guess at some point it *will* be 64
bits... but for now... how about the following patch...)

-Eric

-----

Fix build warning on x86_64 due to comparison of __u32 and ULONG_MAX

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/misc/badblocks.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/badblocks.c
+++ e2fsprogs-1.40.2/misc/badblocks.c
@@ -992,7 +992,7 @@ int main (int argc, char ** argv)
 		last_block = strtoul (argv[optind], &tmp, 0);
 		printf("last_block = %d (%s)\n", last_block, argv[optind]);
 		if (*tmp || errno || 
-		    (last_block == ULONG_MAX && errno == ERANGE)) {
+		    (last_block == UINT_MAX && errno == ERANGE)) {
 			com_err (program_name, 0, _("invalid blocks count - %s"),
 				 argv[optind]);
 			exit (1);
@@ -1005,7 +1005,7 @@ int main (int argc, char ** argv)
 		from_count = strtoul (argv[optind], &tmp, 0);
 		printf("from_count = %d\n", from_count);
 		if (*tmp || errno ||
-		    (from_count == ULONG_MAX && errno == ERANGE)) {
+		    (from_count == UINT_MAX && errno == ERANGE)) {
 			com_err (program_name, 0, _("invalid starting block - %s"),
 				 argv[optind]);
 			exit (1);
