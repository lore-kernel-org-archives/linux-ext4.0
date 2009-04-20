From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: e2fsck -y says "yes" to "Abort?"
Date: Mon, 20 Apr 2009 14:29:28 -0400
Message-ID: <49ECBF08.6030806@redhat.com>
References: <49E9DF6A.1090000@redhat.com> <20090418161710.GF19186@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZDTS3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 14:29:35 -0400
In-Reply-To: <20090418161710.GF19186@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, Apr 18, 2009 at 09:10:50AM -0500, Eric Sandeen wrote:
>   
>> I've got this bug filed against Fedora:
>>
>> sh-3.2# e2fsck -y /dev/VolGroup00/VolVol02
>> e2fsck 1.41.3 (12-Oct-2008)
>> The filesystem size (according to the superblock) is 14090240 blocks
>> The physical size of the device is 8847360 blocks
>> Either the superblock or the partition table is likely to be corrupt!
>>
>> Abort? yes
>>
>> I'm reluctant to invert the logic of the Abort? question as suggested
>> ("Are you sure you want to continue?") because this is a significant
>> enough problem that we probably should really pause for consideration.
>>
>> But it seems like perhaps stopping at "Abort?", allowing the user to say
>> "n" to that and then let the "-y" flag take over from there would be
>> reasonable.
>>
>> If this sounds ok I'll whip up a patch, something like a way to flag the
>> really serious questions (?) as unaffected by -y.
>>     
>
> Seems reasonable to me; we'll have to update the documentation to
> explain that -y really doesn't mean yes to _all_ questions, but that
> seems like the best approach.
>
> 					- Ted
> --
>   

The only down side is when you try to automate this (say in an 
appliance) and you don't have a human reading the output. In this case, 
you might just want to invert the logic but in general, it does seem 
dangerous to invert the logic for a long standing option,

Ric

