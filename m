From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: e2fsck -y says "yes" to "Abort?"
Date: Mon, 20 Apr 2009 14:38:35 -0400
Message-ID: <49ECC12B.5090602@redhat.com>
References: <49E9DF6A.1090000@redhat.com> <20090418161710.GF19186@mit.edu> <49ECBF08.6030806@redhat.com> <49ECBFFB.2050004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35037 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbZDTSij (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 14:38:39 -0400
In-Reply-To: <49ECBFFB.2050004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Ric Wheeler wrote:
>
>   
>> The only down side is when you try to automate this (say in an 
>> appliance) and you don't have a human reading the output. In this case, 
>> you might just want to invert the logic but in general, it does seem 
>> dangerous to invert the logic for a long standing option,
>>
>> Ric
>>
>>     
>
> Maybe make something like "-yy" automatically answer "n" to anything
> that would stop the fsck, and answer "y" to anything that it proposes
> fixing?
>
> -Eric
>   
That would be useful for scripting users - it is already assumed to be 
wildly dangerous to run it in "yes" mode I would assume in any case :-)

ric

