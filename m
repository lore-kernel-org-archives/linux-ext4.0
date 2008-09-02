From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Do we need dump for ext4?
Date: Tue, 02 Sep 2008 10:52:03 -0500
Message-ID: <48BD6123.9090406@redhat.com>
References: <48B6BD02.3080307@redhat.com> <48B7ED40.6020508@redhat.com> <20080831024300.GB3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbYIBPxl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2008 11:53:41 -0400
In-Reply-To: <20080831024300.GB3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Aug 29, 2008  07:36 -0500, Eric Sandeen wrote:
>> at Ric & hch's  request here is tar on the other fs's as well, re-sorted
>>  by level 0 dump time.  I put acp into the mix as well.
>>
>> Oh, and this time I remembered to set the elevator to something sane
>> (noop) for this storage, oops (was cfq last time)
>>
>> Also, this time the dup/tar/acp was written to /dev/null rather than
>> another filesystem.  Interesting how routing to /dev/null alone changed
>> the ranking quite a bit.
> 
> Note that tar has a (questionable) optimization when writing to /dev/null.
> It will NOT open the file or read the data, and just do the filename
> traversal to generate the file list and total file size.  It does this by
> comparing the output file to "/dev/null":

Ah, crud.

-Eric
