From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: Problems with Online Defragmentation (was: Re: bugs of Online Defragmentation)
Date: Mon, 22 Dec 2008 13:36:59 +0800
Message-ID: <494F277B.3080902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50652 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYLVFgT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Dec 2008 00:36:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I tested Online Defrag by using the new code.
When I have space left which is less than 40M, I can't use e4defrag function.

Does the Online Defragmentation need some space left which is greater than a value? 40M?

-- 
Regards
Zhang Xiliang

