From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Thu, 12 Nov 2009 09:11:52 -0600
Message-ID: <4AFC25B8.2070804@redhat.com>
References: <4AFC14D6.7080700@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbZKLPLu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 10:11:50 -0500
In-Reply-To: <4AFC14D6.7080700@diamondcut.com.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Renato S. Yamane wrote:
> Hi,
> 
> [please, leave me on cc because I'm not subscribed on this ML]
> 
> I'm using Intel SSD X25-M on my laptop, and I always hear that is not a 
> good idea use journal on SSD (it decrease the life time).
> 
> I ask Intel about this, but I don't receive any answer.
> 
> So, I would like to know if is possible disable Journal on EXT4.

It is possible, mkfs with "-O ^has_journal" but then of course you ... 
have no journaling.

However, Intel has always said, I think, that you should treat their 
SSDs just like you would treat any other hard drive, so I probably would 
not hesitate to leave the journal intact.

There is a write lifetime of course, but I think it's much better than 
if you were writing to, say, a securedigital card.

-Eric

> I'm using Debian Testing (squeeze).
> 
> Regards,
> Renato S. Yamane
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

