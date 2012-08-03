From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Use fsck to free the space used by dir?
Date: Fri, 03 Aug 2012 10:18:57 -0500
Message-ID: <501BEBE1.5080508@redhat.com>
References: <501BDDE5.8060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab2HCPTA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2012 11:19:00 -0400
In-Reply-To: <501BDDE5.8060005@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/3/12 9:19 AM, Wang Sheng-Hui wrote:
> Dear all,
> 
> I read through the namei.c code recently, but didn't notice any code to
> reduce the size of a dir file (append can increase its size though).

Right, AFAIK nothing in kernelspace will reduce the size.

> I wonder if I create large amount of files under dir A, then remove all
> the sub items, do I need to run fsck to free the disk space used by the
> dir file? 

Yes, e2fsck -fD should compress them again.

-Eric

> Please help confirm or if I missed some points.
> 
> 
> Regards,
> Sheng-Hui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

