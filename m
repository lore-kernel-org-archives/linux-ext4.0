From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
 size
Date: Mon, 22 Jun 2009 10:46:17 +0900
Message-ID: <4A3EE269.3020704@jp.fujitsu.com>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int> <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com> <20090621035731.GA6719@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33130 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZFVBqW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jun 2009 21:46:22 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n5M1kOSV024574
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 22 Jun 2009 10:46:24 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id CB45045DE51
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:46:23 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id ACAF645DE4F
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:46:23 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 902A51DB803F
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:46:23 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 4DE961DB8040
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 10:46:23 +0900 (JST)
In-Reply-To: <20090621035731.GA6719@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted-san,

Theodore Tso wrote:
> Toshiyuki-san,
> 
> I'm curious what if any testing you've done using 128k or 256k block
> sizes?  I note that EXT4_MAX_BLOCK_SIZE is still set to 65536, and of
> course, > 64k blocksize testing can only take place on systes with
> page sizes > 64k --- of which there are very few at the moment.
> 
> Thanks,
> 
> 						- Ted
I have been reviewing the logic around dir_index(fs/ext4/dir.c fs/ext4/namei.c)
for the sake of performance and quality improvement. Then I found this bug.
Sorry, therefore it is not a result of the real test.

Best regards,
Toshiyuki Okajima


