From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Fri, 08 Feb 2008 09:33:54 -0600
Message-ID: <47AC7662.8000706@redhat.com>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker> <20080208150705.GA9111@alice> <47AC7492.1050907@redhat.com> <20080208153135.GB9111@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbYBHPhG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 10:37:06 -0500
In-Reply-To: <20080208153135.GB9111@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sesterhenn wrote:
> * Eric Sandeen (sandeen@redhat.com) wrote:
>> Eric Sesterhenn wrote:
>>>> Eric ,
>>>> can you run the test with below patch and see if this makes any
>>>> difference ?. I know we are not fixing any bugs in the below patch.
>>> ok, i checked out the old version again and applied both patches,
>>> the BUG is gone (no surprise)
>>> In the case where it would have hit the BUG i now get the following message:
>>>
>>> [  740.400288] Aborting journal on device loop0.
>> No message before that about *why* it aborted?
> 
> assumed the stuff was from the previous runs
> 

> [  735.424574] EXT4-fs error (device loop0): ext4_mb_generate_buddy:
> EXT4-fs: group 0: 6590 blocks in bitmap, 6600 in gd
> [  740.400288] Aborting journal on device loop0.

There it is, thanks.  Just making sure :)

-Eric
