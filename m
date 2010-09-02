From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH 1/3] lib: introduce some memory copy macros and functions
Date: Thu, 02 Sep 2010 17:07:24 +1000
Message-ID: <4C7F4D2C.8000206@csamuel.org>
References: <4C7E2CA9.9060702@cn.fujitsu.com> <1283354736.2059.1206.camel@laptop> <4C7F39B3.4000901@cn.fujitsu.com> <4C7F3C60.7000205@csamuel.org> <4C7F4938.6090202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:48239 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0IBHHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Sep 2010 03:07:45 -0400
In-Reply-To: <4C7F4938.6090202@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/10 16:50, Miao Xie wrote:

> I just change the "2.1" to "2" in your patch, because the
> orignal code is LGPL v2.1, LGPL v2.1 permits us to apply
> the terms of the ordinary GNU General Public License instead
> of it.

Ahhh excellent, I hadn't realised that was possible; well spotted!

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
