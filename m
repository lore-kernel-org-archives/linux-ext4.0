From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH REC 0/3] ext4:Factor common code from convert and split
 unwritten.
Date: Thu, 14 Apr 2011 11:45:59 -0700
Message-ID: <1302806759.3408.5.camel@mingming-laptop>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	 <20110414141424.GG3682@thunk.org>
	 <BANLkTim9okgKc1omQ5dAvTHDrhfA_bpODw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	achender@linux.vnet.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52647 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387Ab1DNSqF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 14:46:05 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3EIO40s012997
	for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 14:24:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3EIk4VC402862
	for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 14:46:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3EIk3Gn012191
	for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 14:46:03 -0400
In-Reply-To: <BANLkTim9okgKc1omQ5dAvTHDrhfA_bpODw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-04-14 at 22:34 +0800, Yongqiang Yang wrote:
> On Thu, Apr 14, 2011 at 10:14 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Wed, Apr 13, 2011 at 10:40:48PM -0700, Yongqiang Yang wrote:
> >> These patches factor common code from ext4_ext_convert_to_initialized() and
> >> ext4_split_unwritten_extents(), so that extent-move-on-write in snapshot and
> >> punch-hole can be built on the common code as well.
> >>
> >> ext4:Add a function merging extent right and left.
> >> ext4:Add two functions splitting an extent.
> >> ext4:Reimplement convert and split_unwritten.
> >
> > Hi Yongqiang,
> >
> > I'd like to hear back from Mingming and Allison about whether these
> > patches conflict with their punch patches, since my understanding was
> > they were planning on doing very similar things (and at least would be
> > working in the very similar parts of the code).
> >
> > I agree that the extents code here could definitely use this cleanup,
> > and I'm really glad that you worked on this; thank you!  I just want
> > to make sure work you are doing is coordinated with the work that
> > Allison and Mingming are working on.
> 
> I knew it and Mingming told me that common code should be factor out
> in previous emails.  so I cced patches to Mingming and Allison.
> extent-move-on-write in ext4-snapshots needs a function splitting an
> initialized extent.
> 
> These patches indeed need advices, reviews  and even tests from
> Mingming and Allison.

Hi Yongqiang,

Thanks for working on this. I took a try before linux filesystem and
storage summit and didn't get completed. I was slightly concerned about
the amount of complexity to adding flags in order to merging the common
code. It's good to hear that you get this far and I will review it.

Allison is working on re-use the direct IO version split code in her
punch hole work, but leave the buffered IO version code unchanged. 

Mingming

