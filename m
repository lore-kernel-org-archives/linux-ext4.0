From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: ext4_ext_convert_to_initialized bug found in extended FSX testing
Date: Wed, 11 May 2011 06:58:55 -0700
Message-ID: <4DCA961F.1040407@linux.vnet.ibm.com>
References: <4DC97C32.2020203@linux.vnet.ibm.com> <BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45539 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1EKPom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 11:44:42 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4BDWrE5024639
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 09:32:53 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4BDx6iw081938
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 09:59:06 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4BDx3ch028654
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 09:59:06 -0400
In-Reply-To: <BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/10/2011 6:47 PM, Yongqiang Yang wrote:
> On Wed, May 11, 2011 at 1:56 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> Hi All,
>>
>> We've been trying to get punch hole through some extended fsx tests, and I ran across some other tests that were failing because the test file contained zeros where it shouldn't.  I made this fix to the ext4_ext_convert_to_initialized
>
> What do you mean zeros here?
> Some useful data is zeroed?
>

Resending this note because I didn't see it show up in the mailing list. 
  Maybe a duplicate:

Oh sorry, I phrased that wrong.  The test was failing because it did not 
contain zeros when it should have.  I traced it down to a map write 
operation that was trying to write data in an extent that had been 
created unwritten by a previous fallocate.  The unwritten extent had to 
be split, but the last part of the extent was not zero'd out all the 
way, so it was causing some erroneous data to show up after the region 
that was being written.  This fix appears to correct it though.

Allison Henderson


> and the test has been running smooth for about an hour now.
> Yongqiang, this one looks like it may have been associated with the
> split extents clean up patch.  Would you mind taking a look at this
> fix and giving it your ok if it looks good?  Thx!
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> ---
>> :100644 100644 e363f21... ce69450... M  fs/ext4/extents.c
>>   fs/ext4/extents.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index e363f21..ce69450 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>>                         /* case 3 */
>>                         zero_ex.ee_block =
>>                                          cpu_to_le32(map->m_lblk + map->m_len);
>> -                       zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
>> +                       zero_ex.ee_len = cpu_to_le16(ee_len -
>> +                                               allocated - map->m_len);
> The logic is that we splits [ee_block, ee_block + ee_len) into
> [ee_block, map->m_blk) that is uninitialized and [map->m_blk, ee_block
> + ee_len) that is initialized.   We need to zero [map->m_lblk +
> map->m_len, ee_block + ee_len).
> and [map->m_lblk, map->m_lblk + map->m_len) is zeroed by upper layer
> because of MAP_NEW flag.
>
> Right logic?
>
>
> I can not see the error and the meaning of ee_len - allocated - map->m_len.
>
> Thanks,
> Yongqiang.
>
>
>>                         ext4_ext_store_pblock(&zero_ex,
>>                                 ext4_ext_pblock(ex) + map->m_lblk - ee_block);
>>                         err = ext4_ext_zeroout(inode,&zero_ex);
>> --
>> 1.7.1
>>
>>
>
>
>

