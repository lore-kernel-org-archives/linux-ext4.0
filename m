From: Chao Yu <chao@kernel.org>
Subject: Re: mbcache: fix to detect failure of register_shrinker
Date: Wed, 31 Aug 2016 23:31:17 +0800
Message-ID: <c0b249e8-8bc6-cfdb-8ee5-3d0b4618f84e@kernel.org>
References: <1463411798-2597-1-git-send-email-chao@kernel.org>
 <20160705201625.GA18568@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160705201625.GA18568@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2016/7/6 4:16, Theodore Ts'o wrote:
> On Mon, May 16, 2016 at 11:16:38PM +0800, Chao Yu wrote:
>> From: Chao Yu <yuchao0@huawei.com>
>>
>> register_shrinker in mb_cache_create may fail due to no memory. This
>> patch fixes to do the check of return value of register_shrinker and
>> handle the error case, otherwise mb_cache_create may return with no
>> error, but losing the inner shrinker.
>>
>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Applied, thanks.  (Apologies for the delay; this patch slipped through
> the cracks.)

Ping, didn't see it in mainline, is this patch still under testing now?

> 
> 					- Ted
> 
