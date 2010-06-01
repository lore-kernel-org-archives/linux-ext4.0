From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 01 Jun 2010 12:32:29 -0700
Message-ID: <4C05604D.2070401@oracle.com>
References: <4C002427.3010706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46820 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0FATeY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 15:34:24 -0400
In-Reply-To: <4C002427.3010706@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 01:14 PM, H. Peter Anvin wrote:
> Hi all,
>
> I have looked a bit at e4defrag, and it does not appear to prevent the
> relocation of files marked immutable.  This is a problem for boot
> loaders, which may need to have a block pointer to a specific file in
> order to bootstrap themselves.
>
> Would it be possible to either:
>
> a) prevent e4defrag and/or EXT4_IOC_MOVE_EXT from relocating an
> immutable file, or
> b) add a new attribute with the above property (in case there is
> legitimate need to move around immutable files)?
>    

We (ocfs2) are looking to add a new attribute to denote files that
have a fixed allocation on disk. But at the same time, allow writes
that do not change the allocation on disk. No truncating, extending,
filling holes, etc. We were thinking of calling it "Static" files.

No meddling with the allocation will allow ocfs2 to not have any cluster
locks associated with that inode. And no cluster locks means no need
to pause ios during node recovery. This could be of interest to vm users
who are willing have fully allocated images for no stoppage during cluster
reconfiguration.

Thanks
Sunil
