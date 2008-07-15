From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: suspiciously good fsck times?
Date: Mon, 14 Jul 2008 20:47:59 -0400
Message-ID: <487BF3BF.9040608@redhat.com>
References: <20080710172829.GF10402@mit.edu> <20080710175354.GA3447@mit.edu> <48766D71.7050100@gmail.com> <20080714211913.GQ6239@webber.adilger.int>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbYGOAsN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 20:48:13 -0400
In-Reply-To: <20080714211913.GQ6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 10, 2008  16:13 -0400, Ric Wheeler wrote:
>   
>> It would be interesting to rerun with the 46 million files in one  
>> directory as well (basically, for working sets that have no natural  
>> mapping into directories like some object based workloads).
>>     
>
> I think you'll hit a limit around 15M files in a single directory.
>
> Cheers, Andreas
> --
>   
Probably still worth a quick test, just to see how well it holds up at 
the edge, thanks!

ric

