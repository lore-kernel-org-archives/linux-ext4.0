From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Tue, 2 Jan 2007 15:17:27 +0530
Message-ID: <20070102094727.GA5932@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <m364bpn5ku.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34809 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730AbXABJrd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jan 2007 04:47:33 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l029lWSH011853
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 04:47:32 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l029lWow287000
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 04:47:32 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l029lV2S030750
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 04:47:32 -0500
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m364bpn5ku.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 02, 2007 at 12:25:21PM +0300, Alex Tomas (AT) wrote:
> >>>>> Amit K Arora (AKA) writes:
> 
>  AKA> The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
>  AKA> check for extent overlap, when a new extent needs to be inserted in an
>  AKA> inode. An overlap is possible when the new extent being inserted has
>  AKA> ee_block that is not part of any of the existing extents, but the
>  AKA> tail/center portion of this new extent _is_. This is possible only when
>  AKA> we are writing/preallocating blocks across a hole.
> 
> AT> not sure I understand ... you shouldn't insert an extent that overlap
> AT> any existing extent. when you write block(s), you first check is
> AT> it already allocated and insert new extent only if it's not.

You are right. That is what this patch does.
The current ext4 code is inserting an overlapped extent in a particular
scenario (explained above). The suggested patch fixes this by having a
check in get_blocks() for _not_ inserting an extent that may overlap
with an existing one.

> AT> for preallocated block(s), you should adapt existing extent(s) so that
> AT> they don't overlap new extent you're inserting. am I missing something?

The patch makes the new extent being inserted adjust its length based on any
existing extent that may overlap, so that the overlap does not happen at
all.

> AT> also, I think that modification of existing extent(s) (not merging)
> AT> isn't safe.

The existing extent(s) are not being modified in any way here. We check
if there is an overlap between the new extent being inserted by
get_blocks(), with an existing one. If there is, we update the new extent
(being inserted) accordingly. The existing extent is not touched (unless
the insert_extent() does a merge, if possible).

Please let me know if the intentions are still not clear here. Thanks!

Regards,
Amit Arora
