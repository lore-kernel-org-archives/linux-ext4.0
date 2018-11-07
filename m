Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:37392 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731485AbeKHCtg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 21:49:36 -0500
Subject: Re: [PATCH 1/7] ext4: lost brelse in __ext4_read_dirblock()
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <60f19df8-1e65-99a0-cb6b-696d1b530fd4@virtuozzo.com>
 <20181107152549.GB9919@thunk.org>
From: Vasily Averin <vvs@virtuozzo.com>
Message-ID: <6e5c9e17-5916-7296-35a0-cc0600a79f27@virtuozzo.com>
Date: Wed, 7 Nov 2018 20:18:13 +0300
MIME-Version: 1.0
In-Reply-To: <20181107152549.GB9919@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was wrong here, but brelse is lost in next error in this function.
I'll resend new patch.

On 11/7/18 6:25 PM, Theodore Y. Ts'o wrote:
> On Wed, Oct 31, 2018 at 10:12:18PM +0300, Vasily Averin wrote:
>> Fixes dc6982ff4db1 ("ext4: refactor code to read directory blocks ...") # 3.9
>>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  fs/ext4/namei.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index d388cce72db2..1a21e59ede72 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -111,6 +111,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
>>  	if (!bh) {
>>  		ext4_error_inode(inode, func, line, block,
>>  				 "Directory hole found");
>> +		brelse(bh);
>>  		return ERR_PTR(-EFSCORRUPTED);
>>  	}
>>  	dirent = (struct ext4_dir_entry *) bh->b_data;
> 
> Inside the conditional, bh == NULL, so the brelse isn't needed.
> 
> Cheers,
> 
> 						- Ted
> 
