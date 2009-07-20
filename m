From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/5] e4defrag: return more specific error message on ioctl
 failure
Date: Mon, 20 Jul 2009 12:25:33 +0800
Message-ID: <4A63F1BD.5080508@gmail.com>
References: <1248025668-25901-1-git-send-email-bergwolf@gmail.com> <4A6391DF.3090105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f193.google.com ([209.85.216.193]:60444 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZGTEbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 00:31:16 -0400
Received: by pxi31 with SMTP id 31so203925pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 21:31:16 -0700 (PDT)
In-Reply-To: <4A6391DF.3090105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Peng Tao wrote:
>> Currently e4defrag relies on the EXT4_IOC_MOVE_EXT ioctl to perform online
>> defragmentation. However, this iotcl kernel patch is not available before
>> 2.6.30-rc1. e4defrag shall fail without obvious reasons on systems running
>> older kernels. The patch adds more detailed error message addressing this
>> issue and prompts users with the minimal kernel version that is needed to
>> run e4defrag.
>>
>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> ---
>>  misc/e4defrag.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index c25514a..f1c3008 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -1553,7 +1553,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
>>  			if (mode_flag & DETAIL) {
>>  				printf("\n");
>>  				PRINT_ERR_MSG_WITH_ERRNO(
>> -						"Failed to defrag");
>> +					"Failed to defrag with "
>> +					"EXT4_IOC_MOVE_EXT ioctl");
>> +				if (errno == ENOTTY)
>> +					printf("\tAt least 2.6.31-rc1 of"
>> +						" vallina kernel is required\n");
> 
> Typo here, s/b "vanilla"
> 
> -Eric
Hi, Eric
Thank your for your reviewing. Revised the patch:

>From d56fcfae01c3b0c4963c0ec75ffa654e70086a57 Mon Sep 17 00:00:00 2001
From: Peng Tao <bergwolf@gmail.com>
Date: Mon, 20 Jul 2009 12:11:01 +0800
Subject: [PATCH] e4defrag: return more specific error message on ioctl failure

Currently e4defrag relies on the EXT4_IOC_MOVE_EXT ioctl to perform online
defragmentation. However, this iotcl kernel patch is not available before
2.6.30-rc1. e4defrag shall fail without obvious reasons on systems running
older kernels. The patch adds more detailed error message addressing this
issue and prompts users with the minimal kernel version that is needed to
run e4defrag.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/e4defrag.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c25514a..eff6ed9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1553,7 +1553,11 @@ static int call_defrag(int fd, int donor_fd, const char *file,
 			if (mode_flag & DETAIL) {
 				printf("\n");
 				PRINT_ERR_MSG_WITH_ERRNO(
-						"Failed to defrag");
+					"Failed to defrag with "
+					"EXT4_IOC_MOVE_EXT ioctl");
+				if (errno == ENOTTY)
+					printf("\tAt least 2.6.31-rc1 of "
+						"vanilla kernel is required\n");
 			} else {
 				printf("\t[ NG ]\n");
 			}

-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
