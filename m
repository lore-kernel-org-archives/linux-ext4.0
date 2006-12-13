From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: [RFC] [patch 2/3] change attribute for ext4: ext4 specific code
Date: Wed, 13 Dec 2006 18:31:50 +0100
Message-ID: <45803906.5070307@bull.net>
References: <456DD75A.2010700@bull.net> <20061206214934.GA4551@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55327 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbWLMR7x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 12:59:53 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061206214934.GA4551@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry for the late answer.
I agree that using i_version field sounds better, I'm working on it.

regards,
Jean noel

Andreas Dilger wrote:
> On Nov 29, 2006  19:54 +0100, Jean-Noel Cordenner wrote:
>> This part of the patch concerns the ext4 code.
> 
> I was looking more closely at this code, and wondering two things:
> - why not just use the existing inode->i_version field instead of
>   adding a new i_change_attribute?  The i_version is not used by
>   the VFS at all, and only for detecting directory modifications in
>   ext3 (where it has the same semantic as the new i_change_attribute
>   anyways).  This avoids bloating the VFS inode more than it already is.
> - why not just do an increment of i_version in ext3_do_update_inode()?
>   That is ext3_dirty_inode->ext3_mark_inode_dirty->ext3_mark_iloc_dirty()
>   and also handles all of the VFS locations that call notify_change().
>   This MUST be called anywhere that we make a persistent change to the
>   inode in order to flush it to disk.  That would reduce the patch to
>   a few lines at most.  I don't think there are any places we need to
>   supplement this (even mmap IO or writes to a hole will update mtime).
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
