From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Thu, 29 Oct 2009 17:52:34 -0400
Message-ID: <f7848160910291452g58c9b6ecwd3c8671cd87b012b@mail.gmail.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
	 <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
	 <20091029214241.GH18464@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	Parag Warudkar <parag.lkml@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57345 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZJ2Vwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:52:30 -0400
In-Reply-To: <20091029214241.GH18464@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 29, 2009 at 5:42 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 05:25:17PM -0400, Parag Warudkar wrote:
>> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> > Date: =A0 Tue Oct 27 15:36:38 2009 +0530
>> >
>> > =A0 =A0ext4: discard preallocation during truncate
>> >
>> Just wanted to let you know that I have applied this patch and one
>> unclean shutdown later it seems to have not given me any trouble.
>>
>> I will continue testing it - hopefully I won't have to reformat =A0t=
his
>> time ( every time I tested previously I ended up having weird issues
>> that I decided to get rid of by reformatting /).
>
> Cool!
>
> It looked like Avery Fisher had reported that had had tried patch
> didn't help him, and so I had put it in the category of "good patch,
> makes sense, but probably not the one that would solve this
> regression". =A0But if it works for you, I'll accelerate getting it t=
o
> Linus. =A0Do let us know if you have any additional problems with thi=
s
> patch, please!
>

I have gone through 3 unclean shutdowns so far - this time on Ubuntu
Karmic Release, today's -git and this patch.
Nothing odd to report.

[ Goes and crashes it again - comes back clean! ]

Since literally all of my previous attempts always resulted in
problems - something seems to have improved although there is no way
to tell if this is going to last long or that if it was Aneesh's patch
alone that improved things as last time i tried this I ended up
reinstalling and I switched to Karmic from Jaunty and I did not test
mainline for few days.

Any rate, I will let everyone know if I see anything different.

Thanks
Parag
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
