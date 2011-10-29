From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: fix quota accounting during migration
Date: Sat, 29 Oct 2011 09:09:54 -0400
Message-ID: <20111029130954.GD19536@thunk.org>
References: <1316266379-18737-1-git-send-email-dmonakhov@openvz.org>
 <1316266379-18737-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40645 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933772Ab1J2SMk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:40 -0400
Content-Disposition: inline
In-Reply-To: <1316266379-18737-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 17, 2011 at 05:32:58PM +0400, Dmitry Monakhov wrote:
> tmp_inode should have same uid/gid as  original inode.
> Otherwise new metadata blocks will be accounted in to wrong
> quota-id which result in quota leak after indirect blocks swap.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

					- Ted
