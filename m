From: Roman Borisov <ext-roman.borisov@nokia.com>
Subject: ext3 patches related to uninitialized memory references
Date: Mon, 01 Nov 2010 19:34:29 +0300
Message-ID: <4CCEEC15.4070001@nokia.com>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: ext Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:34386 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0KAQax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Nov 2010 12:30:53 -0400
In-Reply-To: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
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

