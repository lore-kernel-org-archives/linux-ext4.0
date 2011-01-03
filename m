From: YangSheng <sickamd@gmail.com>
Subject: Re: [PATCH] Update atime from future.
Date: Mon, 03 Jan 2011 20:54:31 +0800
Message-ID: <4D21C707.3010505@gmail.com>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <20110103021708.d5abf7bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110103021708.d5abf7bd.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/03/2011 06:17 PM, Andrew Morton wrote:
> On Wed, 29 Dec 2010 21:58:41 +0800 yangsheng<sickamd@gmail.com>  wrote:
>
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
> Why do you believe this change is needed?  Did you observe some problem
> which it fixes?  If so, please fully describe that problem.
>    
If atime has been set to future(maybe cause by some accident system time 
adjust or wrong set by touch). It cannot be update to reflect fact 
access time before system time running over one day.

Thanks



