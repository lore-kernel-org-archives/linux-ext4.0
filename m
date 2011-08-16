From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: a (documented) way to get the Ext2+ filesystem size?
Date: Tue, 16 Aug 2011 18:37:23 +0700
Message-ID: <86aab94mfg.fsf@gray.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59365 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1HPLhi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 07:37:38 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QtHxg-0001H3-U5
	for linux-ext4@vger.kernel.org; Tue, 16 Aug 2011 13:37:36 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 13:37:36 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 13:37:36 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	How do I get the Ext2+ filesystem size (in blocks)?

	Currently, I do it like:

static uint_fast64_t
e2fs_size (ext2_filsys e2)
{
  uint_fast32_t hi
    = (uint_fast32_t)e2->super->s_blocks_count_hi;
  uint_fast32_t lo
    = (uint_fast32_t)e2->super->s_blocks_count;

  /* . */
  return (((uint64_t)hi << 32) | lo);
}

	However, it seems that there's no documentation for both the
	ext2_filsys and struct ext2_super_block structure types, and
	their respective member fields.

	Am I safe with the code above?

-- 
FSF associate member #7257

