Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFC1C4321D
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 18:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5237214C6
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 18:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDZSRo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfDZSRo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Apr 2019 14:17:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C887DC0AF781;
        Fri, 26 Apr 2019 18:17:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 247495C225;
        Fri, 26 Apr 2019 18:17:43 +0000 (UTC)
Date:   Fri, 26 Apr 2019 14:17:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm/fs: don't allow writes to immutable files
Message-ID: <20190426181738.GB34536@bfoster>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552787330.20411.11893581890744963309.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155552787330.20411.11893581890744963309.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 26 Apr 2019 18:17:43 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 17, 2019 at 12:04:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Once the flag is set, it is enforced for quite a few file operations,
> such as fallocate, fpunch, fzero, rm, touch, open, etc.  However, we
> don't check for immutability when doing a write(), a PROT_WRITE mmap(),
> a truncate(), or a write to a previously established mmap.
> 
> If a program has an open write fd to a file that the administrator
> subsequently marks immutable, the program still can change the file
> contents.  Weird!
> 
> The ability to write to an immutable file does not follow the manpage
> promise that immutable files cannot be modified.  Worse yet it's
> inconsistent with the behavior of other syscalls which don't allow
> modifications of immutable files.
> 
> Therefore, add the necessary checks to make the write, mmap, and
> truncate behavior consistent with what the manpage says and consistent
> with other syscalls on filesystems which support IMMUTABLE.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

This mostly seems reasonable to me. I assume you'll want some mm acks. A
couple notes..

>  fs/attr.c    |   13 ++++++-------
>  mm/filemap.c |    3 +++
>  mm/memory.c  |    3 +++
>  mm/mmap.c    |    8 ++++++--
>  4 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index d22e8187477f..1fcfdcc5b367 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -233,19 +233,18 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
>  
>  	WARN_ON_ONCE(!inode_is_locked(inode));
>  
> -	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
> -		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> -			return -EPERM;
> -	}
> +	if (IS_IMMUTABLE(inode))
> +		return -EPERM;
> +
> +	if ((ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) &&
> +	    IS_APPEND(inode))
> +		return -EPERM;
>  
>  	/*
>  	 * If utimes(2) and friends are called with times == NULL (or both
>  	 * times are UTIME_NOW), then we need to check for write permission
>  	 */
>  	if (ia_valid & ATTR_TOUCH) {
> -		if (IS_IMMUTABLE(inode))
> -			return -EPERM;
> -
>  		if (!inode_owner_or_capable(inode)) {
>  			error = inode_permission(inode, MAY_WRITE);
>  			if (error)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d78f577baef2..9fed698f4c63 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3033,6 +3033,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	loff_t count;
>  	int ret;
>  
> +	if (IS_IMMUTABLE(inode))
> +		return -EPERM;
> +
>  	if (!iov_iter_count(from))
>  		return 0;
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index ab650c21bccd..dfd5eba278d6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2149,6 +2149,9 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
>  
>  	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
>  
> +	if (vmf->vma->vm_file && IS_IMMUTABLE(file_inode(vmf->vma->vm_file)))
> +		return VM_FAULT_SIGBUS;
> +

I take it this depends on cleaning already dirty pages when the
immutable bit is set. That appears to be done later in the series, but I
notice it occurs at the filesystem level (presumably due to the ioctl).
That of course is fine, but it makes me wonder a bit whether we should
have a generic helper for each fs to call that does the requisite
writeback and dio wait (similar to generic_remap_file_range_prep() for
example). Thoughts?

>  	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
>  	/* Restore original flags so that caller is not surprised */
>  	vmf->flags = old_flags;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 41eb48d9b527..697a101bda59 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1481,8 +1481,12 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		case MAP_SHARED_VALIDATE:
>  			if (flags & ~flags_mask)
>  				return -EOPNOTSUPP;
> -			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
> -				return -EACCES;
> +			if (prot & PROT_WRITE) {
> +				if (!(file->f_mode & FMODE_WRITE))
> +					return -EACCES;
> +				if (IS_IMMUTABLE(file_inode(file)))
> +					return -EPERM;
> +			}

We haven't done anything to clean up writeable mappings on marking the
inode immutable, right? It seems a little strange that we can have some
writeable mappings hang around while we can't create new ones, but
perhaps it doesn't matter if the write fault behavior is the same.

Brian

>  
>  			/*
>  			 * Make sure we don't allow writing to an append-only
> 
