From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix type-punning warnings
Date: Thu, 16 Dec 2010 14:39:38 -0600
Message-ID: <4D0A790A.1080703@redhat.com>
References: <4D07BEB1.8030406@redhat.com> <20101215230926.GC4455@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0LPUjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 15:39:41 -0500
In-Reply-To: <20101215230926.GC4455@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/15/2010 05:09 PM, Ted Ts'o wrote:
> On Tue, Dec 14, 2010 at 01:00:01PM -0600, Eric Sandeen wrote:
>> Flags used during RHEL/Fedora builds lead to a couple type-punning
>> warnings:
>>
>>   recovery.c: In function 'do_one_pass':
>>   recovery.c:539: warning: dereferencing type-punned pointer will break strict-aliasing rules
>>   ./csum.c: In function 'print_csum':
>>   ./csum.c:170: warning: dereferencing type-punned pointer will break strict-aliasing rules
>>
>> The two changes below fix this up.
>>
>> Note that the csum test binary output changes slightly, but this does
>> not break any tests.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, applied.  There's also a bone-headed big-endian compile bug
> which means I'll be doing an e2fsprogs 1.41.14 shortly.
> 
>       	    	    	     	       - Ted

Hm this may need an include of the e2p.h header as well, if built in
a pristine buildroot...

--- e2fsprogs-1.41.12.orig/lib/ext2fs/csum.c
+++ e2fsprogs-1.41.12/lib/ext2fs/csum.c
@@ -17,6 +17,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 #include "crc16.h"
+#include "e2p/e2p.h"
 #include <assert.h>

 #ifndef offsetof


Sorry about that,
-Eric
