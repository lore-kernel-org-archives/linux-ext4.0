From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
Date: Tue, 03 Jun 2008 13:30:07 +0900
Message-ID: <4844C8CF.8060700@hitachi.com>
References: <4843CE15.6080506@hitachi.com>
    <20080602120538.GK30613@duck.suse.cz>
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
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34587 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYFCEaR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 00:30:17 -0400
In-Reply-To: <20080602120538.GK30613@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Jan Kara wrote:
> On Mon 02-06-08 19:40:21, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
> 
>   Just a small note - repeating the subject in the changelog makes it a bit
> harder for Andrew to merge the patches. Standard merging scripts prepend
> subject of the email to the changelog below and so in your case the message
> would be there twice... Just that you know when you create the patch series
> next time.

Thank you for letting me know.  I'll not do such odd thing next time.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

