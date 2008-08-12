From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio	writereturningEIOwhentry_to_release_page
 fails
Date: Tue, 12 Aug 2008 09:38:49 -0700
Message-ID: <48A1BC99.1010802@oracle.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>	 <20080804145047.04794bf3.akpm@linux-foundation.org>	 <1217907353.7611.39.camel@think.oraclecorp.com>	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>	 <1217953055.7899.11.camel@think.oraclecorp.com>	 <1217971027.7516.20.camel@mingming-laptop>	 <1218029114.15342.58.camel@think.oraclecorp.com>	 <20080806135337.GA3615@duck.suse.cz>	 <1218063477.6383.41.camel@mingming-laptop>	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>	 <1218104494.15342.171.camel@think.oraclecorp.com>	 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>	 <1218200055.15342.230.camel@think.oraclecorp.com>	 <6.0.0.20.2.20080811123405.03ec03d0@172.19.0.2> <1218547706.15342.305.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([207.173.201.20]:52563 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYHLQiu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 12:38:50 -0400
In-Reply-To: <1218547706.15342.305.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> With that said, I don't have strong feelings against falling back to
> buffered IO when the invalidate fails.  Maybe Zach remembers something I
> don't?

Nothing surprising is immediately coming to mind, no.  I don't have
strong feelings against adding this case to the list of criteria that
causes it to fall back to buffered.

- z
