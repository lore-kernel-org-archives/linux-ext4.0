From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] ext4: add isolated project support
Date: Thu, 11 Mar 2010 07:07:47 -0500
Message-ID: <20100311120747.GD4706@infradead.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <1267727677-11956-3-git-send-email-dmonakhov@openvz.org> <1267727677-11956-4-git-send-email-dmonakhov@openvz.org> <1267727677-11956-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab0CKMHs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 07:07:48 -0500
Content-Disposition: inline
In-Reply-To: <1267727677-11956-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 09:34:36PM +0300, Dmitry Monakhov wrote:
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
> 
> *Usage*
>  We already has bind mounts which prevent link/remount across mounts.
>  But if user has isolated project which consists of several subtrees
>  and he want link/renames to work between subtrees(but in one project)
> 
> Since this feature is non obvious it controlled by mount option.

Making this a mount option is even more non-obvious.  Unless you have
very good reason to support both and not just stick to the existing
"isolated" semantics make it a chattr option so we can easily check
out what kind of subtree we deal with.

