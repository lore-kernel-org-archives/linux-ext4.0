From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Thu, 06 Nov 2008 07:45:38 -0500
Message-ID: <4912E6F2.6010705@redhat.com>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081105231012.GJ3184@webber.adilger.int> <20081106002727.GB8168@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Josef Bacik <jbacik@redhat.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYKFMqC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Nov 2008 07:46:02 -0500
In-Reply-To: <20081106002727.GB8168@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Nov 05, 2008 at 04:10:12PM -0700, Andreas Dilger wrote:
>   
>> There was no reply to my previous comments about making the maximum sleep
>> time be a fixed value (e.g. 15ms) instead of having it arbitrarily based
>> on the jiffies value, which may change between 1ms and 10ms.
>>     
>
> I know the whole point is to make it be self-tuning, but I wonder if
> we should have some knobs to control the min and max sleep times.
>
>    	          	       	    	     	     - Ted
>   

I think that it could be useful to have a tunable knob for the max sleep 
time. It would certainly be capped at a much lower level for a RAM disk 
than it would be for a very large RAID volume...

Ric

