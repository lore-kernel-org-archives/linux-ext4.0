From: "=?ISO-8859-2?Q?Marcin_Pr=B1czko?=" <marcin.praczko@googlemail.com>
Subject: Ext3 - advanced config...
Date: Tue, 19 Sep 2006 09:22:19 +0100
Message-ID: <6c99578d0609190122o23cc0f69t71655f0a3e1b1165@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:7143 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1751379AbWISIWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Sep 2006 04:22:20 -0400
Received: by wx-out-0506.google.com with SMTP id s14so4363040wxc
        for <linux-ext4@vger.kernel.org>; Tue, 19 Sep 2006 01:22:20 -0700 (PDT)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dear developers of ext[23] filesystems.

I have one problem and I would like to know how execly is working ext3
filesystem.

I red a lot of ext3 document, man pages and paper from internet.
I tried make experiment but it didn't work so I am writting to you.

This is the situation what I would like to do:
[I made my experiment on ram disk - so I show you my solutions]

HD [RAM0]-> Ext3 formatted
mkfs.ext3 -vm0 -j SIZE /dev/ram0
mount options:
mount -orw,commit=TIME,data=journal /dev/ram0 /mnt/ram_ext3_test

And now:
SIZE == 1 (The size of journal-size should be 1MB ??? Is it correct
(debian man tune2fs, mkfs.ext3)
TIME == 120 (is sec - so it means that data from journal system will
be send do HDD(RAM) after 2 min)

TIME is working property
SIZE - I have problem - I am writting data to file system - but I
wrote less that 1MB and ext3 save it from journal to harddrive.

And my real question is:
How execly works ext3 ??
I think like that:
SAVE DATA TO FS --->> [EXT3] Stored data in journal system (but on HD) ---->>>
   [EXT3] after TIME or SIZE move data from journal into real place on HD
Is it correct ??

But is it possible something like that??
SAVA DATA TO FS --->> [EXT3] Stored data in ramdisk (journal file)  ->>>
  [EXT3] after TIME or SIZE move data from journal (RAM) into real
place on hd ??

I red this information in man mkfs.ext3 (-J option: device), but with
my knowlage and english (is not perfect :)... I don't execly
understand how it is works.

Thank you for your time and your answer.
Marcin Praczko
