From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 01/12] container quota: add kernel configuration for container
 quota.
Date: Thu, 31 May 2012 13:01:32 +0400
Message-ID: <4FC7336C.3060802@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <1338389946-13711-2-git-send-email-jeff.liu@oracle.com> <4FC73318.3020709@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <jack@suse.cz>, <tytso@mit.edu>,
	<containers@lists.linux-foundation.org>, <david@fromorbit.com>,
	<hch@infradead.org>, <bpm@sgi.com>, <christopher.jones@oracle.com>,
	<linux-fsdevel@vger.kernel.org>, <cgroups@vger.kernel.org>,
	<tm@tao.ma>, <linux-ext4@vger.kernel.org>,
	<chris.mason@oracle.com>, <tinguely@sgi.com>
To: <jeff.liu@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4FC73318.3020709@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/31/2012 01:00 PM, Glauber Costa wrote:
> On 05/30/2012 06:58 PM, jeff.liu@oracle.com wrote:
>> Add kernel configuration for container quota.
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>> ---
>> fs/quota/Kconfig | 9 +++++++++
>> 1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
>> index 880fd98..2dd3e83 100644
>> --- a/fs/quota/Kconfig
>> +++ b/fs/quota/Kconfig
>> @@ -16,6 +16,15 @@ config QUOTA
>> with the quota tools. Probably the quota support is only useful for
>> multi user systems. If unsure, say N.
>>
>> +config NS_QUOTA
>> + bool "Mount namespace quota support"
>> + depends on QUOTA
>> + default n
>> + help
>> + If you say Y here, you will be able to set per container user limits
>> + for disk usage (also called disk quotas). Currently, it works for the
>> + ext4 file system only for demonstration purpose.
>> +
>
> That should depend on mount namespaces as well.
>

Which it already does, since there seems to be no switch for it.
duh

