From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc and reservation.
Date: Mon, 29 Oct 2007 18:14:46 +0300
Message-ID: <4725F8E6.2050500@gmail.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_NLh/US6UfaIxU5KzxhHFeg)"
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:65370 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXJ2O0i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 10:26:38 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id l9TEFWxS020910
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 14:15:32 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQO00801DSJFQ00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Mon,
 29 Oct 2007 14:15:32 +0000 (GMT)
In-reply-to: <4725AF5B.1000300@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_NLh/US6UfaIxU5KzxhHFeg)
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT

Hi,

could you try the patch attached. it should fix the issue. the idea
was to align requests in order to help raid5-like setups. but somewhere
I lost one bit in mballoc: it should pre-allocate all crossed stripes,
but it didn't.

as for discard, lustre doesn't use open/close for data, so discard-on-close
makes zero sense in our case. I'm not very positive whether we need to
drop preallocation on file close in case of delayed allocation as writeback
can be started while file is open and finish after close(2).

thanks, Alex


Aneesh Kumar K.V wrote:
> Hi All,
> 
> I looked at the delalloc and reservation differences that Valerie was 
> observing.
> Below is my understanding. I am not sure whether the below will result 
> in higher fragmentation that Eric Sandeen is observing. I guess it 
> should not. Even
> though the reservation gets discarded during the clear inode due to 
> memory pressure
> the request for new reservation should get the blocks nearby and not 
> break extents right ?
> 
> 
> any how below is the simple case.
> 
> without delalloc the blocks are requested during prepare_write/write_begin.
> That means we enter ext4_new_blocks_old which will call 
> ext4_try_to_allocate_with_rsv.
> Now if there is no reservation for this inode a new one will be 
> allocated.  After
> using the blocks this reservation is destroyed during the close via 
> ext4_release_file
> 
> With delalloc the blocks are not requested until we hit 
> writeback/ext4_da_writepages
> That means if we create new file and close them the reservation will be 
> discarded
> during close via ext4_release_file.( Actually there will be nothing to 
> clear)
> Now when we do a sync/or write back. We try to get the block, the inode 
> will
> request for new reservation. This reservation is not discarded untill we 
> call clear_inode
> and that results in the behavior we are seeing.
> Free blocks: 1440-8191, 8194-8199, 8202-8207, 8210-8215, 8218-8223, 
> 8226-8231, 8234-8239, 8242-8247, 8250-8255, 8258-8263, 8266-8271, 
> 8274-8279, 8282-8287, 8290-8295, 8298-8303, 8306-8311, 8314-8319, 
> 8322-8327, 8330-8335, 8338-8343, 8346-12799
> 
> So now the question is where do we discard the reservation in case of 
> delalloc.
> 
> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--Boundary_(ID_NLh/US6UfaIxU5KzxhHFeg)
Content-type: text/x-patch; name=mballoc-debug.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=mballoc-debug.patch

Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-10-27 10:29:17.000000000 +0400
+++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-10-27 22:14:54.000000000 +0400
@@ -3088,8 +3088,10 @@ static void ext4_mb_normalize_request(st
 			break;
 		}
 	}
+	size = wind;
+
 	if (wind == 0) {
-		__u64 tstart;
+		__u64 tstart, tend;
 		/* file is quite large, we now preallocate with
 		 * the biggest configured window with regart to
 		 * logical offset */
@@ -3097,8 +3099,11 @@ static void ext4_mb_normalize_request(st
 		tstart = ac->ac_o_ex.fe_logical;
 		do_div(tstart, wind);
 		start = tstart * wind;
+		tend = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len - 1;
+		do_div(tend, wind);
+		tend = tend * wind + wind;
+		size = tend - start;
 	}
-	size = wind;
 	orig_size = size;
 	orig_start = start;
 

--Boundary_(ID_NLh/US6UfaIxU5KzxhHFeg)--
