From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 25 Sep 2008 17:06:10 -0400
Message-ID: <48DBFD42.6030307@redhat.com>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYIYVGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Sep 2008 17:06:53 -0400
In-Reply-To: <20080908171119.GB22521@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>   
>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>> when the freezer accesses a frozen filesystem. And new ioctl
>> to reset the timeout period is added to extend the timeout period.
>> For example, the freezer resets the timeout period to 10 seconds every 5
>> seconds.  In this approach, even if the freezer causes a deadlock by
>> accessing the frozen filesystem, it will be solved by the timeout
>> in 10 seconds and the freezer will be able to recognize that
>> at the next reset of timeout period.
>>     
>
> And as with all previous posting I still fundamentally disagree about
> the need of this functionality.  We don't need a timeout for freezing.
>
>   

I agree with Christoph here, I think that the timeout is unneeded.

Regards,

Ric

