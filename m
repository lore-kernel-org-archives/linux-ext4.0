From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: ext2/3/4 online defrag
Date: Thu, 10 May 2007 18:20:55 +0900
Message-ID: <020201c792e4$86569b10$4168010a@bsd.tnes.nec.co.jp>
References: <1178770799.26695.11.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Eric" <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:56871 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbXEJJZQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 May 2007 05:25:16 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4A9PEuM000658
	for <linux-ext4@vger.kernel.org>; Thu, 10 May 2007 18:25:14 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4A9LCx6002493
	for <linux-ext4@vger.kernel.org>; Thu, 10 May 2007 18:21:12 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4A9LCC08641 for linux-ext4@vger.kernel.org; Thu, 10 May 2007 18:21:12 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l4A9LCO23579 for <linux-ext4@vger.kernel.org>; Thu, 10 May 2007 18:21:12 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070510.182116.81202716 for <linux-ext4@vger.kernel.org>
	; Thu, 10 May 2007 18:21:16 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> I've searched the archives and googled around, and I've come to the
> following conclusions:
> *An offline defrag tool is available but dangerous.
> *Some patches exist that provide preliminary support for online defrag
> in the ext3 driver, but interest in improving/integrating these patches
> is low.
> *An implementation of an ext* filesystem driver can work with any
> ext2/3/4 filesystem as long as it supports the necessary revision
> (GOOD_OLD_REV or DYNAMIC_REV) and feature flags set in the filesystem.

I'm working on the development of online defrag for ext4.
The defrag can work effectively for fragmented huge files.
So I'm focussing on ext4 which can store many huge files and
developing the defrag for extent files on ext4.
Any comments are very welcome.

Takashi
