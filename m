From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: let getattr report the right blocks in delalloc+bigalloc.
Date: Thu, 31 May 2012 22:52:33 -0500
Message-ID: <4FC83C81.5090001@redhat.com>
References: <1328025496-3521-1-git-send-email-tm@tao.ma> <4FC7A5A2.1080704@redhat.com> <20120601004348.GB7897@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab2FADwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 23:52:38 -0400
In-Reply-To: <20120601004348.GB7897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/31/12 7:43 PM, Ted Ts'o wrote:
> On Thu, May 31, 2012 at 12:08:50PM -0500, Eric Sandeen wrote:
>> On 1/31/12 9:58 AM, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In delayed allocation, i_reserved_data_blocks now indicates
>>> clusters, not blocks. So report it in the right number.
>>>
>>> This can be easily exposed by the following command:
>>> echo foo > blah; du -hc blah; sync; du -hc blah
>>>
>>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>>> Reported-by: Eric Sandeen <sandeen@redhat.com>
>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>
>> Reviewed-by: Eric Sandeen <sandeen2redhat.com>
>>
>> It'd be great to get this one merged.
> 
> I'll merge this, but delalloc and bigalloc is still pretty badly
> busted.  But this will make stat return something that is closer to
> being correct...

Hm what else is busted?  Is there a testcase written?

How much else do you know of that's busted with bigalloc?  :)

(Is this bustedness the reason for not yet having it in the man page?)

-Eric
 
> 						- Ted

