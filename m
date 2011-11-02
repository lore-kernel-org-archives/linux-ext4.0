From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in balance_dirty_pages
Date: Wed, 02 Nov 2011 14:24:01 +0900
Message-ID: <4EB0D3F1.6020102@sx.jp.nec.com>
References: <4EA6A5E5.2050604@sx.jp.nec.com> <20111025134045.GB8072@quack.suse.cz> <4EAA3EE7.4040802@sx.jp.nec.com> <20111101231342.GJ18701@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:57298 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1KBFc6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 01:32:58 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id pA25Wvcu021867
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 14:32:57 +0900 (JST)
In-Reply-To: <20111101231342.GJ18701@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/02 8:13, Jan Kara wrote:
>> The problem is that we cannot unmount the corrupted filesystem due to
>> un-killable dd process. We must bring down the system to resume the service
>> with no dirty pages. I think it is important for the service continuity
>> to be able to kill the thread handling in balance_dirty_pages().
>    Sure. Then allowing a process to be killed while waiting in
> balance_dirty_pages() would solve your problem. That can be done relatively
> easily. I can write the patch, just now the code is under rewrite from
> IO-less dirty throttling patches so I'll wait for a while for it to settle
> down.

Thanks for working this on.

Regards,
Kazuya Mio
