From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Wed, 03 Jan 2007 10:07:01 -0800
Message-ID: <459BF0C5.2060302@us.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com>	<m364bpn5ku.fsf@bzzz.home.net> <20070102094727.GA5932@amitarora.in.ibm.com> <m3irfobg29.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44938 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXACSHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jan 2007 13:07:09 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l03I74fI025995
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 13:07:04 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l03I73sS551938
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 11:07:03 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l03I73ro018745
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jan 2007 11:07:03 -0700
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3irfobg29.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>>Amit K Arora (AKA) writes:
> 
> 
>  AKA> On Tue, Jan 02, 2007 at 12:25:21PM +0300, Alex Tomas (AT) wrote:
>  >> >>>>> Amit K Arora (AKA) writes:
>  >>
>  AKA> The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
>  AKA> check for extent overlap, when a new extent needs to be inserted in an
>  AKA> inode. An overlap is possible when the new extent being inserted has
>  AKA> ee_block that is not part of any of the existing extents, but the
>  AKA> tail/center portion of this new extent _is_. This is possible only when
>  AKA> we are writing/preallocating blocks across a hole.
>  >>
>  AT> not sure I understand ... you shouldn't insert an extent that overlap
>  AT> any existing extent. when you write block(s), you first check is
>  AT> it already allocated and insert new extent only if it's not.
> 
>  AKA> You are right. That is what this patch does.
>  AKA> The current ext4 code is inserting an overlapped extent in a particular
>  AKA> scenario (explained above). The suggested patch fixes this by having a
>  AKA> check in get_blocks() for _not_ inserting an extent that may overlap
>  AKA> with an existing one.
> 
> I think that stuff that converts uninitialized blocks
> to initialized ones should be a separate codepath and
> shouldn't be done in the insert path. and an insert
> (basic tree manipulation) should BUG_ON() one tries
> to add extent with a block which is already covered
> by the tree.
> 
> IMHO, get_blocks() should look like:
> 
>   path = find_path()
>   if (found extent covers request block(s)) {
>     if (extent is uninitialized) {
>       convert();
>     }
>   }
> 
> where
>    function convert()
>   {
>     /* adopt existing extent so that it
>      * doesn't cover requested blocks */
> 
>     /* insert head or tail of existing
>      * extent, if necessary */
> 
>     /* insert new extent of initialized blocks */
>   }
> 
> thanks, Alex

I was thing about the same thing. The current ext4_ext_get_blocks() 
function becomes very bulky. The code to convert uninitialized blocks to 
initialized ones is pretty selfcontained, and worth the effort to put it 
into a seperate function.

But the bug Amit pointed here is unrelated to the code convert 
uninitialized blocks to initialized ones. Rather, it's related to do 
multiple block allocation across on a window with parts already have 
blocks allocated. Without the check, the current code just simply 
allocate the requested extent and insert it into the tree which might 
overlap with existing extent.

Mingming
