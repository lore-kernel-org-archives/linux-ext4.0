From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 26 Sep 2008 17:52:35 +0900
Message-ID: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Oleg Nesterov" <oleg@tv-sign.ru>, <linux-fsdevel@vger.kernel.org>,
	<dm-devel@redhat.com>, <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <axboe@kernel.dk>,
	<mtk.manpages@googlemail.com>, <linux-kernel@vger.kernel.org>
To: "Ric Wheeler" <rwheeler@redhat.com>,
	"Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58944 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYIZIxo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 04:53:44 -0400
In-Reply-To: <48DBFD42.6030307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Ric Wheeler wrote:
> Christoph Hellwig wrote:
>> On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
>>
>>> The timeout feature is added to "freeze ioctl" to solve a deadlock
>>> when the freezer accesses a frozen filesystem. And new ioctl
>>> to reset the timeout period is added to extend the timeout period.
>>> For example, the freezer resets the timeout period to 10 seconds every 5
>>> seconds.  In this approach, even if the freezer causes a deadlock by
>>> accessing the frozen filesystem, it will be solved by the timeout
>>> in 10 seconds and the freezer will be able to recognize that
>>> at the next reset of timeout period.
>>>
>>
>> And as with all previous posting I still fundamentally disagree about
>> the need of this functionality.  We don't need a timeout for freezing.
>
> I agree with Christoph here, I think that the timeout is unneeded.

I think that your concern is that the freezer cannot recognize the occurrence
of a timeout and it continues the backup process and the backup data is
corrupted finally.
If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
 be solved?
If so, I will implement it.

Cheers, Takashi

