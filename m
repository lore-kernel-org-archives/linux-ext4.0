From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: Add SEEK_DATA/SEEK_HOLE support V2
Date: Wed, 28 Sep 2011 16:02:20 +0800
Message-ID: <4E82D48C.2000603@oracle.com>
References: <4E82BF7B.7000403@oracle.com> <CAGBYx2YzeBvQPEV7uuHmxwZQD+oE+nuF_bd+CZwzm1F0n8o-ZA@mail.gmail.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33315 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1I1ICd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 04:02:33 -0400
In-Reply-To: <CAGBYx2YzeBvQPEV7uuHmxwZQD+oE+nuF_bd+CZwzm1F0n8o-ZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/28/2011 03:21 PM, Yongqiang Yang wrote:

> On Wed, Sep 28, 2011 at 2:32 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
>> Hello all,
>>
>> This is the V2 for add SEEK_DATA/SEEK_HOLE support to ext4.
>> In V1, I copied all the codes regarding fetching delayed-extents out to
>> my seek callback function, it's stupid to duplicate the code blocks.
>>
>> Now the idea is, since the delayed-extents is the main concern to search
>> extents for both fiemap and seek, so IMHO, it's better to consolidate
>> this procedure into a new function(get_delayed_extent() in my patch),
>> and call it in fiemap and seek call-back functions if necessary.  In
>> this way, when yongqiang's delayed-extents tree is ready, we only need
>> to modify the code block at get_delayed_extent() accordingly.
>>
>> In addition, yongqiang has pointed out there might be a deadlock, but
>> per my understood, as the target inode already locked via i_mutex in
>> ext4_llseek() before, this lock can prevent any modification to the
>> file, and we call find_get_pages_tag() when trying to fetch the dirty
>> pages, this function using rcu read lock, it also safe to read.  So I
>> have no idea what's wrong, could anyone please kindly point me out in
>> this case?  I'm definitely a newbie to this list, sorry for my ignorant.
> Ok.  There is no deadlock, fiemap releases i_data_sem before calling
> get_delayed_extent().
> 
> BTW: It seems that there is a bug in fiemap according to code, I am
> not sure which commit introduced it, delayed extents beyond last
> allocated block are ignored.

Hmm... could you show me a bit more detailed info with the test scenario
if convenient? I can help testing, at least 3.1.0-rc2+ is works to me.

Also, upstream coreutils-cp(1) has been well tested for ext4, it could
be used for fiemap tests based on the extent_scan module:
http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/extent-scan.c?h=next&id=b56b53bd70b1f8fa2b5a95d4569bb72a2419b5cd

Thanks,
-Jeff

> 
> Yongqiang.
>>
>> Anyway, I'd like to post the revised for your guys review first.
>> In have split the modification to two patches this time, since I hope to
>> make it looks more convenient for the review purpose.
>>
>> The 1st patch, remove the delayed-extents fetching procedure to a
>> function named as get_delayed_extent(), and modify the
>> ext4_ext_fiemap_cb() accordingly.
>>
>> The 2nd path add the ext4_ext_seek_cb() to implement the
>> SEEK_HOLE/SEEK_DATA stuff based on previous code change.
>>
>> Testing:
>> ========
>> In addition to the test cases mentioned in V1, I also done another tests
>> through sunil's seek test program, please refer to:
>> http://oss.oracle.com/~smushran/seek_data/seek_test.c
>>
>> To ensure the 1st patch does not cause regression issue on fiemap, I
>> have done some tests via cp(1) with fiemap copy support, the sparse file
>> used for this test is produced by:
>> python -c "f=open('./sptest', 'w'); [(f.seek(x) or f.write(str(x))) for
>> x in range(1, 1000000000, 99999)]; f.close()
>>
>>
>> Any feedback are appreciated!
>>
>>
>> Thanks,
>> -Jeff
>>
> 
> 
> 


