From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: fix ext34_fill_super group description initialization
Date: Mon, 13 Aug 2007 14:50:52 +0530
Message-ID: <46C02274.7060600@linux.vnet.ibm.com>
References: <20070813090954.GA25226@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	devel@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38289 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968193AbXHMJ1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 05:27:45 -0400
In-Reply-To: <20070813090954.GA25226@dnb.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Dmitry Monakhov wrote:
> ->s_group_desc have to be zero filled because if sb_read() failed
> we jump to following error path.
> failed_mount2:
> 	for (i = 0; i < db_count; i++)
> 		brelse(sbi->s_group_desc[i]);<< Bad things may happen here
> 


But the db_count is updated in the failure path to point to the number
of successful sb_read. 

-aneesh
