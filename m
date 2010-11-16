From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] ext4: ext4_fill_super shouldn't return 0 on corruption
Date: Tue, 16 Nov 2010 11:43:25 -0600
Message-ID: <4CE2C2BD.1080202@redhat.com>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com> <4CE1AC38.9040201@redhat.com> <20101115230346.GB18195@tux1.beaverton.ibm.com> <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0KPSk7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 13:40:59 -0500
In-Reply-To: <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/16/10 6:56 AM, Lukas Czerner wrote:
> On Mon, 15 Nov 2010, Darrick J. Wong wrote:
> 
>> At the start of ext4_fill_super, ret is set to -EINVAL, and any failure path
>> out of that function returns ret.  However, the generic_check_addressable
>> clause sets ret = 0 (if it passes), which means that a subsequent failure (e.g.
>> a group checksum error) returns 0 even though the mount should fail.  This
>> causes vfs_kern_mount in turn to think that the mount succeeded, leading to an
>> oops.
>>
>> A simple fix is to avoid using ret for the generic_check_addressable check,
>> which was last changed in commit 30ca22c70e3ef0a96ff84de69cd7e8561b416cb2.
>>
>> v2: Return -EFBIG in the error case, per Eric Sandeen's suggestion.
>>
>> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
>> ---
>>
>>  fs/ext4/super.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 40131b7..120c034 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3257,13 +3257,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>  	 * Test whether we have more sectors than will fit in sector_t,
>>  	 * and whether the max offset is addressable by the page cache.
>>  	 */
>> -	ret = generic_check_addressable(sb->s_blocksize_bits,
>> -					ext4_blocks_count(es));
>> -	if (ret) {
>> +	if (generic_check_addressable(sb->s_blocksize_bits,
>> +				      ext4_blocks_count(es))) {
>>  		ext4_msg(sb, KERN_ERR, "filesystem"
>>  			 " too large to mount safely on this system");
>>  		if (sizeof(sector_t) < 8)
>>  			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
>> +		ret = -EFBIG;
>>  		goto failed_mount;
>>  	}
>>  
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> Hi,
> 
> the untested diff below seems like a more general solution to me,
> since it allows to return the actual error from
> generic_check_addressable().
> 
> Thanks.

good point, we can get -EINVAL or -EFBIG back, can't we.

Thanks,
-Eric

> -Lukas
> 
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 61182fe..3d89b72 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3268,13 +3268,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 * Test whether we have more sectors than will fit in sector_t,
>  	 * and whether the max offset is addressable by the page cache.
>  	 */
> -	ret = generic_check_addressable(sb->s_blocksize_bits,
> +	err = generic_check_addressable(sb->s_blocksize_bits,
>  					ext4_blocks_count(es));
> -	if (ret) {
> +	if (err) {
>  		ext4_msg(sb, KERN_ERR, "filesystem"
>  			 " too large to mount safely on this system");
>  		if (sizeof(sector_t) < 8)
>  			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
> +		ret = err;
>  		goto failed_mount;
>  	}
>  

