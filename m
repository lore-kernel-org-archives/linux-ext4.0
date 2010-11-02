From: Roman Borisov <ext-roman.borisov@nokia.com>
Subject: ext3 patches related to uninitialized memory references
Date: Tue, 02 Nov 2010 14:55:19 +0300
Message-ID: <4CCFFC27.3010703@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:45392 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0KBLwL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 07:52:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Do you have a plans for next patches commitment?

[PATCH 1/2] ext3: Avoid uninitialized memory references with a corrupted 
htree directory
http://www.spinics.net/lists/linux-ext4/msg21215.html

[PATCH 2/2] ext3: Use search_dirblock() in ext3_dx_find_entry()
http://www.spinics.net/lists/linux-ext4/msg21216.html

I've found only the same patches for ext4 but not for ext3.

Thanks,
Roman
