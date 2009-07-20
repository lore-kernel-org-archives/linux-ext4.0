From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 10:32:48 -0400
Message-ID: <4A648010.5070006@redhat.com>
References: <4A63DB89.2060306@redhat.com> <20090720141853.GE25193@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40206 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZGTOdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 10:33:44 -0400
In-Reply-To: <20090720141853.GE25193@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/20/2009 10:18 AM, Chris Mason wrote:
> On Sun, Jul 19, 2009 at 10:50:49PM -0400, Ric Wheeler wrote:
>    
>> Now that we have put some some distance between us and the mega-thread, I
>> think that it is time to put some sanity back into the ext3 journal mode
>> options.
>>
>> My preference is to revert the default back to ordered mode or (if Chris
>> is ready) back to guarded mode.
>>      
>
> My plan was to get guarded into .30, but that clearly didn't happen.
> So, I'll resend this week and try to have it ready for .31, unless
> people would rather avoid the changes to the tried and true ext3.
>
> -chris
>    

I have been thinking that guarded mode might make for a full replacement 
for writeback mode over time - the more I think about writeback mode, 
the less I like letting casual users hurt themselves with it.

I would be very happy to see guarded mode get resent :-)

Any idea how many distros actually ship today with writeback mode as 
their default?

ric

