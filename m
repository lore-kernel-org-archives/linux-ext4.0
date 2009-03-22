From: Richard <richard@r-selected.de>
Subject: Re: Severe data corruption with ext4
Date: Sun, 22 Mar 2009 14:26:34 +0100
Message-ID: <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com>
References: <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
	 <20090320030121.1fa8e6d3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59488 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZCVN0h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Mar 2009 09:26:37 -0400
Received: by ewy9 with SMTP id 9so1275920ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 22 Mar 2009 06:26:34 -0700 (PDT)
In-Reply-To: <20090320030121.1fa8e6d3.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again,

now on the same system (hardware configuration unchanged, except that
I attached a DVD burner yesterday), I got dozens of errors like these:

----------
Mar 22 13:47:33 bakunin kernel: __find_get_block_slow() failed.
block=197478301302784, b_blocknr=0
Mar 22 13:47:33 bakunin kernel: b_state=0x00188021, b_size=4096
Mar 22 13:47:33 bakunin kernel: device blocksize: 4096
Mar 22 13:47:33 bakunin kernel: __find_get_block_slow() failed.
block=197478301302784, b_blocknr=0
Mar 22 13:47:33 bakunin kernel: b_state=0x00188021, b_size=4096
Mar 22 13:47:33 bakunin kernel: device blocksize: 4096
Mar 22 13:47:33 bakunin kernel: grow_buffers: requested out-of-range
block 197478301302784 for device dm-14
Mar 22 13:47:33 bakunin kernel: EXT4-fs error (device dm-14):
ext4_xattr_delete_inode: inode 1022: block 197478301302784 read error
----------

Please not that I had run an fsck on the mentioned device only a
couple hours earlier, with no errors found.

Now, does this indicate a hardware problem?
My drives' SMART info reports not a single reallocated sector. But one
drive has a high Hardware_ECC_Recovered count, but I got it that's
nothing to actually worry about. Well, it might indicate bad cabling,
though.

    Richard
