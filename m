From: Girish Shilamkar <girish@linsyssoft.com>
Subject: Re: [PATCH] Journal Checksum - rebased to 2.6.22-rc5
Date: Tue, 26 Jun 2007 16:17:30 +0530
Message-ID: <1182854850.3041.16.camel@dhcp7.linsyssoft.com>
References: <1182504986.3788.18.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from svr68.ehostpros.com ([67.15.48.48]:53260 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXFZKrT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 06:47:19 -0400
In-Reply-To: <1182504986.3788.18.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-22 at 15:06 +0530, Girish Shilamkar wrote:
> Hi,
> 	The previous patch was an old one. Hence I am sending the latest patch
> rebased to 2.6.22-rc5. I have also fixed few coding style issues in both
> the patches.
> 
> Regards,
> Girish
This patch had a bug. Thanks to Valerie for pointing it out.

Regards,
Girish.

Index: linux-2.6.22-rc5/fs/jbd2/commit.c
===================================================================
--- linux-2.6.22-rc5.orig/fs/jbd2/commit.c
+++ linux-2.6.22-rc5/fs/jbd2/commit.c
@@ -121,8 +121,8 @@ static int journal_submit_commit_record(
        bh = jh2bh(descriptor);

        for (i = 0; i < bh->b_size; i += 512) {
-               struct commit_header *tmp = (struct commit_header *)bh->b_data +
-                                           i;
+               struct commit_header *tmp = (struct commit_header *)(bh->b_data+
+                                           i);
                tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
                tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
                tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
