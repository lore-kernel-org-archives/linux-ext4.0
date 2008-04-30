From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 30 Apr 2008 10:10:13 +0900
Message-ID: <D8E7FEBEEB9649CF9E2FC389BC5F8C6B@nsl.ad.nec.co.jp>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org> <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp> <20080428130358.GB2798@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<dm-devel@redhat.com>, <xfs@oss.sgi.com>,
	<linux-ext4@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34022 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbYD3BLF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Apr 2008 21:11:05 -0400
In-Reply-To: <20080428130358.GB2798@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

>> bd_mount_sem can protect against only freezes and cannot protect against
>> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
>> bd_mount_sem might occur incorrectly.
>
> Indeed.  The bit flag would fix that because unfreeze could then check
> for the bit beeing set first.  So that's probably the easiest way to go.

I think the bit flag is more efficient than the semaphore.
So I will consider whether it can be used for the freeze feature.

Cheers, Takashi
