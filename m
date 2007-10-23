From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: should ext2fs_get_device_size() be returning EFBIG for >8T (or
 16T?)
Date: Tue, 23 Oct 2007 13:48:08 -0500
Message-ID: <471E41E8.2020306@redhat.com>
References: <471E40CA.2070500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXJWSsL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2007 14:48:11 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9NImArU000919
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:48:10 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9NImAcp006274
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:48:10 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9NIm9cw009623
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:48:09 -0400
In-Reply-To: <471E40CA.2070500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> I have a bug saying hey, I can't grow my filesystem on a 16T device, and
> it's because really we can only go to (2^32)-1 blocks, not (2^32)...
> 
> I was going to just silently round down by a block, because for example
> LVM makes it *very* easy to make exactly 16T devices; dropping a block
> at mkfs/growfs time seems reasonable to me.
> 
> So that led me to ext2fs_get_device_size, and I see it actually has the
> maximum allowable filesystem size encoded in it, and you get EFBIG if
> it's bigger.

Actually I guess it's looking at the largest number a blk_t can hold,
but I think the same principle applies.  Maybe it's not a big deal today...

-Eric
