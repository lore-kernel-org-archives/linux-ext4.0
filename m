From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 13:58:42 +0200
Message-ID: <20070419115840.GA11780@kernel.dk>
References: <462622F8.10107@bull.net> <20070419090346.GE20928@kernel.dk> <462736FC.3090902@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:2724 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993248AbXDSMBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2007 08:01:10 -0400
Content-Disposition: inline
In-Reply-To: <462736FC.3090902@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 19 2007, Valerie Clement wrote:
> Jens Axboe wrote:
> >Please tell me how you are running ffsb, and also please include a
> >dmessg from a booted system.
> >
> Hi,
> our mails crossed! please see my response to Andrew.
> You could reproduce the problem with dd command as suggested, it's more 
> easy.
> I'm sending you the dmesg info. For my tests I used the scsci sdc device.

Thanks, it does. Can you try one thing for me? If you run the test on
sdc, try doing:

# echo 64 > /sys/block/sdc/queue/iosched/quantum

and repeat the test.

-- 
Jens Axboe
