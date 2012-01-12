From: Hugh Dickins <hughd@google.com>
Subject: punch-hole should go beyond i_size
Date: Wed, 11 Jan 2012 17:02:12 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59638 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2ALBCd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 20:02:33 -0500
Received: by iabz25 with SMTP id z25so1876639iab.19
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jan 2012 17:02:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Allison,

In thinking about fallocate() on tmpfs, I cross-check with ext4
and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:

rm -f temp
fallocate    -l 4096 temp
du temp				# shows 4, right
fallocate -p -l 4096 temp
du temp				# shows 0, right
rm -f temp
fallocate -n -l 4096 temp
du temp				# shows 4, right
fallocate -p -l 4096 temp
du temp				# shows 4, wrong
rm temp

ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
early return, and trimming to i_size below, but forgets that the other
variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
blocks beyond i_size.  They can be removed with ftruncate(), but it is
unexpected for fallocate() not to undo its own work, and xfs does so.

Hugh
