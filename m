From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with fsstress on powerpc
Date: Wed, 9 Apr 2008 15:09:34 +0530
Message-ID: <20080409093934.GB8238@skywalker>
References: <20080408152455.GA10827@skywalker> <20080409074457.GB944@dmon-lap.sw.ru> <20080409082115.GA8238@skywalker> <20080409083341.GC944@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:35558 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYDIJjs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 05:39:48 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m399dZYx020817
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 15:09:35 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m399dYKd831522
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 15:09:34 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m399dYdD013667
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 09:39:35 GMT
Content-Disposition: inline
In-Reply-To: <20080409083341.GC944@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2008 at 12:33:41PM +0400, Dmitri Monakhov wrote:
> On 13:51 Wed 09 Apr     , Aneesh Kumar K.V wrote:
> > On Wed, Apr 09, 2008 at 11:44:57AM +0400, Dmitri Monakhov wrote:
> > > On 20:54 Tue 08 Apr     , Aneesh Kumar K.V wrote:
> > > > Hi All,
> > > > 
> > > > Test case: fsstress with fallocate test case added.
> > > This may happens because of direct write.
> > > Please add  exact fsstess command and options.
> > > > 
> > 
> > fsstress -c -n1000 -p1000  -d /mnt/tmp/
> > 
> > What i found was also related. The file which had errors had the below
> > operations on them.
> > 
> > 82/901: dread d16/d20/d22/d2d/d63/d68/d9a/f93 [622592,53248] 0
> > 82/939: dwrite d16/d20/d22/d2d/d63/d68/d9a/f93 [1093632,77824] 28
> > 
> > 
> > 9/863: fallocate d1/d2d/d32/d8f/d97/d108/d9b/ffb [2041,75851] 28
> > 
> > 
> > 18/733: fallocate d9/ddd/f86 [481025,18486] 0
> > 18/735: dwrite d9/ddd/f86 [679936,36864] 0
> > 18/764: dread d9/ddd/f86 [53248,8192] 0
> > 18/910: dwrite d9/ddd/f86 [1454080,4096] 28
> > 18/999: dwrite d9/ddd/f86 [1798144,61440] 28
> > 
> > 
> > But what would happen during direct write that cause this ?
> Ohh it is long live bug in direct-io error handling logic:
> http://lkml.org/lkml/2006/12/18/103
> So IMHO it is beter to disable direct-io writes in your case.

Why is the patch not yet available in the Linus tree  ? Does this mean
that i  will not be able to test direct io write at all. Right
now i did

#ifdef ENOSPC_BUG_DIRECT_IO_YES
       { OP_DREAD, "dread", dread_f, 4, 0 },
       { OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
#endif  

i am not interested in dread, so commented that also.

fsstress ran successfully with this change.

-aneesh

