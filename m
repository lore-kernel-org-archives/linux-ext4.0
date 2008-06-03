From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Tue, 03 Jun 2008 13:31:52 +0900
Message-ID: <4844C938.7030401@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com>
    <20080602124409.GL30613@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38301 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYFCEb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 00:31:57 -0400
In-Reply-To: <20080602124409.GL30613@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Thank you for reviewing.

Jan Kara wrote:

>>@@ -347,6 +361,8 @@ restart:
>> 				break;
>> 			}
>> 			retry = __process_buffer(journal, jh, bhs,&batch_count);
>>+			if (retry < 0)
>>+				result = retry;
> 
>   Here you update result whenever retry is < 0 and below when result == 0.
> I think it's better to have these two consistent (not that it would be
> currently any functional difference).

I fixed it.

> Only please add a comment in front of
> log_do_checkpoint() that it's supposed to be called with j_checkpoint_mutex
> held so that EIO propagation works correctly.

I added a comment.

I'll send the revised patch soon.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

