From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Tue, 03 Jul 2007 12:07:57 +0530
Message-ID: <4689EEC5.4040005@linux.vnet.ibm.com>
References: <1183275416.4010.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:59205 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXGCGiu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2007 02:38:50 -0400
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> This patch is a spinoff of the old nanosecond patches.
> 
> It includes some cleanups and addition of a creation timestamp. The
> EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> s

Should be EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE

-aneesh
