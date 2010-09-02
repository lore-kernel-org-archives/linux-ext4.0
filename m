From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH V2 0/3] improve the performance of some memory copy functions
Date: Thu, 02 Sep 2010 17:12:51 +1000
Message-ID: <4C7F4E73.3040500@csamuel.org>
References: <4C7F3A26.6020607@cn.fujitsu.com> <20100902065347.GA29972@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:52487 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0IBHNM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Sep 2010 03:13:12 -0400
In-Reply-To: <20100902065347.GA29972@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/10 16:53, Ingo Molnar wrote:

> and if glibc is under the GPL v2.1

It's LGPL v2.1 which can be converted to GPL v2 under section 3
of its license. See: http://www.gnu.org/licenses/lgpl-2.1.html

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
