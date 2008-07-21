From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Don't allow lg prealloc list to be grow large.
Date: Mon, 21 Jul 2008 14:37:19 -0500
Message-ID: <4884E56F.3010007@redhat.com>
References: <1216633234-24194-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbYGUThr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2008 15:37:47 -0400
In-Reply-To: <1216633234-24194-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> The locality group prealloc list is freed only when there is a block allocation
> failure. This can result in large number of per cpu locality group prealloc space
> and also make the ext4_mb_use_preallocated expensive. Add a tunable max_lg_prealloc
> which default to 1000. If we have more than 1000 Per-CPU prealloc space and if we
> fail to find a suitable prealloc space during allocation we will now free all
> the prealloc space in the locality group.

It looks like this helps, but does not fare as well as the "perfectly
tuned" default (where the prealloc size is a multiple of the 20k/5 block
file size used in the test.)

I've added a plot of a delalloc run with your patch to the graph at:

http://people.redhat.com/esandeen/ext4/fs_mark.png

-Eric


