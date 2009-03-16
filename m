From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Mon, 16 Mar 2009 10:42:49 -0700
Message-ID: <1237225369.3964.4.camel@bobble.smo.corp.google.com>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com>
	 <49BE8C30.5030901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:14564 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZCPRnI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 13:43:08 -0400
In-Reply-To: <49BE8C30.5030901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-03-16 at 12:28 -0500, Eric Sandeen wrote:
> This is for Red Hat bug 490026,
> EXT4 panic, list corruption in ext4_mb_new_inode_pa
> 
> ext4_lock_group(sb, group) is supposed to protect this list for
> each group, and a common code flow to remove an album is like
> this:
> 
>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>     ext4_lock_group(sb, grp);
>     list_del(&pa->pa_group_list);
>     ext4_unlock_group(sb, grp);
> 
> so it's critical that we get the right group number back for
> this prealloc context, to lock the right group (the one 
> associated with this pa) and prevent concurrent list manipulation.

Eric, this may just be coincidence, but is it possible that this may be
related to our bitmap problem I described last week?  We haven't tracked
it down yet but it certainly smells like a race and your fix corrects
just such a race in the same code.

The bitmap problem, btw, involves stuff apparently being marked as used
when it's really free (or something very much like that), ultimately
resulting in double frees.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

