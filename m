From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix spare warnings
Date: Fri, 21 Sep 2007 14:34:14 +0530
Message-ID: <46F3890E.4020004@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <11903523092904-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <661de9470709202302l8f2352dt77541d24793a7d23@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57534 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXIUJEo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 05:04:44 -0400
In-Reply-To: <661de9470709202302l8f2352dt77541d24793a7d23@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Balbir Singh wrote:
> Aneesh,
> 
> The subject is a bit confusing,  I presume you mean sparse warnings


yes. I will send an updated patch. The group descriptor bg_flags -> le16 conversion
should actually go with the uninitialized block group patch. 

-aneesh.
