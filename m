From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4: add isolated project support
Date: Thu, 4 Mar 2010 21:07:00 +0100
Message-ID: <20100304200700.GA6092@atrey.karlin.mff.cuni.cz>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <1267727677-11956-3-git-send-email-dmonakhov@openvz.org> <1267727677-11956-4-git-send-email-dmonakhov@openvz.org> <1267727677-11956-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60234 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932149Ab0CDUHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 15:07:03 -0500
Content-Disposition: inline
In-Reply-To: <1267727677-11956-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> PROJECT_ISOLATION
> This feature allows to create an isolated project subtrees.
> Isolation means what:
>   1) directory subtree has no common inodes (no hadlinks across subtrees)
>   2) All descendants belongs to the same subtree.
> 
> Project subtree's isolation assumptions:
>   1)Inode can not belongs to different subtree trees
>     Otherwise changes in one subtree result in changes in other subtree
>     which contradict to isolation criteria.
  Just a curious question:
Do you really need this subtree separation in your envisioned containers
usecase? Because there I imagine you have one project_id per container,
containers form disjoint subtrees (at least their writeable parts) and
each file & directory has this project_id set and you forbid to manipulate
project id's from inside the container (otherwise you'd have problems with
enforcing quota limits I guess).

And when project_id is a per-inode property, quota has no problems with it
(is well defined) even without subtree separation. So is this subtree
separation really needed?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
