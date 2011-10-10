From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs: use ALL_CFLAGS to build gen_crc32ctable
Date: Mon, 10 Oct 2011 12:52:58 -0500
Message-ID: <4E9330FA.4070307@redhat.com>
References: <4E89DF57.90806@redhat.com> <20111004030232.GA28372@thunk.org> <4E932DBE.7080203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1JJRxB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 13:53:01 -0400
In-Reply-To: <4E932DBE.7080203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/11 12:39 PM, Eric Sandeen wrote:
> On 10/3/11 10:02 PM, Ted Ts'o wrote:

...


>> diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
>> index 65bca5c..6be4336 100644
>> --- a/lib/ext2fs/crc32c.c
>> +++ b/lib/ext2fs/crc32c.c
>> @@ -40,6 +40,23 @@
>>  #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
>>  #include "crc32c_defs.h"
>>  
>> +#include "ext2fs.h"
>> +#ifdef WORDS_BIGENDIAN
> 
> well, this has the exact same problem as originally reported, because
> we still don't have the include paths to find ext2fs.h in the tree,
> and it is still included via crc32c_defs.h

Sorry, ignore that; PEBKAC here.  :(

(tarball naming convention change means I had to fix up the source
tarball name in 2 places in the spec, and I missed one.  Apologies...)

Now I am getting translation table problems, but I'll see what's up
there.

mv: cannot stat `t-es.gmo': No such file or directory
mv: cannot stat `t-ca.gmo': No such file or directorymake[2]: *** [es.gmo] Error 1

-Eric
