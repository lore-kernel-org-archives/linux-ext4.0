From: Rob Harris <rob.harris@gmail.com>
Subject: Refreshing after OOB file update?
Date: Thu, 28 Aug 2014 10:37:04 -0400
Message-ID: <53FF3E90.1060200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60779 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaH1OhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2014 10:37:05 -0400
Received: by mail-qa0-f44.google.com with SMTP id j7so780381qaq.17
        for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2014 07:37:05 -0700 (PDT)
Received: from [10.14.1.70] ([199.119.119.178])
        by mx.google.com with ESMTPSA id f105sm5813657qge.10.2014.08.28.07.37.04
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Aug 2014 07:37:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings. My apologies in advance... I need to ask a weird question and 
can't think of a more appropriate place to ask.

And yes, I know this is a broken/stupid/insane/WTF?/n00b request, but 
bear with me for a second.

I'm writing a FUSE layer for a project that sits on top of a ext4 
filesystem. My daemon will be the ONLY reader and writer; Except! ... 
I've been told that upon request, another (hardware--pcie) component of 
my system needs to be able to write data into a existing file in the 
filesystem DIRECTLY (i.e. using the absolute block ID returned from 
fiemap() ) without my FUSE layer or the ext4 file system knowing that 
the writing is occuring (I get a notification later via another means). 
So, basically, files are changing out from under me. (Assume that they 
know how big the extents are so they won't do anything stupid like 
overrun them or anything.)

Thinking this was insane, I ran a simple test:

- I created a file of all 0's using dd.
- I ran mkfs.ext4 on the file and loop mounted the file system.
- I created a dummy text file comprised of all 'y's (output of the yes 
command).
- I wrote a program to call fiemap() and get the physical location of 
the text file contents in the loop mounted fs file.
- I used dd to write a string into the file (i.e. echo "xxxx" | dd 
of=/tmp/dummy.fs bs=1 seek=138416128 conv=notrunc)
- If I dd if=/tmp/dummy.fs | hexdump -C, then I can see the changes written.
- If I cat the text file, I DON'T see the changes.
- If I touch the text file and cat it, still no joy.
- If I copy the text file to another file, I DON'T see the changes in 
either file.
- If I umount and remount the partition and then cat the file, I CAN see 
the changes.

This tells me (probably naively) that the kernel is caching the old file 
contents.

Is there a way for me to tell the file system that something out-of-band 
change a file contents and to force a re-read from the disk?

Also, this was performed using a loop mount--is the expectation that a 
similar test with live hardware/block device file systems would behave 
similarly?

Thanks again for placating my insanity.
-Rob Harris


