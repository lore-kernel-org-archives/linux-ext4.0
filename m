From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsck -y says "yes" to "Abort?"
Date: Mon, 20 Apr 2009 14:47:04 -0600
Message-ID: <20090420204704.GG3209@webber.adilger.int>
References: <49E9DF6A.1090000@redhat.com> <20090418161710.GF19186@mit.edu>
 <49ECBF08.6030806@redhat.com> <49ECBFFB.2050004@redhat.com>
 <49ECC12B.5090602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56213 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZDTUrR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 16:47:17 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3KKlHVK004357
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 13:47:17 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIF0010032GRP00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Apr 2009 13:47:17 -0700 (PDT)
In-reply-to: <49ECC12B.5090602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 20, 2009  14:38 -0400, Ric Wheeler wrote:
> Eric Sandeen wrote:
>> Ric Wheeler wrote:
>>> The only down side is when you try to automate this (say in an  
>>> appliance) and you don't have a human reading the output. In this 
>>> case, you might just want to invert the logic but in general, it does 
>>> seem dangerous to invert the logic for a long standing option,
>>
>> Maybe make something like "-yy" automatically answer "n" to anything
>> that would stop the fsck, and answer "y" to anything that it proposes
>> fixing?
>   
> That would be useful for scripting users - it is already assumed to be  
> wildly dangerous to run it in "yes" mode I would assume in any case :-)

Well, all of the questions are designed to choose a safe option when
run with "-y", and to avoid changing the filesystem when run with "-n".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

