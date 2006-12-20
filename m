From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Wed, 20 Dec 2006 13:49:24 +0530
Message-ID: <20061220081924.GA6783@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com> <20061219114251.GA25086@amitarora.in.ibm.com> <20061219211409.GP5937@schatzie.adilger.int> <4588585D.5070800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	suzuki@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44400 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964926AbWLTIY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Dec 2006 03:24:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBK8OPUc027852
	for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2006 03:24:25 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBK8JRaq105702
	for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2006 03:19:27 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBK8JQUC024291
	for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2006 03:19:27 -0500
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <4588585D.5070800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 19, 2006 at 03:23:41PM -0600, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On Dec 19, 2006  17:12 +0530, Amit K. Arora wrote:
> >> I wrote a simple tool to test these patches. The tool takes four
> >> arguments:
> >>
> >> * command: It may have either of the two values - "prealloc" or "write"
> >> * filename: This is the filename with relative path
> >> * offset: The offset within the file from where the preallocation, or
> >> 		the write should start.
> >> * length: Total number of bytes to be allocated/written from offset.
> >>
> >> Following cases were tested :
> >> 1. * preallocation from 0 to 32MB
> >>    * write to various parts of the preallocated space in sets
> >>    * observed that the extents get split and also get merged
> >>
> >> 2. * preallocate with holes at various places in the file
> >>    * write to blocks starting from a hole and ending into preallocated
> >>       blocks and vice-versa
> >>    * try to write to entire set of blocks (i.e. from 0 to the last
> >>       preallocated block) which has holes in between.
> >
> > An ideal test would be to modify fsx to (randomly) do preallocations
> > instead of truncates that increase the size.
> 
> the fsx in the xfs qa suite already does this (albeit with the special
> xfs calls, of course)

Hmm... the fsx in xfs qa suite does preallocation, but _only_ at the
start of the testcase - i.e. only once. I guess what Andreas suggested is to
use random preallocations instead of random truncates. That will essentially
mean to call "doprealloc(size)" (which will preallocate size number of
bytes from start of the file), instead of dotruncate(size) in the
"test(void)" function; when fsx is passed with a relevant option (say
"-x"). Am I right ?

BTW, I plan to modify the fsx-linux.c in LTP for this. Will update on
how it goes...

> 
> But it might be worth looking at as a starting point, and also maybe to
> keep the options and behavior similar to one* version of fsx that is out
> there. :)

Yes, it will be nice to keep the behavior and the option same here.

> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/ltp/fsx.c?rev=1.7
> 
> -Eric
> 
> *http://kernelslacker.livejournal.com/?skip=43
