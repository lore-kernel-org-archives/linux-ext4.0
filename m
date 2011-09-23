From: Andrew Perepechko <andrew_perepechko@xyratex.com>
Subject: Re: [PATCH 1/2] ext4: MMP: kmmpd should use nodename from init_uts_ns.name,
 not sysname
Date: Fri, 23 Sep 2011 15:30:08 +0400
Message-ID: <4E7C6DC0.1020401@xyratex.com>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com> <1316737389-5522-2-git-send-email-nikitas_angelinas@xyratex.com> <4E7C425B.1060808@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, nikitas_angelinas@xyratex.com
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51218 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576Ab1IWLaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Sep 2011 07:30:22 -0400
In-Reply-To: <4E7C425B.1060808@xyratex.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Never mind, they are not relevant.

Andrew

On 09/23/2011 12:24 PM, Andrew Perepechko wrote:
> Hello Nikitas!
>
> It looks like some bits of your patches somehow got dropped.
>
> Andrew
>
> On 09/23/2011 04:23 AM, Nikitas Angelinas wrote:
>> sysname holds "Linux" by default, i.e. what appears when doing a "uname
>> -s"; nodename should be used to print the machine's hostname, i.e. what
>> is returned when doing a "uname -n" or "hostname", and what
>> gethostname(2)/sethostname(2) manipulate, in order to notify the
>> administrator of the node which is contending to mount the filesystem.
>>
>> Signed-off-by: Nikitas Angelinas<nikitas_angelinas@xyratex.com>
>> Signed-off-by: Andrew Perepechko<andrew_perepechko@xyratex.com>
>> ---
>>   fs/ext4/mmp.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
>> index 9bdef3f..2fca64e 100644
>> --- a/fs/ext4/mmp.c
>> +++ b/fs/ext4/mmp.c
>> @@ -109,7 +109,7 @@ static int kmmpd(void *data)
>>       mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
>>       bdevname(bh->b_bdev, mmp->mmp_bdevname);
>>
>> -    memcpy(mmp->mmp_nodename, init_utsname()->sysname,
>> +    memcpy(mmp->mmp_nodename, init_utsname()->nodename,
>>              sizeof(mmp->mmp_nodename));
>>
>>       while (!kthread_should_stop()) {
>

______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 

