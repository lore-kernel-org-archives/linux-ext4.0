From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
Date: Wed, 27 Apr 2011 15:05:16 -0500
Message-ID: <1303934716.2583.22.camel@mulgrave.site>
References: <1303920553.2583.7.camel@mulgrave.site>
	 <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <1303925374-sup-7968@think>  <1303926637.2583.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab1D0UFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2011 16:05:23 -0400
In-Reply-To: <1303926637.2583.17.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-04-27 at 12:50 -0500, James Bottomley wrote:
> To test the theory, Chris asked me to try with data=ordered.
> Unfortunately, the deadlock still shows up.  This is what I get.

As another data point: I'm trying the same kernel with CONFIG_PREEMPT
enabled.  This time the deadlock doesn't happen.  Instead, kswapd0 gets
pegged at 99% CPU for much of the untar, but it does eventually
complete.

James


