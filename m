From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space in
	failure
Date: Wed, 2 Sep 2009 16:59:19 -0400
Message-ID: <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:60942 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZIBU7R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 16:59:17 -0400
Received: by qw-out-2122.google.com with SMTP id 8so428566qwh.37
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 13:59:19 -0700 (PDT)
In-Reply-To: <4A9E9521.2010701@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 11:54 AM, Peng Tao<bergwolf@gmail.com> wrote:
> Hi, Akira,
>
> Akira Fujita wrote:
>> ext4: Return exchanged blocks count to user space in failure
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> Return exchanged blocks count (moved_len) to user space,
>> if ext4_move_extents() failed on the way.
> Even with the patch, I still don't see how users can fix EXT4_IOC_MOVE_EXT failures,
> because the orig file itself may be broken.

Peng,

I have not looked at the code very closely, but can you tell me where
a file corruption can take place?   Not completing the replacement of
extents with donor extents is one thing.  Corrupting the original file
contents is another.

Clearly we need EXT4_IOC_MOVE_EXT to fail gracefully and not corrupt
the original file the vast majority of the time.

Greg
