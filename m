From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: donor file data inconsistent after EXT4_IOC_MOVE_EXT
Date: Mon, 19 Oct 2009 17:28:57 +0900
Message-ID: <4ADC2349.6030304@rs.jp.nec.com>
References: <4ADABDB2.6080905@gmail.com> <4ADBB585.7050402@rs.jp.nec.com> <4ADBCEDE.3050009@gmail.com> <4ADBFC4D.8050405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46086 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZJSI3P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 04:29:15 -0400
In-Reply-To: <4ADBFC4D.8050405@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,
Peng Tao wrote:
> Hi, Akira,
> 
> Peng Tao wrote:
>> Hi, Akira,
>> Akira Fujita wrote:
>>> Hi Peng,
>>>
>>> This is a known issue, and I sent a patch to linux-ext4 2 weeks ago.
>>> Unfortunately it is not included in the ext4 patch queue yet.
>>>
>>> http://marc.info/?l=linux-ext4&m=125447192709338&w=2
>>>
>>> Would you retry your test case with above my patch?
>> It didn't work. I still got the old donor file data.
> invalidate_mapping_pages() in your patch won't invalidate the locked page returned by
> grab_cache_page(). The following patch addresses the bug by calling
> invalidate_inode_pages2_range() instead.

Though I tested my patch, I seem to have made a mistake.
Anyway, I confirmed your patch works fine, thank you.

Regards,
Akira Fujita
