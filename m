From: Andreas Dilger <adilger@sun.com>
Subject: Re: Bug in extent zeroout: blocks not marked as new
Date: Mon, 23 Nov 2009 14:45:38 -0700
Message-ID: <99269303-4BAF-4977-A19E-EBF5BD7392DF@sun.com>
References: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
 <20091123195049.GD2183@thunk.org>
 <1259011043.25937.29.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36984 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbZKWVpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 16:45:34 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nANLjer1008847
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 13:45:40 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTL00D000EHSJ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 23 Nov 2009 13:45:40 -0800 (PST)
In-reply-to: <1259011043.25937.29.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-23, at 14:17, Frank Mayhar wrote:
> Finally, we have a question about the zero-out path:  Is there any
> known, concrete improvement given by doing the zero-out as opposed  
> to just continuing to split the extents?  At the moment, by the way,  
> there is one definite problem: Since it doesn't try to do a merge  
> left (which it should) it invariably leaves a 14-block extent  
> fragment, thus increasing fragmentation of the file.  It's not a  
> huge problem (since the extents are in fact contiguous) but it's  
> there.


The intent is to avoid splitting the uninitialized extent further when  
there is no longer any benefit to do so.  Writing out 8kB vs. 64kB is  
in the noise these days, but splitting the extent is extra overhead  
(larger extent tree, more lookups, etc).  If we were to continue  
splitting it would leave smaller and smaller uninitialized extents.

As you point out, the newly-initialized extent should be merged with  
its left neighbor.  If we do the zero-out at the point where actually  
writing zeroes is cost effective.  At that point there is no longer an  
uninitialized extent to track, and it can be merged entirely with its  
left neighbor and avoid any extra overhead.

The other time we HAVE to zero out the uninitialized extent is if the  
filesystem does not have any free blocks to add a new extent, so the  
uninitialized extent is zeroed entirely and then converted to  
initialized.

Using 64kB as the cutoff for uninitialized extents is very reasonable  
these days, though we may in fact want to make that dynamic based on  
the superblock s_raid_stripe_width for SSDs with 128kB erase blocks  
and/or avoiding read-modify-write within a single RAID stripe.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

