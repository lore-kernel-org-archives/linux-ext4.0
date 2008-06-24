From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Tue, 24 Jun 2008 12:57:18 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806241249540.15783@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu>
 <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu>
 <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de> <20080620085922.GH9119@mit.edu>
 <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de> <20080623174508.GA7216@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:58853 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYFXM50 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 08:57:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by node2.dwd.de (Postfix) with ESMTP id AA0434A4600
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 12:57:25 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node2.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 05828-74 for <linux-ext4@vger.kernel.org>;
	Tue, 24 Jun 2008 12:57:25 +0000 (UTC)
In-Reply-To: <20080623174508.GA7216@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 23 Jun 2008, Aneesh Kumar K.V wrote:

> On Fri, Jun 20, 2008 at 09:21:48AM +0000, Holger Kiehl wrote:
>> On Fri, 20 Jun 2008, Theodore Tso wrote:
>>
>>> On Fri, Jun 20, 2008 at 08:32:52AM +0000, Holger Kiehl wrote:
>>>>> It sounds like i_size is actually dropping in
>>>>> size at some pointer long after the file was written.  If I had to
>>>
>>> sorry, "at some point"...
>>>
>>>>> guess the value in the inode cache is correct; and perhaps so is the
>>>>> value on the journal.  But somehow, the wrong value is getting written
>>>>> to disk
>>>
>>> Or, "the right value is never getting written to disk".  (Which as I
>>> think about it is more likely; it's likely that an update to i_size is
>>> getting *lost*, perhaps because the delalloc code is possibly
>>> modifying i_size without starting a transaction first.  Again this is
>>> just a guess.)
>>>
>>>> What I find strange is that the missing parts of the file are not for
>>>> example exactly 512 or 1024 or 4096 bytes it is mostly some odd number
>>>> of bytes.
>>>
>>> Is there any chance the truncation point is related to how the program
>>> is writing its output file?  i.e., if it is a text file, is the
>>> truncation happening after a new-line or when the stdio library might
>>> have done an explicit or implicit fflush()?
>>>
>> When the benchmark runs it writes to stdout and with tee to the result
>> file. It first writes some information about the system, prepares the
>> test files (creates lots of small files), calls sync and then starts
>> the test. Then every minute one line gets written to the result file.
>> Often I have seen that everything after the sync was missing. But
>> sometimes it happened that some parts at the end are missing. But it
>> was always a clean cut, that is there where no lines that where cut
>> partially. The lines where always complete.
>>
>
> I found one place where we fail to update i_disksize. Can you try this
> patch ?
>
Yes, I would like to however when I take
ext4-patch-queue-70acdb9605784bd5c4b06e1a19761828a494a337.tar.gz (which is
the current ext4-patch-queue from http://repo.or.cz/w/ext4-patch-queue.git)
and apply those to linux-2.6.26-rc6 I get the following reject:


***************
*** 574,579 ****
   	INIT_LIST_HEAD(&ei->i_prealloc_list);
   	spin_lock_init(&ei->i_prealloc_lock);
   	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
   	return &ei->vfs_inode;
   }

--- 574,584 ----
   	INIT_LIST_HEAD(&ei->i_prealloc_list);
   	spin_lock_init(&ei->i_prealloc_lock);
   	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
+ 	ei->i_reserved_data_blocks = 0;
+ 	ei->i_reserved_meta_blocks = 0;
+ 	ei->i_allocated_meta_blocks = 0;
+ 	ei->i_delalloc_reserved_flag = 0;
+ 	spin_lock_init(&(ei->i_block_reservation_lock));
   	return &ei->vfs_inode;
   }

Which is from delalloc-ext4-ENOSPC-handling.patch. What am I doing wrong?
I could apply this by hand but I do not know if this would be correct.
Please can anyone advice what I need to do?

Thanks,
Holger

