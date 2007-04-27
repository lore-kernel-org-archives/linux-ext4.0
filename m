From: Mark Lord <lkml@rtr.ca>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 09:50:41 -0400
Message-ID: <4631FFB1.90503@rtr.ca>
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>	 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <1177677058.28223.11.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:1473 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbXD0Nun (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 09:50:43 -0400
In-Reply-To: <1177677058.28223.11.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Peter Zijlstra wrote:
>
> No way is globally disabling fsync() a good thing. I guess Andrew just
> is a sucker for punishment :-)

Mmm... perhaps another nice thing to include in laptop-mode operation?
