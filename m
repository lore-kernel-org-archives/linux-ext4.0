From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Don't allow lg prealloc list to be grow large.
Date: Tue, 22 Jul 2008 12:42:23 -0500
Message-ID: <48861BFF.5050108@redhat.com>
References: <1216725016-22855-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYGVRot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2008 13:44:49 -0400
In-Reply-To: <1216725016-22855-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Currently locality group prealloc list is freed only when there is a block allocation
> failure. This can result in large number of per cpu locality group prealloc space
> and also make the ext4_mb_use_preallocated expensive. Convert the locality group
> prealloc list to a hash list. The hash index is the order of number of blocks
> in the prealloc space with a max order of 9. When adding prealloc space to the
> list we make sure total entries for each order does not exceed 8. If it is more
> than 8 we discard few entries and make sure the we have only <= 5 entries.
> 

This looks better on the particular benchmark:

http://people.redhat.com/esandeen/ext4/fs_mark.png

contains a run with this patch.

I must admit to not actually reading the patch yet, though :)  Just ran
it in the background while working on some other things today.

-Eric
