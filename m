From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: dereference before check in ext4_move_extents()
Date: Tue, 15 May 2012 11:01:55 +0900
Message-ID: <4FB1B913.8070300@rs.jp.nec.com>
References: <20120513184321.GA16541@elgon.mountain> <4FB0C29F.2080403@rs.jp.nec.com> <20120514085151.GC16999@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49115 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab2EOCC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 22:02:29 -0400
In-Reply-To: <20120514085151.GC16999@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Sorry, I apologize for that.  It's some new Smatch stuff I'm working
> on.  I haven't pushed it yet.

Ok, I'll make a patch when new Smatch appears.

Regards,
Akira Fujita

(2012/05/14 17:51), Dan Carpenter wrote:
> On Mon, May 14, 2012 at 05:30:23PM +0900, Akira Fujita wrote:
>> I'll fix above compile warning surely, but it's not the original
>> you reported. Hmm, how can I reproduce yours?
>>
> 
> Sorry, I apologize for that.  It's some new Smatch stuff I'm working
> on.  I haven't pushed it yet.
> 
> regards,
> dan carpenter
> 
> 
