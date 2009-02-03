From: Dan Carpenter <error27@gmail.com>
Subject: typo in jbd2_journal_begin_ordered_truncate()
Date: Tue, 3 Feb 2009 11:23:03 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0902012309120.26166@bikeee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54476 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZBCIXY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 03:23:24 -0500
Received: by ewy14 with SMTP id 14so2278983ewy.13
        for <linux-ext4@vger.kernel.org>; Tue, 03 Feb 2009 00:23:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is jbd2_journal_begin_ordered_truncate() from fs/jbd2/transaction.c.

I think the "&&" is supposed to be an "||" on line 2144.  Just knowing 
that inode->i_transaction is NULL should be enough, otherwise we would 
immediately dereference a null on line 2146.

   2144          if (!inode->i_transaction && !inode->i_next_transaction)
   2145                  goto out;
   2146          journal = inode->i_transaction->t_journal;

regards,
dan carpenter


