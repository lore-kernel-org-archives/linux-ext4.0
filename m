From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
 size
Date: Tue, 23 Jun 2009 12:32:16 +0900
Message-ID: <4A404CC0.9050202@jp.fujitsu.com>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int> <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com> <20090621035731.GA6719@mit.edu> <4A3EE269.3020704@jp.fujitsu.com> <20090622024757.GB26079@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48358 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFWDcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 23:32:18 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n5N3WKvV002642
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 23 Jun 2009 12:32:20 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id B293445DE53
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 12:32:19 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 7A87745DE51
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 12:32:19 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 46447E08005
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 12:32:19 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 052041DB8038
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 12:32:19 +0900 (JST)
In-Reply-To: <20090622024757.GB26079@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted-san,

Theodore Tso wrote:
 > Are you aware of any patches that enable an IA64 system to support a
 > page size greater than 64kB?  (And whether any customer would actually
 > want to use them, given the downsides of very large page size?)  The
No, I am not. But I have considered that POWERPC system has been
supported over 64KB page size after I examined all Kconfig's in kernel
source. Therefore I thought this bug should be fixed in kernel side.

 > issue is that Linux doesn't support filesystem block sizes > than the
 > page size.  In any case, I don't mind adding patches that attempt to
 > make it better to support large block sizes; I don't really want to
 > claim that we support it until we can actually fully test for that
I think so, too.

 > feature, though.  Is it your intent to actually try to provide support
 > for this at some point?  I'll help you if you are, but you'll have to
 > do the testing, since I don't have access to an IA64 platform that
 > might be able to support these sorts of large pages.
 >
 > Thanks,
 >
 > 						- Ted
I don't think this feature (over 64KB block size support) to be necessary
immediately. Because I have been investigating ext4 for my customers
in order that I may provide them greater quality and performance but they don't
  want it now.
But when my customers want this feature, I will try to test it.

Best regards,
Toshiyuki Okajima

