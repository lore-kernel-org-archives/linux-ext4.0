From: Andreas Dilger <adilger@sun.com>
Subject: Re: norecovery option for ext3
Date: Fri, 20 Nov 2009 09:41:02 -0800
Message-ID: <745F9F90-6F43-4DA1-92B7-0AC09E07981C@sun.com>
References: <20091120122403.GD15422@duck.suse.cz> <4B06B9CA.1030502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52386 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZKTRk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2009 12:40:59 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAKHf5hD000188
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2009 09:41:05 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTF00A004FOS800@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 20 Nov 2009 09:41:05 -0800 (PST)
In-reply-to: <4B06B9CA.1030502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-20, at 07:46, Eric Sandeen wrote:
> Jan Kara wrote:
>>  I've tried to test noload/norecovery option of ext3 and I've found  
>> it simply does not work. The filesystem does not even mount.

>>  Given that nobody used the option (OK, some googling shows that  
>> somebody tried to use it in *2.4.9* kernel and it didn't work even  
>> there - Stephen Tweedie comments that it's an obsolete option meant  
>> for use during fs development) and seeing how badly corrupted the  
>> filesystem is when you don't replay the journal, I'd just remove  
>> the option. Any opinions?
>
> Oh, sigh.  Sorry, didn't actually, er, test it, since I was just  
> adding an alias for the option... bleah.
>
> I think we should fix it; there are cases when you may want to mount  
> that way, I think - for example, otherwise there is no way at all to  
> mounta block device which is marked readonly...


Won't this require implementing "no journal" mode for ext3?  Seems  
like a lot of effort, when ext4 does the same thing (i.e. they could  
just mount the filesystem "-t ext4 -o norecovery" if they really,  
really need to do that).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

