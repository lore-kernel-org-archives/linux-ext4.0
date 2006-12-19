From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Tue, 19 Dec 2006 15:23:41 -0600
Message-ID: <4588585D.5070800@redhat.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com> <20061219114251.GA25086@amitarora.in.ibm.com> <20061219211409.GP5937@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	suzuki@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbWLSVaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Dec 2006 16:30:04 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061219211409.GP5937@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Dec 19, 2006  17:12 +0530, Amit K. Arora wrote:
>> I wrote a simple tool to test these patches. The tool takes four
>> arguments:
>>
>> * command: It may have either of the two values - "prealloc" or "write"
>> * filename: This is the filename with relative path
>> * offset: The offset within the file from where the preallocation, or
>> 		the write should start.
>> * length: Total number of bytes to be allocated/written from offset.
>>
>> Following cases were tested :
>> 1. * preallocation from 0 to 32MB
>>    * write to various parts of the preallocated space in sets
>>    * observed that the extents get split and also get merged
>>
>> 2. * preallocate with holes at various places in the file
>>    * write to blocks starting from a hole and ending into preallocated
>>       blocks and vice-versa
>>    * try to write to entire set of blocks (i.e. from 0 to the last
>>       preallocated block) which has holes in between.
> 
> An ideal test would be to modify fsx to (randomly) do preallocations
> instead of truncates that increase the size.

the fsx in the xfs qa suite already does this (albeit with the special
xfs calls, of course)

But it might be worth looking at as a starting point, and also maybe to
keep the options and behavior similar to one* version of fsx that is out
there. :)

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/ltp/fsx.c?rev=1.7

-Eric

*http://kernelslacker.livejournal.com/?skip=43
