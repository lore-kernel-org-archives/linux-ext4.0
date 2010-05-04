From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Do not dec quota for reserved blocks on error paths v2
Date: Tue, 04 May 2010 15:22:45 -0500
Message-ID: <4BE08215.2050603@redhat.com>
References: <87633dcxhp.fsf@openvz.org> <87bpd3ecya.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863Ab0EDUWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 16:22:50 -0400
In-Reply-To: <87bpd3ecya.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> If we have failed some where inside ext4_get_blocks() internals we may
> have allocated some new blocks, which was not yet claimed to quota.
> We have to free such blocks, but without touching quota. Quota will
> be updated later on exit from ext4_get_blocks().
> There are two possible ways to understand what we have to skip quota update:
> 1) Caller pass corresponding flag to ext4_free_blocks()
> 2) check that free_blocks() was indirectly called by get_blocks() 
>    (i.e EXT4_I(inode)->i_delalloc_reserved_flag is set)
> Second is simpler, but may result in unpredictable consequences later.
> So i've chosen the first one, because caller must know which blocks it
> is freeing.
> 
> Eric, please take your attention to metadata blocks handling when
> you will work on new versing of  "ext4: don't use quota reservation for
> speculative metadata blocks" patch.
> 
> The bug happens on heavily loaded node, or with 227'th xfstestcase and

hm which test?  227 is xfs-only...

-Eric

> result in incorrect i_blocks (less than expected). So truncation for
> that file result in i_blocks overflow.
> Seems this was the last bug which was easily triggered by 227'th testcase.
> 
> 

