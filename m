From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: finding the author of the patches in ext4-patch-queue
Date: Tue, 03 Jul 2007 23:27:29 -0400
Message-ID: <1183519649.3922.1.camel@localhost.localdomain>
References: <468B2AF5.5060207@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56030 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXGDG1a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 02:27:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l646RUpV027292
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 02:27:30 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l646RTOO218786
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 00:27:29 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l646RTZO003830
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 00:27:29 -0600
In-Reply-To: <468B2AF5.5060207@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-04 at 10:37 +0530, Aneesh Kumar K.V wrote:
> Hi Mingming,
> 
> With respect to ext4-patch-queue it is kind of difficult to find who wrote the patch.
> I guess we can solve this by adding From: < author name > in the patches. This will make sure
> when the patches get applied to linus tree we have the right author.
> 

Thanks, Aneesh, I will add From: <authro> for all patches in ext4 patch
queue.

Mingming
> with the below diff to noextent_mount option patch i get the below history when applying the patches
> using stgit via stgit --import --series 
> 
> 
> diff --git a/ext4_noextent_mount_opt.patch b/ext4_noextent_mount_opt.patch
> index c349afb..e9a8d6f 100644
> --- a/ext4_noextent_mount_opt.patch
> +++ b/ext4_noextent_mount_opt.patch
> @@ -1,3 +1,4 @@
> +From: Mingming Cao <cmm@us.ibm.com>
>  Add a mount option to turn off extents.
> 
>  Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> $ git log 
> commit f89bcb4ca03dde8b12d3c722483aae84c3d2072d
> Author: Mingming Cao <cmm@us.ibm.com>
> Date:   Wed Jul 4 10:32:19 2007 +0530
> 
>     Add a mount option to turn off extents.
>     
>     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> Without the change: I get below
> 
> commit 4a4f228f99e263767fe5b395cdb843a5c5d083fe
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Wed Jul 4 10:05:19 2007 +0530
> 
>     Turn on extents feature by default in ext4 filesystem. User could use
>     -o noextents to turn it off.
>     
>     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> 
> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
