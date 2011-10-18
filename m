From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Check extent overflow with the right range.
Date: Tue, 18 Oct 2011 10:27:32 +0800
Message-ID: <4E9CE414.9040706@tao.ma>
References: <20111017081036.GN30887@longonot.mountain> <1318841128-4540-1-git-send-email-tm@tao.ma> <20111017141605.GA25017@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47948 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757187Ab1JRC1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 22:27:35 -0400
In-Reply-To: <20111017141605.GA25017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 10/17/2011 10:16 PM, Ted Ts'o wrote:
> On Mon, Oct 17, 2011 at 04:45:28PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In 4fd30c033, we move the range check before we change ix to avoid the memory stamp.
>> But actually we should check against the EXT_MAX_INDEX, not EXT_LAST_INDEX.
>>
>> So this patch revert the old patch and adds a new check before we setting ix.
>>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>> Ted, since 4fd30c033 is in your dev branch, I am fine to integrate these 2 patches to one.
> 
> 
> Hi Tao,
> 
> I have integrated this with the the existing patch in dev branch (since
> it isn't in the master branch yet, and hence hasn't been locked down).
> 
> I'm wondering though how you originally ran into this case, though.
> If there is no more room in the tree node, we should have never
> entered ext4_ext_extent_index() in the first place.  Was this a
> theoretical concern or did you actually see this happen.  And if so,
> was it due to a file system corruption, or another bug someplace else.
We have met with some corruption, but not sure whether it is related to
this or not. To be honest, we went through the code and find that this
may be a possible cause. So if you think it could never happen, we are
OK to drop this patch.

Thanks
Tao
