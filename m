From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Confused by journaling code in ext3_new_blocks()
Date: Wed, 23 Jan 2008 04:07:49 -0500
Message-ID: <d9885f0f0801230107h6994847fg96d07198011b2065@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:22122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYAWJHx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 04:07:53 -0500
Received: from zps18.corp.google.com (zps18.corp.google.com [172.25.146.18])
	by smtp-out.google.com with ESMTP id m0N97os1026634
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 01:07:50 -0800
Received: from rv-out-0910.google.com (rvfb22.prod.google.com [10.140.179.22])
	by zps18.corp.google.com with ESMTP id m0N97naX001017
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 01:07:50 -0800
Received: by rv-out-0910.google.com with SMTP id b22so2206915rvf.21
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 01:07:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have the following question related to the journaling code in
ext3_new_blocks() function of fs/ext3/balloc.c, any help in this
regard will be greatly appreciated. The code snippet below is taken
from 2.6.24-rc8-mm1 but this code has changed little for a long time
so it's likely that any other recent kernel will also have very
similar code.

ext3_new_blocks()
-> ext3_try_to_allocate_with_rsv()
    -> ext3_journal_dirty_metadata(handle, bitmap_bh)
...
allocated:
if ( /*sanity checking of newly allocated block numbers*/) {
    ext3_error(...);
    goto out;
}

out:
    ...
    brelse(bitmap_bh);
    return 0;


In the above code snippet, ext3_try_to_allocate_with_rsv() is marking
bitmap_bh as dirty metadata _before_ the sanity checks. I'm not
worried about the sanity checks as such, but it seems to me that if
the checks were to fail, we'd be committing the bitmap_bh updates to
disk even though it violates metadata sanity, or am I missing
something here ?

Thanks,
Abhishek
