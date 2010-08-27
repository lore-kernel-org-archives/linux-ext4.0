From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: defragmentation of boot related files
Date: Fri, 27 Aug 2010 20:21:25 +0900
Message-ID: <4C779FB5.4000206@sx.jp.nec.com>
References: <4C7505C3.1070509@rid-net.de>	<4C762AF3.8020303@sx.jp.nec.com> <AANLkTi=zdx6QjsB+EJrOtmpr9BY-j24TGTJaeisAcqu7@mail.gmail.com> <4C76CB9C.2060207@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: andreas@rid-net.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63252 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0H0LWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Aug 2010 07:22:48 -0400
In-Reply-To: <4C76CB9C.2060207@rid-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/08/27 5:16, andreas@rid-net.de wrote:
>>> Usage: e4defrag -r directory...| device...
>>> e4defrag -r base_file move_file...<--- new
>>>
> 
> The new interface looks nice. As I see it's easy to implement cause only the main-function must be modified.

I think so.

> If you have no objections, I will do it myself and send you the patch to review it.

That would be great.

Regards,
Kazuya Mio
