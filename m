From: "Eunji Lee" <alicia0729@gmail.com>
Subject: A single flush to the storage device during commit works correctly?
Date: Fri, 25 Sep 2015 00:03:14 +0900
Message-ID: <001501d0f6da$24e7f870$6eb7e950$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33408 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbbIXPDZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Sep 2015 11:03:25 -0400
Received: by pacex6 with SMTP id ex6so75464908pac.0
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2015 08:03:25 -0700 (PDT)
Received: from PC (ejlee.chungbuk.ac.kr. [203.255.71.60])
        by smtp.gmail.com with ESMTPSA id by1sm14253559pab.6.2015.09.24.08.03.23
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 24 Sep 2015 08:03:24 -0700 (PDT)
Content-Language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, 

I am Eunji, and have a question on some parts of codes in EXT4/JBD2. (it
seems to work incorrectly, though I can be wrong). 

During the commit, JBD2 writes "data blocks" to the file system device and
writes "metadata blocks" and "commit record" to the journal device, when
running in an ordered mode. 

The current version of code (kernel 4.1) issues a "flush" once after issuing
a commit record if the file system device and the journal device are same in
asynchronous commit. It is to avoid redundant flushes. However, it seems to
incur an undesirable result upon a system crash, which is the metadata
blocks and commit record are written to the journal device successfully, but
the data blocks are not reflected to the file system location. 

For example, let us assume that the writes are issued in the following
order. 

data, metadata, commit-record, and then flush 

Then, the system crashes after writing metadata and commit-record to the
journal device, but before flushing data to the file system location (i.e.,
in the middle of flushing storage cache). Since the metadata block and the
commit-record are both written to the journal, there is no error in
checksum, and thus it would be replayed in the recovery. However, data
blocks, that should be written to the file system device before the
associated metadata blocks are committed to the journal, are not reflected
to the media. 

In not using asynchronous commit, it does not matter because the commit
record with WRITE_FUA guarantees to flush storage cache before the commit
record is written to the journal. 


In summary, I think code should be modified as follows.  

jbd2_journal_commit_transaction 
(current) 
	if (commit_transaction->t_need_data_flush &&
	    (journal->j_fs_dev != journal->j_dev) &&
	    (journal->j_flags & JBD2_BARRIER))
		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);

(after modification) 
	if (commit_transaction->t_need_data_flush &&
	    (journal->j_flags & JBD2_BARRIER))
		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);


Any comments will be very appreciated. 

Thanks,

Eunji

