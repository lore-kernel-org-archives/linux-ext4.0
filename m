From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 3/3] e4defrag: avoid unsuccessful return in non-privileged
 	user
Date: Thu, 01 Oct 2009 17:16:01 +0900
Message-ID: <4AC46541.8000001@sx.jp.nec.com>
References: <4AC3073D.9070606@sx.jp.nec.com> <87f94c370909301137s40f09b7wb08ca7dee9f8dd15@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64730 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbZJAI1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 04:27:48 -0400
In-Reply-To: <87f94c370909301137s40f09b7wb08ca7dee9f8dd15@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/01 3:37, Greg Freemyer wrote::
> 2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
>> If non-privileged user does e4defrag, e4defrag returns 1 despite
>> its success. This patch fixes this problem.
>>
>> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
>> ---
>>
>>  e4defrag.c |    1 +
>>  1 file changed, 1 insertion(+)
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index 94f8529..98dda92 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -2025,6 +2025,7 @@ int main(int argc, char *argv[])
>>                                if (!(mode_flag & DETAIL) &&
>>                                                current_uid != ROOT_UID) {
>>                                        printf(" Done.\n");
>> +                                       success_flag = 1;
>>                                        continue;
>>                                }
> 
> I should know this, but this patch made me wonder about the underlying
> implementation of EXT4_IOC_MOVE_EXT.
> 
> After EXT4_IOC_MOVE_EXT is called, can userspace somehow modify the
> defragged file?
> 
> ie. If I only have readonly access to a file and I call
> EXT4_IOC_MOVE_EXT to replace some of the data blocks, is it possible
> now for me to write data to the donor_fd and thus modify the data in
> the original file?
> 
> Greg

Nope, EXT4_IOC_MOVE_EXT only changes original file blocks but its file
data isn't changed.

If user has readonly access to original or donor file and is both two files
owner, EXT4_IOC_MOVE_EXT succeeds. This means that the ioctl replaces
data blocks and writes original file data into replaced blocks.

Regards,

Kazuya Mio
