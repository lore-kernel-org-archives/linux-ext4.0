From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: can't get e4defrag to work
Date: Mon, 26 Jan 2009 16:37:39 +0900
Message-ID: <497D6843.50905@rs.jp.nec.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>	 <49797056.7030607@rs.jp.nec.com> <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Derkjan de Haan <haanjdj@gmail.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	linux-ext4@vger.kernel.org,
	Sandeep K Sinha <sandeepksinha@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64224 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZAZHiG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 02:38:06 -0500
In-Reply-To: <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Greg,

Greg Freemyer wrote:
> Will the new defrag patchset be based on the ioctl's that Ted
> suggested last month?

Yes, but the new defrag that I will release corresponds to (3) of
Ted's suggestion.
(http://marc.info/?l=linux-ext4&m=122880166227883&w=3)

For (1) and (2), probably it will be necessary to change
the allocation method and add new ioctls, so I will address them later.

Have you already worked on these features?

Regards,
Akira Fujita

--Separator@a-fujita@rs.jp.nec.com:
greg.freemyer@gmail.com
haanjdj@gmail.com
sandeepksinha@gmail.com
linux-ext4@vger.kernel.org
