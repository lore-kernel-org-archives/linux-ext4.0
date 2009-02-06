From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 06 Feb 2009 09:23:34 -0600
Message-ID: <498C55F6.7070103@redhat.com>
References: <p06240517c5b14e12f7d1@[10.1.5.33]> <498BB63D.50503@redhat.com> <p06240522c5b1d7426151@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41719 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZBFPZi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 10:25:38 -0500
In-Reply-To: <p06240522c5b1d7426151@[10.1.5.33]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J.D. Bakker wrote:
> At 22:02 -0600 05-02-2009, Eric Sandeen wrote:
>> J.D. Bakker wrote:
>>  >    Error writing block 1 (Attempt to write block from filesystem
>>>  resulted in short write).  Ignore error? no
>>>     Error writing block 2 (Attempt to write block from filesystem
>>>  resulted in short write).  Ignore error? no
>>>     Error writing block 3 (Attempt to write block from filesystem
>>>  resulted in short write).  Ignore error? no
>>>     [...]
>>>     Error writing block 231 (Attempt to write block from filesystem
>>>  resulted in short write).  Ignore error? no
>>>     Error writing block 232 (Attempt to write block from filesystem
>>>  resulted in short write).  Ignore error? no
>>>
>>>  (full log at http://lartmaker.nl/ext4/e2fsck-md0.txt)
>> Those seem a bit odd; why are these write failing?  Anything in the
>> kernel logs when this happens?  I'm just wondering if there could be
>> some underlying storage problem?
> 
> No, nothing in the logs.
> 
> Isn't this a side-effect of me passing the -n option to e2fsck? I 
> haven't traced the full path in the e2fsprogs-source, but it would 
> appear that the -n option sets E2F_OPT_NO, which sets 
> E2F_OPT_READONLY, which clears EXT2_FLAG_RW, which (in a few places) 
> clears IO_FLAG_RW, which appears to open the fs RO (as expected).

oh, perhaps.  I'll have to look more closely; I'd hope (I thought...)
that running it in test mode wouldn't issue such dire error messages :)

-Eric
