From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] ext4: mechanical change on dio get_block code in
 prepare for it to be used by buffer write
Date: Sun, 17 Jan 2010 22:12:47 +0530
Message-ID: <871vho1y48.fsf@linux.vnet.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	<1263583812-21355-2-git-send-email-tytso@mit.edu>
	<87y6jw23yn.fsf@linux.vnet.ibm.com> <4B533892.5040900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57950 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0AQQmy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 11:42:54 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0HGdQrK009696
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 03:39:26 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0HGcHkN1630388
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 03:38:17 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0HGgq0I022110
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 03:42:52 +1100
In-Reply-To: <4B533892.5040900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 17 Jan 2010 10:19:30 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
> Aneesh Kumar K. V wrote:
> 
> > How about
> > 
> > EXT4_GET_BLOCKS_CREATE. Indicate we should do block
> > allocation. But that flag alone doesn't say whether we are suppose
> > to create init or uninit extent.
> > 
> > EXT4_GET_BLOCKS_UNINIT_EXT -> Request the creation of uninit extent
> > 
> > EXT4_GET_BLOCKS_CREATE_UNINIT_EXT -> EXT4_GET_BLOCKS_CREATE|EXT4_GET_BLOCKS_UNINIT_EXT;
> > 
> > EXT4_GET_BLOCKS_DELALLOC_RESERVE -> Request for delayed allocaion
> > reservation
> > 
> > EXT4_GET_BLOCKS_PRE_IO  -> 0x0008 -> Indicate that we should do all
> > necessary extent split and make the requested range in to single extent.
> > 
> > EXT4_GET_BLOCKS_CONVERT_IO -> Convert the specified range which should be a
> > single extent into init and then try to merge the extent to left/right
> > 
> > EXT4_GET_BLOCKS_IO_CREATE_EXT -> EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_CREATE_UNINIT_EXT
> > 
> > EXT4_GET_BLOCKS_IO_CONVERT_EXT -> EXT4_GET_BLOCKS_CREATE | EXT4_GET_BLOCKS_CONVERT_IO;
> 
> 
> In addition to Aneesh's suggestions, I'm not sure of the value of
> creating more
> 
> #define FLAG_A = FLAG_B|FLAG_C
> 
> flag macros; unless you have this all in your head you just have to
> go look up the flag definition anyway, since we usually test individual
> flags not the aggregates.  I'm wondering if it might be better to just
> explicitly send in the OR'd flags rather than creating a new one, to
> see the code flow better.
> 
> Maybe it saves space, but at the cost of easy understanding IMHO.
> At least that's been my experience.


It help us to do things like below

  if (flag & FLAG_B)
     /* we need to do things for flag B */

 if (flag & FLAG_C)
     /* things for flag C */

instead of

  if ((flag & FLAG_A) || (flag & FLAG_D) 
    /* things related to previous flag B */

So it simplifies the if condition.

-aneesh
