From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 12:07:22 -0400
Message-ID: <4830543A.1000804@gmail.com>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu>	<20080516173552.e88183d9.akpm@linux-foundation.org>	<200805172048.34455.chris.mason@oracle.com>	<20080518013641.GH16496@mit.edu>	<4830420D.4080608__28835.4277647615$1211137279$gmane$org@gmail.com> <87abincrir.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-ker@firstfloor.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:27427 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbYERUH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 May 2008 16:07:29 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1313758wxd.4
        for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 13:07:26 -0700 (PDT)
In-Reply-To: <87abincrir.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi Kleen wrote:
> Ric Wheeler <ricwheeler@gmail.com> writes:
>   
>> The hard thing is to figure out how to test this kind of scenario
>> without dropping power. To expose the failure mode, it might be
>>     
>
> Why not drop power? (see test scenario in previous mail) 
>
> There are lots of cheap ways available to do that.
> I personally keep my test machines on cheap USB power switches and 
> can switch them any time. 
>
> It will probably lower the MTBF of your test boxes somewhat 
> though, but that's the price for good testing.
>   
The concern, as you mentioned above, is that you wear the equipment out 
with this kind of thing. Power supplies are probably the most impacted ;-)

>   
>> Just a personal note, my last day at EMC was this past Friday. Monday,
>> I start working for Red Hat (focused on file systems) so I will have
>> to figure out to get this kind of test going without all of my big EMC
>> toys ;-)
>>     
>
> Congratulations on the new job. I don't think you need any big toys though.
>
> -Andi
>   
Thanks!

ric

