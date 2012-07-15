From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Question about extents.c/ext4_ext_punch_hole
Date: Sun, 15 Jul 2012 21:03:42 +0800
Message-ID: <5002BFAE.9030408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2GONDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jul 2012 09:03:54 -0400
Received: by pbbrp8 with SMTP id rp8so8449774pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 15 Jul 2012 06:03:53 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I'm reading the code of extents.c, and confused by the function "ext4_ext_punch_hole".

In my understanding, if we want to punch hole for the range (loff_t offset, loff_t length),
then we finally will get one hole block-size aligned, right?

[code in ext4_ext_punch_hole]
	first_block = (offset + sb->s_blocksize - 1) >>
		EXT4_BLOCK_SIZE_BITS(sb);
	stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
[code]

>From the code, we'll get one hole range contained in the range [offset, length+offset-1].

For example, we set the block size to 1K, and we specify the range [offset:1000, offset:2000].
Then we'll get first_block:1,stop_block:2, with some head/tail range ignored.
      {-23------|===========|----952---}
     1000      1024       2048        2999
     offset                        offset+length-1
'==='means punched hole here.

Please correct me if I'm wrong.


Regards,
