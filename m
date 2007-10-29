From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc and reservation.
Date: Mon, 29 Oct 2007 18:44:56 +0300
Message-ID: <4725FFF8.5060501@gmail.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com> <4725F8E6.2050500@gmail.com>
 <4725EF33.7050804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:33953 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbXJ2Opu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 10:45:50 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id l9TEjmOu025854
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 14:45:48 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQO00A01G4XME00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Mon,
 29 Oct 2007 14:45:47 +0000 (GMT)
In-reply-to: <4725EF33.7050804@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sorry, I don't quite understand how do you observe this with nomballoc

thanks, Alex

Aneesh Kumar K.V wrote:
> mballoc by default doesn't give the particular layout only if i force small
> size to use inode preallocation i am hitting the problem. ie to change the
> below line in ext4_mb_group_or_file
> 
> if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)
> 
> to
> if (ac->ac_o_ex.fe_len <= sbi->s_mb_small_req)
> 
> Do you want to test the patch with this change ?
> 
> We are observing the problem with delalloc and nomballoc.
> 
> 
> -aneesh
> 
