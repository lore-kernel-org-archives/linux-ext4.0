From: Ying Han <yinghan@google.com>
Subject: Re: [PATCH] ext2: Fix data corruption for racing writes
Date: Thu, 9 Apr 2009 13:59:50 -0700
Message-ID: <604427e00904091359t3e068ffm1868d164824fb575@mail.gmail.com>
References: <1238715399-22172-1-git-send-email-jack@suse.cz>
	 <a4a7801d0904031738h68bf6218lfd3349ca50f46642@mail.gmail.com>
	 <20090406102329.GD31189@duck.suse.cz>
	 <20090409133030.a7ea94c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, yinghan@gmail.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	nickpiggin@yahoo.com.au
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:6857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbZDIU74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 16:59:56 -0400
In-Reply-To: <20090409133030.a7ea94c7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 9, 2009 at 1:30 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 6 Apr 2009 12:23:29 +0200
> Jan Kara <jack@suse.cz> wrote:
>
>> >
>> > I tried this patch and seems i got deadlock on the truncate_mutex.
>> > Here is the message after enabling lockdep. I pasted the same message
>> > on the origianal thread.
>>
>> ...
>>
>>   I don't think this is a deadlock (or is the machine hung?). The thread
>> was just waiting for a long time. I'd think that you'll occasionally get
>> exactly the same message even without my patch if you stress the machine
>> like you do.
>>
>
> Well, it's easy to tell the difference
>
> deadlock: system never recovers
> long-sucky-delay: system eventually recovers.
>
> Which was it??
Guess i have to retest it. I didn't wait long enough to see what
happened on the machine. However, i do see the machine got rebooted
later, but i am not sure what is the reason it is got reboot.

I will rerun the patch and keep an eye on it this time.

--Ying
>
