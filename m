From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3 duplicate entries with readdir
Date: Mon, 09 Mar 2009 11:00:21 -0500
Message-ID: <49B53D15.6080003@redhat.com>
References: <20090303200526.GA20236@ub>	<170fa0d20903031254l7070294cwfa45ffdcc63b24d9@mail.gmail.com>	<20090303215122.GB20640@ub> <20090304015713.GJ32284@mit.edu> <87vdqivl66.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	"Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
	Mike Snitzer <snitzer@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZCIQAh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 12:00:37 -0400
In-Reply-To: <87vdqivl66.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Goswin von Brederlow wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
>> On Tue, Mar 03, 2009 at 10:51:26PM +0100, Andries E. Brouwer wrote:
>>>> Yes, it has been fixed, please see the following git commits:
>>>>
>>>> 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d
>>>> 8c9fa93d51123c5540762b1a9e1919d6f9c4af7c
>>> [On another machine, Ubuntu with 2.6.27-7-server still fails:
>>> % ../readdirtest
>>> expected 61005 files, but readdir reports 61006
>>> % rm *
>>> rm: cannot remove `59992': No such file or directory
>>> (where the same name occurs twice in the expansion of *).]
>> The patches were backported to 2.6.27 stable in 2.6.27.8.  So the
>> problem would expected to be still present in an 2.6.27.7 kernel.
>>
>> 	      	       	     	   	   - Ted
> 
> Does the bug also affect xfs? Because I see the problem there.

Completely different, and the wrong list for the question, really.

Please point me to the bug you filed for this problem on xfs, I'll look
into it (and when you do so please cc: the xfs list, and trim off the
current ext4-related recipients)

Thanks,

-Eric
