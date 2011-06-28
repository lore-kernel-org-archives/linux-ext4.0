From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Tue, 28 Jun 2011 19:21:30 +0900
Message-ID: <4E09AB2A.6000105@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com> <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com> <4E044AB4.9010804@sx.jp.nec.com> <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38772 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1F1KWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 06:22:14 -0400
In-Reply-To: <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/26 11:16, Greg Freemyer wrote:
> I'm talking about sparse files.
>
> Where you might have:
>
> block_group1 - hole - block_group2 - hole - block_group3.
>
> Block_group2 has a head and a tail extent.  In my mind, from a
> performance perspective, they are symmetric.  Meaning that having a
> small extent at the beginning is no better and no worse than having a
> small extent at the end.

Thanks for your kind description. Your point is right. I'll think a little more
about the fragmentation score.

Regards,
Kazuya Mio
