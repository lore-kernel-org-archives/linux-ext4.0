From: yangsheng <sheng.yang@oracle.com>
Subject: Re: [PATCH resend]  jbd2_stats_proc_init wrong place.
Date: Wed, 17 Nov 2010 16:17:42 +0800
Message-ID: <4CE38FA6.2020907@oracle.com>
References: <1289892704-27147-1-git-send-email-sheng.yang@oracle.com> <20101116210107.GB1568@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, andreas.dilger@oracle.com,
	linux-fsdevel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:48500 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568Ab0KQITd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Nov 2010 03:19:33 -0500
In-Reply-To: <20101116210107.GB1568@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/17/2010 05:01 AM, Ted Ts'o wrote:
> On Tue, Nov 16, 2010 at 03:31:44PM +0800, yangsheng wrote:
>    
>>   The jbd2_stats_proc_init() was placed on wrong location in
>>   jbd2_journal_init_dev().  This may cause /proc/fs/jdb2/<dev>/*
>>   cannot be created when using external journal device.
>>
>>   Reviewed-by: Andreas Dilger<andreas.dilger@oracle.com>
>>      
> Hi Yang Sheng --- you didn't add a Signed-off-by line.  Can you
> confirm that it was your intention to add a:
>
> Signed-off-by: yangsheng<sheng.yang@oracle.com>
>
> ... per the "Developer's Certificate of Origin 1.1" as found in
> /usr/src/linux/Documentation/SubmittingPatches?
>    
Sure, you are right. I am forgot to add this line. Could you
please add it directly or i resent with this line? TIA.

Thanks
YangSheng

