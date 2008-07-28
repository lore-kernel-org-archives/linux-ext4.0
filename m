From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 3/4] ext3: abort ext3 if the journal has aborted
Date: Mon, 28 Jul 2008 15:26:22 +0900
Message-ID: <488D668E.3030406@hitachi.com>
References: <488876D3.80004@hitachi.com> <4888782E.2050102@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44803 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYG1G0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 02:26:35 -0400
In-Reply-To: <4888782E.2050102@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 4. when checkpointing fails, notify this error to the ext3 layer so
>    that ext3 don't clear the needs_recovery flag, otherwise the
>    journaled contents are ignored and cleaned in the recovery phase

Mike Snitzer noticed that ext3_mark_recovery_complete() doesn't
check checkpointing failure and it clears needs_recovery flag 
(thanks, Mike!).  I need an additional fix.

I also found ext3_quota_on() forces checkpointing by journal_flush()
but it doesn't check the error.  This will appear in 2.6.27-rc1,
so I'll send the revised patch set for 2.6.27-rc1 (it may be
a separate patch).

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

