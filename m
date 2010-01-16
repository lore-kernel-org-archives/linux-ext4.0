From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Sat, 16 Jan 2010 00:38:19 -0500
Message-ID: <yq1y6jy7gok.fsf@sermon.lab.mkp.net>
References: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
	<fa7b26051001131613jc61e20fu5e4d0ccee86d6b16@mail.gmail.com>
	<fa7b26051001131658ya96c3b0ieb6010c6fba389c4@mail.gmail.com>
	<4B50AB23.8050300@redhat.com>
	<fa7b26051001151859h188159c5x8e82c46b55c8b389@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Mike Mestnik <cheako@visi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:18234 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0APFjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jan 2010 00:39:31 -0500
In-Reply-To: <fa7b26051001151859h188159c5x8e82c46b55c8b389@mail.gmail.com>
	(Mike Mestnik's message of "Fri, 15 Jan 2010 20:59:38 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Mike" == Mike Mestnik <cheako@visi.com> writes:

>> Recent changes upstream export alignment and optimal IO size for you
>> (at least for software RAID/dm devices) and for some external arrays
>> if the vendor exports the information in a standard way.
>> 
Mike> Would this include eSATA DAS units?  Example: LaCie 4big Quadra

No.  Only SCSI devices report the necessary information.  There are no
comparable fields in ATA-ACS.


Mike> I can't discover or alter the IO size on this device and have not
Mike> received an answer from LaCie support.  They did say something to
Mike> the effect of "We don't have this information in our
Mike> documentation, so it must be I.P. that I can't disclose."

I.e. "we source this controller from a company in China and have no
idea".

-- 
Martin K. Petersen	Oracle Linux Engineering
