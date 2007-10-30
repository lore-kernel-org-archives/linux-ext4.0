From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC/PATCH] ext4: Clear the reservation window correctly with delayed
 allocation.
Date: Tue, 30 Oct 2007 16:31:31 +0530
Message-ID: <47270F0B.8010708@linux.vnet.ibm.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com> <4725BEDC.5090902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55569 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbXJ3LCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2007 07:02:08 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9UB21lU002674
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 22:02:01 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9UB25iX1937504
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 22:02:05 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9UB1mar025330
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 22:01:49 +1100
In-Reply-To: <4725BEDC.5090902@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> 
> 
> Aneesh Kumar K.V wrote:
>> Hi All,
>>
>> I looked at the delalloc and reservation differences that Valerie was 
>> observing.
>> Below is my understanding. I am not sure whether the below will result 
>> in higher fragmentation that Eric Sandeen is observing. I guess it 
>> should not. Even
>> though the reservation gets discarded during the clear inode due to 
>> memory pressure
>> the request for new reservation should get the blocks nearby and not 
>> break extents right ?
>>
>>
>> any how below is the simple case.
>>
>> without delalloc the blocks are requested during 
>> prepare_write/write_begin.
>> That means we enter ext4_new_blocks_old which will call 
>> ext4_try_to_allocate_with_rsv.
>> Now if there is no reservation for this inode a new one will be 
>> allocated.  After
>> using the blocks this reservation is destroyed during the close via 
>> ext4_release_file
>>
>> With delalloc the blocks are not requested until we hit 
>> writeback/ext4_da_writepages
>> That means if we create new file and close them the reservation will 
>> be discarded
>> during close via ext4_release_file.( Actually there will be nothing to 
>> clear)
>> Now when we do a sync/or write back. We try to get the block, the 
>> inode will
>> request for new reservation. This reservation is not discarded untill 
>> we call clear_inode
>> and that results in the behavior we are seeing.
>> Free blocks: 1440-8191, 8194-8199, 8202-8207, 8210-8215, 8218-8223, 
>> 8226-8231, 8234-8239, 8242-8247, 8250-8255, 8258-8263, 8266-8271, 
>> 8274-8279, 8282-8287, 8290-8295, 8298-8303, 8306-8311, 8314-8319, 
>> 8322-8327, 8330-8335, 8338-8343, 8346-12799
>>
>> So now the question is where do we discard the reservation in case of 
>> delalloc.
>>
>> -
> 
> with respect to mballoc we are not seeing this because we are doing
> allocation from group prealloc list which is per cpu.
> For most the case we have EXT4_MB_HINT_GROUP_ALLOC set in mballoc.
> 
> In ext4_mb_group_or_file i already have a FIXME!! regarding this.
> 
> currently we have
> 
>        /* request is so large that we don't care about
>         * streaming - it overweights any possible seek */
>        if (ac->ac_o_ex.fe_len >= sbi->s_mb_large_req)
>                return;
> 
>        /* FIXME!!
>         * is this  >=  considering the above ?
>         */
>        if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)
>                return;
> 
>        .....
>        ......
> 
>       /* we're going to use group allocation */
>        ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
>              ........
>       .........
> 
> So for small size we have the EXT4_MB_HINT_GROUP_ALLOC set . Now if
> i change the the line below FIXME!! to <= , that will force
> small size to use inode prealloc and that cause
> 
> Free blocks: 1442-1443, 1446-1447, 1450-1451, 1454-1455, 1458-1459, 
> 1462-1463, 1466-1467, 1470-1471, 1474-1475, 1478-1479, 1482-1483, 
> 1486-1487, 1490-1491, 1494-1495, 1498-1499, 1502-1503, 1506-1507, 
> 1510-1511, 1514-1515, 1518-12799
> 
> 
> So the problem is generic.
> 

the below patch give ok results with nomballoc. 


allocate new block: goal 8192, found 8192/2
allocate new block: goal 8192, found 8194/2
allocate new block: goal 8192, found 8196/2
allocate new block: goal 8192, found 8198/2
allocate new block: goal 8192, found 8200/2
allocate new block: goal 8192, found 8202/2
allocate new block: goal 8192, found 8204/2
allocate new block: goal 8192, found 8206/2
allocate new block: goal 8192, found 8208/2
allocate new block: goal 8192, found 8210/2
allocate new block: goal 8192, found 8212/2
allocate new block: goal 8192, found 8214/2
allocate new block: goal 8192, found 8216/2
allocate new block: goal 8192, found 8218/2
allocate new block: goal 8192, found 8220/2
allocate new block: goal 8192, found 8222/2
allocate new block: goal 8192, found 8224/2
allocate new block: goal 8192, found 8226/2
allocate new block: goal 8192, found 8228/2
allocate new block: goal 8192, found 8230/2



diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ac4d032..a3a7205 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1410,7 +1410,14 @@ out:
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
-	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+	int retval;
+	retval = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+	if (!retval) {
+		/* if writepages is successfull discard the reservation */
+		ext4_discard_reservation(mapping->host);
+	}
+
+	return retval;
 }
 
 static void ext4_da_invalidatepage(struct page *page, unsigned long offset)


-aneesh
