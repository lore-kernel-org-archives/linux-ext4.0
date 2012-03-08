From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Wed, 07 Mar 2012 23:23:49 -0500
Message-ID: <yq1vcmfhga2.fsf@sermon.lab.mkp.net>
References: <20120305125029.GA5121@gmail.com> <20120307005130.GH3592@dastard>
	<A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
	<yq1k42xhulg.fsf@sermon.lab.mkp.net> <20120307121138.GK3592@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Andreas Dilger <aedilger@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43916 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2CHEX6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 23:23:58 -0500
In-Reply-To: <20120307121138.GK3592@dastard> (Dave Chinner's message of "Wed,
	7 Mar 2012 23:11:38 +1100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> From what I've seen of the proposed SMR device standards, we're
Dave> going to have to redesign filesystem allocation policies

[...]

The initial proposal involved SMR disks having a sparse LBA map carved
into 2GB chunks. However, that was shot down pretty hard.

The approach currently being worked uses either dynamic (flash, tiered
storage) or static hints (SMR) to put things in an appropriate area
given the nature of the I/O.

This puts the burden of virtual to physical LBA management on the device
rather than in the filesystem allocators. And gives us the benefit of
having a single interface that can be used for many different device
types.

That said, the current proposal is crazy complex and clearly written
with Windows in mind. They are creating different access profiles for
.DLLs, .INI files, apps in the startup folder, and so on.


Dave> Indeed, there is no end of different allocation policies a
Dave> filesystem could define, so I don't think that iterating them in
Dave> fadvise() is a good thing to do.

I have no particular opinion on the proposed fadvise() flags. Just
saying that no matter whether we like it or not we'll have to be able to
pass information about expected access patterns down to the storage.

-- 
Martin K. Petersen	Oracle Linux Engineering
