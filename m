From: Howard Cochran <hcochran@lexmark.com>
Subject: Kernel thread to zero itables for lazy_itable_init?
Date: Wed, 10 Jun 2009 18:41:22 -0400
Message-ID: <4A303692.3010104@lpdev.prtdev.lexmark.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod8og101.obsmtp.com ([64.18.3.82]:32779 "HELO
	exprod8og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753248AbZFJWqf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 18:46:35 -0400
Received: from lxkssmtp2e.lex.lexmark.com (smtp5b.notes.lexmark.com [157.184.50.112])
	by smtp04a.notes.lexmark.com (Postfix) with ESMTP id 416A91300EC
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 18:41:32 -0400 (EDT)
Received: from [157.184.141.112] (invent.lpdev.prtdev.lexmark.com [157.184.141.112])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by thoth.lpdev.prtdev.lexmark.com (Postfix) with ESMTPSA id 6569B4B781A
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 18:41:21 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings.

What is the status of the code to start a background kernel thread to 
zero the inode tables when filesystem that was created with mke2fs -E 
lazy_itable_init is mounted?  All I have found is a patch set posted to 
this mailing list back on November 21, 2008 and some discussion of the 
implementation, but nothing after that.

Is this effort still alive?

On a related note, from what I have read here, and from looking at the 
ext4 kernel code, the filesystem itself never really requires the inode 
tables to be zeroed out.  The only reason one might want to do that is 
so that fsck does not detect false errors. 

But, in data=ordered mode, would not marking the inode as allocated in 
the bitmap be done in the same journal transaction as populating the 
inode on disk (as well as creating a directory entry pointing to it)?  
And, unless the journal is broken, then either all that succeeds or none 
of it does.  So outside of a hardware failure, or data being overwritten 
directly on the block device, it's not possible for an "actually in-use" 
inode to be marked unallocated in the inode bitmap.

So, I am wondering whether we really need the complexity of a kernel 
thread to zero out the itable (or the long delay of doing it during 
mke2fs).  Instead, would it not be better to modify fsck to ignore 
garbage in unallocated inodes, at least for filesystems that have a journal.

Thanks,
Howard Cochran

