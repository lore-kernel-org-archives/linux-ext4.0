From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
 test
Date: Wed, 20 Mar 2013 21:07:27 -0500
Message-ID: <514A6B5F.7000705@redhat.com>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com> <20130321010902.GH17758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3CUCHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 22:07:44 -0400
In-Reply-To: <20130321010902.GH17758@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/20/13 8:09 PM, Dave Chinner wrote:
> On Tue, Mar 19, 2013 at 05:30:50PM +0800, Zheng Liu wrote:
>> From: Zheng Liu <wenqing.lz@taobao.com>
>>
>> After finished test, temporarily fio config file should be removed.
>>
>> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>> ---
>>  299 | 2 +-
>>  300 | 2 +-
>>  301 | 2 +-
>>  302 | 2 +-
>>  303 | 2 +-
>>  304 | 2 +-
>>  305 | 1 +
>>  7 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/299 b/299
>> index 4305ead..9d0c32f 100644
>> --- a/299
>> +++ b/299
>> @@ -32,7 +32,7 @@ echo "QA output created by $seq"
>>  here=`pwd`
>>  tmp=/tmp/$$
>>  status=1	# failure is the default!
>> +trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15
> 
> Umm, wouldn't this be better:
> 
> -trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +trap "rm -f $tmp*; exit \$status" 0 1 2 3 15
> 

Naming the files $tmp.fio would have worked too, but *shrug*
doesn't seem that critical.  Still:

>      2. You can safely create temporary files that are not part of the
>         filesystem tests (e.g. to catch output, prepare lists of things
>         to do, etc.) in files named $tmp.<anything>.  The standard test
>         script framework created by "new" will initialize $tmp and
>         cleanup on exit.

-Eric

> Cheers,
> 
> Dave.
> 

