From: dmonakhov@openvz.org
Subject: Re: [PATCH] ext4: fix quota accounting in case of fallocate
Date: Wed, 31 Mar 2010 08:51:27 +0400
Message-ID: <87eij1ccvk.fsf@openvz.org>
References: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
	<87zl1py95b.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:24231 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab0CaEvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Mar 2010 00:51:42 -0400
In-Reply-To: <87zl1py95b.fsf@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message
	of "Tue, 30 Mar 2010 23:38:48 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Tue, 30 Mar 2010 18:24:35 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> allocated_meta_data is already included in 'used' variable.
>> 
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ext4/inode.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index bec222c..bf989fb 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1110,7 +1110,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
>>  		 */
>>  		if (allocated_meta_blocks)
>>  			dquot_claim_block(inode, allocated_meta_blocks);
>> -		dquot_release_reservation_block(inode, mdb_free + used);
>> +		dquot_release_reservation_block(inode, mdb_free + used -
>> +			allocated_meta_blocks);
>>  	}
>> 
>>  	/*
>
> Do we really need to do this ? IIUC reservation count and actual
> allocated count are two different. One block allocation we need to
> remove all the blocks reserved from the reservation count and add
Yes. remove all, but minus already allocated_metadata, which was
accounted in to metadata reservation.
> actually allocated blocks to the allocated count.
Just try an example:
reserve_space (inode, lblock := 1024 ) {
   md_needed = ext4_calc_metadata_amount(inode, lblock) (let it be '2')
   dquot_reserve_block(inode, md_needed + 1) /* '3' i.e blocks  reserved*/
   /* If this is first reservation for this inode then
    dq_rsv = inode->i_reserved_data_blocks + inode->i_reserved_meta_block
   */
}
Later called from fallocate
update_rerved_space(inode, used:=1, claim :=0) {
  /* Let i_allocatd_meta_data is '1' (as it so in most cases)  */
  ei->i_reserved_data_blocks -= used;  /* 1 - 1 => 0 */
  used += ei->i_allocated_meta_blocks; /* 1 + 1 => 2 */
  ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks /* 2 - 1 => 1 */
  allocated_meta_blocks = ei->i_allocated_meta_blocks; /*  1 */
  ei->i_allocated_meta_blocks = 0;

  if (ei->i_reserved_data_blocks == 0) /* True in our case */
     mdb_free = ei->i_reserved_meta_blocks; /* mbd_free == 1*/

  if (allocated_meta_blocks)
         dquot_claim_block(inode, allocated_meta_blocks); /* claim '1' block*/
  dquot_release_reservation_block(inode, mdb_free + used); /* free (1 + 2) */

  /* So we reserved:
     dq_rsv = i_reserved_data_blocks + i_reserved_meta_block ( 3 blocks)
     But during update we claim + free:
          i_allocated_meta_data+(i_reserved_data_block+i_reserved_meta_data)
          (4 blocks).
          Which result in incorrect dquota reservation accounting(it
          goes negative)
  */

Initially i've found the issue by executing fsstress with falloc support.
It takes enouth process to catch writepage/fallocate overlapping.
xfstests-dev/ltp/xfsfsstress -p100 -n99999999

