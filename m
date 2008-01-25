From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 25 Jan 2008 21:42:30 +0900
Message-ID: <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <84144f020801250317pbdafc4fnd47cc8a297194e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49997 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYAYMoe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 07:44:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> I am also wondering whether we should have system call(s) for these:
> 
> On Jan 25, 2008 12:59 PM, Takashi Sato <t-sato@yk.jp.nec.com> wrote:
>> +       case EXT3_IOC_FREEZE: {
> 
>> +       case EXT3_IOC_THAW: {
> 
> And just convert XFS to use them too?

I think it is reasonable to implement it as the generic system call, as you said.
Does XFS folks think so?

Cheers, Takashi
