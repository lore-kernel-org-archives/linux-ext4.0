From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RFC] do you want jbd2 interface of ext3?
Date: Tue, 16 Feb 2010 16:41:23 +0900
Message-ID: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56861 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab0BPIPt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 03:15:49 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o1G8FlKh010015
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 16 Feb 2010 17:15:48 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9E60B45DE4E
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 17:15:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7E42D45DD77
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 17:15:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6842E1DB8038
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 17:15:47 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 236FE1DB803A
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 17:15:44 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I will try to change the journaling interface of ext3 from jbd into jbd2.

jbd2 has new features from jbd. For example, it includes the integrity 
improvement features. The body of ext3 is already enough quality. If ext3 
changes the journaling interface from jbd into jbd2, ext3 filesystem with jbd2
interface may get better integrity than with the jbd interface.
(jbd2 is aggressively being developed now, so I think we are glad if we can 
get the effect of the development of jbd2 for ext3.)

And ext3 is as de facto standard filesystem, so jbd2 component will be used 
by more people than now if ext3 has the jbd2 interface. If many people used 
the jbd2 interface of ext3, the jbd2 component would get more chances to 
improve the quality and performance and so on. 

Besides, ext3 is now the only user of jbd. 
(ocfs2 which was the user of jbd is now the user of jbd2.)

Do you want the jbd2 interface of ext3?
If you want the jbd2 interface, I will try to implement one.

Best regards,
Toshiyuki Okajima
