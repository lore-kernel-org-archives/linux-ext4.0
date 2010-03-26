From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] avoid scanning bitmaps for group preallocation
Date: Fri, 26 Mar 2010 11:58:49 -0600
Message-ID: <4D0B9967-E479-4E87-AC33-472CAF9F0BF3@sun.com>
References: <A2A61325-CB7F-40E0-B9B9-A918135BCBC6@sun.com>
 <87y6hfwf5v.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42037 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0CZR64 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 13:58:56 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2QHwpvl028437
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 10:58:52 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZW00300HIJOQ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 26 Mar 2010 10:58:51 -0700 (PDT)
In-reply-to: <87y6hfwf5v.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-26, at 04:28, Aneesh Kumar K. V wrote:
> On Mon, 22 Mar 2010 16:03:10 -0600, Andreas Dilger <adilger@sun.com>  
> wrote:
>> Here is the patch I mentioned today on the call.  It avoids (or at
>> least reduces) serious latency (10 minutes or more) on a large
>> filesystem (8TB+) on the first write, if the filesystem is nearly
>> full.  The latency is entirely due to seeking to read the block
>> bitmaps, so is considerably less serious on flex_bg formatted
>> filesystems.
>
> @@ -2029,9 +2028,12 @@ repeat:
> +		/* If there's no chance that this group has a better
> +		 * extent, just skip it instead of seeking to read
> +		 * block bitmap from disk. Initially ac_b_ex.fe_len = 0,
> +		 * so this always skips groups with no free space. */
>  		grp = ext4_get_group_info(sb, group);
> -		if (grp->bb_free == 0)
> +		if (grp->bb_free <= ac->ac_b_ex.fe_len)
>  			continue;
>
> I was wondering whether we need to make sure we also use criteria  
> value
> when checking for bb_free. If we are really low on space we may want  
> to
> return what is left right ?. Or does ac_b_ex take care of that ?


ac_b_ex is the best currently ALLOCATED extent, so mballoc wouldn't  
ever select an extent that is smaller than ac_b_ex.fe_len.  That means  
it is pointless to even look at a group which has fewer free blocks  
than ac_b_ex.fe_len.

Later, after the group information is loaded, ldiskfs_mb_good_group()  
will skip the group if the average fragment size is smaller than the  
GOAL extent, but only for certain criterion levels.  At the highest  
criterion, any group with free blocks will be scanned.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

