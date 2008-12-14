From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 12224] journal activity on inactive partition causes inactive
 harddrive spinup
Date: Sun, 14 Dec 2008 17:10:20 -0600
Message-ID: <4945925C.8010606@redhat.com>
References: <20081214223001.9E693108047@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYLNXKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 18:10:54 -0500
In-Reply-To: <20081214223001.9E693108047@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bugme-daemon@bugzilla.kernel.org wrote:

> OK, that's a huge mess because bugzilla went and wordwrapped it.  Let
> me fix it:
> 
>> Dec   9 11:15:32 localhost logger:    8,0      0            1       0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312
>> Dec   9 11:15:32 localhost logger:    8,0      0            2       0.000006705   1109   Q   WS 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            3       0.000043581   1109   G   WS 14375 + 8 [kjournald] 
>> Dec   9 11:15:32 localhost logger:    8,0      0            4       0.000065651   1109   P    N [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            5       0.000076267   1109   I    W 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            6       0.000300318   1109   D    W 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            7       0.000423518   1109   U    N [kjournald] 1
>> Dec   9 11:15:32 localhost logger:    8,0      0            8       0.010028373      3   C    W 14375 + 8 [0]
>> Dec   9 11:15:35 localhost logger:    8,0      0            9       3.219049689   1109   A   WS 14383 + 8 <- (8,1) 14320
>> Dec   9 11:15:35 localhost logger:    8,0      0           10       3.219058350   1109   Q   WS 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           11       3.219095505   1109   G   WS 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           12       3.219115061   1109   P    N [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           13       3.219127074   1109   I    W 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           14       3.219344699   1109   D    W 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           15       3.219543607   1109   U    N [kjournald] 1
>> Dec   9 11:15:35 localhost logger:    8,0      0           16       3.229477275       3   C    W 14383 + 8 [0]
> 
> I'm not familar with btrace.  What are we looking at here?

Andrew, it's blktrace/blkparse output, basically.  blkparse(1) manpage
has the details.

maj,min cpu  seq  time           pid   act rwbs off+len
8,0      0    1   0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312

... etc

I'm not sure it gives us enough info; all we see is that there was an IO
on sdb (from sdb1)

I might suggest

# sysctl -w vm.block_dump=1

to see if you get any info about inodes on sda1 being dirtied.

(Also, I didn't see any info about sda1 in the posted fstab...)

-Eric


