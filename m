From: YangSheng <sickamd@gmail.com>
Subject: Re: [PATCH] Update atime from future.
Date: Tue, 04 Jan 2011 00:44:27 +0800
Message-ID: <4D21FCEB.80502@gmail.com>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <1294050468.2429.2.camel@dolmen>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1294050468.2429.2.camel@dolmen>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/03/2011 06:27 PM, Steven Whitehouse wrote:
> Hi,
>
> On Wed, 2010-12-29 at 21:58 +0800, yangsheng wrote:
>    
>> Signed-off-by: sickamd@gmail.com
>> ---
>>   fs/inode.c |    8 +++++++-
>>   1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index da85e56..6c8effd 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>>   		return 1;
>>
>>   	/*
>> -	 * Is the previous atime value older than a day? If yes,
>> +	 * Is the previous atime value in future? If yes,
>> +	 * update atime:
>> +	 */
>> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec)<  0)
>> +		return 1;
>> +	/*
>> +	 * Is the previous atime value old than a day? If yes,
>>   	 * update atime:
>>   	 */
>>   	if ((long)(now.tv_sec - inode->i_atime.tv_sec)>= 24*60*60)
>>      
> I don't think this is a good plan for cluster filesystems, since if the
> times on the nodes are not exactly synchronised (we do highly recommend
> people run ntp or similar) then this might lead to excessive atime
> updating. The current behaviour is to ignore atimes which are in the
> future for exactly this reason,
>    
I agreed in theory.  Anyway, a two-way update may cause shake in some 
case. Like a cluster environment with time gap between cluster members. 
But future atime also is a trouble things i think. Of course, I hope a 
clever patch to fix them all.

Thanks
yangsheng
