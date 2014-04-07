From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: fix shared/002 and 004 fail issue in xfstests
Date: Tue, 8 Apr 2014 08:12:35 +0900
Message-ID: <CAKYAXd9_qZ0s8VMgzhhOH7F8VT5LmasCFO49CXo_bk3qSgK26g@mail.gmail.com>
References: <1396881675-7272-1-git-send-email-linkinjeon@gmail.com>
	<20140407162513.GA9242@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:50951 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaDGXMg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 19:12:36 -0400
Received: by mail-qg0-f48.google.com with SMTP id i50so138434qgf.35
        for <linux-ext4@vger.kernel.org>; Mon, 07 Apr 2014 16:12:35 -0700 (PDT)
In-Reply-To: <20140407162513.GA9242@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-04-08 1:25 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> On Mon, Apr 07, 2014 at 11:41:15PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> When mounting ext4 with data=journal option, shared/002 and 004 are
>> failed on xfstests. Calling ext4_force_commit before
>> filemap_write_and_wait_range is needed to flush all data into journal
>> on this case.
>
> Hi Namjae,
>
> Thanks for working for this!
>
> Could you include in your commit description of why adding a call to
> ext4_force_commit() is necessary to avoid the problem, and what wa
> going wrong in the data=journal case?
Hi Ted.
Yes Sure. I will post the patch with detail description again.
Thanks!
>
> Thanks,
>
> 					- Ted
>
