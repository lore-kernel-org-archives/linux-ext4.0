From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Fri, 30 Oct 2009 13:56:27 -0600
Message-ID: <3D6E88E0-7271-4CEC-85DC-9E4416F030F5@sun.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
 <20091016091558.GA10184@mit.edu>
 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
 <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
 <4AEA0B71.5050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Parag Warudkar <parag.lkml@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56339 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbZJ3T4f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 15:56:35 -0400
In-reply-to: <4AEA0B71.5050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-10-29, at 15:38, Eric Sandeen wrote:
> Parag Warudkar wrote:
>> On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
>> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>> Can you try this patch ?
>>>
>>> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
>>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>> Date:   Tue Oct 27 15:36:38 2009 +0530
>>>
>>>   ext4: discard preallocation during truncate
>>>
>>>   We need to make sure when we drop and reacquire the inode's
>>>   i_data_sem we discard the inode preallocation. Otherwise we
>>>   could have blocks marked as free in bitmap but still belonging
>>>   to prealloc space.
>> Just wanted to let you know that I have applied this patch and one
>> unclean shutdown later it seems to have not given me any trouble.
>> I will continue testing it - hopefully I won't have to reformat  this
>> time ( every time I tested previously I ended up having weird issues
>> that I decided to get rid of by reformatting /).
>
> I've been running my testcase, and I just hit the usual corruption  
> with this patch in place after 8 iterations, I'm afraid.


I wonder if there are multiple problems involved here?  Eric, it seems
possible that your reproducer is exercising a similar, though unrelated
codepath.  I would agree with Ted that if this patch is solving the
problem for some of the users it is definitely worth landing, even if it
ends up not solving all of the problems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

