From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Mon, 05 Nov 2007 22:49:52 -0600
Message-ID: <472FF270.7020500@redhat.com>
References: <472F80F5.3030608@redhat.com> <20071106011255.GB3900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXKFEtz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 23:49:55 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA64nsbc017580
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 23:49:54 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA64nrZV005053
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 23:49:53 -0500
In-Reply-To: <20071106011255.GB3900@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Nov 05, 2007  14:45 -0600, Eric Sandeen wrote:
>> (this patch has been carried in Red Hat / Fedora rpms for a while, not 
>> sure why it never got sent upstream... clearing this allows for mounting 
>> filesystems with a resize_inode on older systems)
>>
>> Allow tune2fs to set & clear resize_inode; requires fsck afterwards.
> 
> Two things that are a bit confusing:
> - since RESIZE_INODE is a COMPAT feature, I don't see how this affects
>   mounting the filesystem on older systems?  Is there a bug somewhere?

Hmm there is a RHEL3 bug, long since closed with a patch like this one
(actually less fleshed out)... but you're right, this should work.

(quick test)

...and it does.  Grrr, sorry, assumed the patch was there for a reason!

I'll retract this patch, I don't think it's needed.  Sorry for the noise.

-Eric
