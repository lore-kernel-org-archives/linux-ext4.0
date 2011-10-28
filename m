From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in balance_dirty_pages
Date: Fri, 28 Oct 2011 14:34:31 +0900
Message-ID: <4EAA3EE7.4040802@sx.jp.nec.com>
References: <4EA6A5E5.2050604@sx.jp.nec.com> <20111025134045.GB8072@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43142 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1J1Fht (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 01:37:49 -0400
In-Reply-To: <20111025134045.GB8072@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/10/25 22:40, Jan Kara wrote:
>   Please no. Generally this boils down to what do we do with dirty data
> when there's error in writing them out. Currently we just throw them away
> (e.g. in media error case) but I don't think that's a generally good thing
> because e.g. admin may want to copy the data to other working storage or
> so. So I think we should rather keep the data and provide a mechanism for
> userspace to ask kernel to get rid of the data (so that we don't eventually
> run OOM).

I see. I agree with you.

>> Do you have any ideas?
>   So the question is what would you like to achieve. If you just want to
> unblock a thread then a solution would be to make a thread at
> balance_dirty_pages() killable. If generally you want to get rid of dirty
> memory, then I don't have a really good answer but throwing dirty data away
> seems like a bad answer to me.

The problem is that we cannot unmount the corrupted filesystem due to
un-killable dd process. We must bring down the system to resume the service
with no dirty pages. I think it is important for the service continuity
to be able to kill the thread handling in balance_dirty_pages().

Regards,
Kazuya Mio

