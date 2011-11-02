From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/7] ext4: cleanups and regression fixes for grow/shrink
 logic V3
Date: Wed, 02 Nov 2011 16:12:24 -0700
Message-ID: <4EB1CE58.9070200@linux.vnet.ibm.com>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48176 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1KBXNG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 19:13:06 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 2 Nov 2011 17:13:03 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pA2NCsYR145280
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 17:12:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pA2NCrRO026027
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 17:12:54 -0600
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/28/2011 10:00 AM, Dmitry Monakhov wrote:
> changes from v2 (in responce to comments from tytso@)
>   - split punch_hole handler patch in to reviewable peaces.
>   - redesign error path for ext4_ext_map_blocks
>
> ##First patch is a fix for real issue
>   ext4: Restore old EOFBLOCKS flag state after error
> ##Code cleanup for shrink logic.
>   ext4: move inode indepth shrink logic to didicated function
> ##The rest are punch hole logic fixes
>   ext4: Move punch hole logic to didicated function
>   ext4: punch_hole fix extent conversion
>   ext4: Update inode's transaction id after punch_hole
>   ext4: punch hole should be restarted after transaction restart
>   ext4: update EOFBLOCK flags after punch hole

Hi Dmitry,

I went through this set, and I think it looks good.  I didnt catch 
anything that hasnt already been explained in earlier versions, and I 
think it looks cleaner now.  Thx!

Allison Henderson

