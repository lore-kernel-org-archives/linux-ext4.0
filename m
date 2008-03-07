From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 07 Mar 2008 14:41:12 +0100
Message-ID: <47D145F8.3040300@tuxes.nl>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu> <47BECAC0.5010707@tuxes.nl> <20832.81.207.193.3.1203702265.squirrel@guust.tuxes.nl> <47BF0A7B.50902@redhat.com> <20909.81.207.193.3.1203702913.squirrel@guust.tuxes.nl> <47BF0DAC.9080200@redhat.com> <21151.81.207.193.3.1203703570.squirrel@guust.tuxes.nl> <20080222182711.GT20118@mit.edu> <21200.81.207.193.3.1203708673.squirrel@guust.tuxes.nl> <20080222194826.GW20118@mit.edu> <47CAFB3F.2010409@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pollux.sshunet.nl ([145.97.192.42]:33178 "EHLO
	pollux.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYCGNlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 08:41:19 -0500
In-Reply-To: <47CAFB3F.2010409@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bas van Schaik wrote:
> Theodore Tso wrote:
>   
>> On Fri, Feb 22, 2008 at 08:31:13PM +0100, Bas van Schaik wrote:
>>   
>>     
>>>> Yeah, it could be quite big, given that you have a 3TB filesystem.  That's
>>>> why I suggested the "or given me login access to the system", although
>>>> understand there could be all sorts of privacy and security issues
>>>> involved with that request.
>>>>       
>>>>         
>>> The dump is not ready yet...
>>>
>>> Whatever we will do, it will have to wait for a week and a half. For now I
>>> really appreciate all the help.
>>>     
>>>       
>> Ok, when you get back, I should also have a patch for you that will
>> allow the "XXX should never happen" message to display more
>> information, so if the dump is too big for us to move over the
>> network, I'll have another way of doing some remote debugging.
>>   
>>     
> Last night I returned from my holiday trip, so I'm available again. The
> e2image dump completed somewhere during my absence and has grown to 1.6
> gigabytes (bzip2), too large to actually publish if you ask me. I think
> it is okay to provide you access to the system, please contact me
> (preferably using a GPG-encrypted message) so we can agree on the
> details. Of course it would be great if you can send a patch which will
> make e2fsck more verbose.

Hmmm, it is starting to annoy me that I can't get the filesystem to
work... I just tried to restore the ext3 metadata from a LVM snapshot
(taken two weeks ago, before running e2fsck), but that didn't work:
> # e2image /dev/loop1 e2image-pre-e2fsck-snapshot_2008-03-06
> e2image 1.40-WIP (14-Nov-2006)
> # e2image -I /dev/loop2 e2image-pre-e2fsck-snapshot_2008-03-06
> e2image 1.40-WIP (14-Nov-2006)
> e2image-pre-e2fsck-snapshot_2008-03-06: File too large

(note that loop0 is the real filesystem which is messed up and looks
unrecoverable, loop1 is the LVM snapshot I took before doing any attempt
to fix loop0 and loop2 is a LVM snapshot of loop0 which I created a few
hours ago to test e2image on without making things worse)

Why is e2image refusing to restore the metadata, and what does "File too
large" mean?

I think this is pretty much the moment were I can say "HELP!!!"

  -- Bas


