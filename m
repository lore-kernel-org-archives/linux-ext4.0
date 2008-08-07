From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent transactions
Date: Thu, 7 Aug 2008 01:47:17 +0100
Message-ID: <e9e943910808061747x57dc2ed0s614785d9d0a087a8@mail.gmail.com>
References: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
	 <1217951437.3886.36.camel@sisko.scot.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, "Sami Liedes" <sliedes@cc.hut.fi>
To: "Stephen C. Tweedie" <sct@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:11311 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYHGArT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2008 20:47:19 -0400
Received: by mu-out-0910.google.com with SMTP id w8so188374mue.1
        for <linux-ext4@vger.kernel.org>; Wed, 06 Aug 2008 17:47:17 -0700 (PDT)
In-Reply-To: <1217951437.3886.36.camel@sisko.scot.localnet>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/8/5 Stephen C. Tweedie <sct@redhat.com>:
> On Tue, 2008-08-05 at 00:51 +0100, Duane Griffin wrote:
>> The __log_wait_for_space function sits in a loop checkpointing transactions
>> until there is sufficient space free in the journal. However, if there are
>> no transactions to be processed (e.g. because the free space calculation is
>> wrong due to a corrupted filesystem) it will never progress.
>>
>> Check for space being required when no transactions are outstanding and
>> abort the journal instead of endlessly looping.
>
> I'm not sure this is the right fix --- it seems like we're fixing the
> symptoms, not the problem.
>
> The journal free space fields are reset in journal_reset() when we load
> the journal, so we can't get this situation of j_free being insufficient
> on an idle filesystem unless the main journal start/end pointers are
> corrupt.
>
> Surely we'd be better off detecting this in the first place at mount
> time, not later on during checkpoint?

Sounds sensible. In fact I've got another patch, waiting for feedback
from the reporter, that adds some very basic validation there (i.e.
first > 0 && last >= first). Not enough, I suspect. I guess we could
do much better?

> Cheers,
>  Stephen

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
