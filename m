From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: question about ext4/inode.c
Date: Mon, 02 Nov 2009 11:48:09 -0600
Message-ID: <4AEF1B59.2070702@redhat.com>
References: <Pine.LNX.4.64.0911021708550.2115@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbZKBRsO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 12:48:14 -0500
In-Reply-To: <Pine.LNX.4.64.0911021708550.2115@ask.diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Julia Lawall wrote:
> The function ext4_da_writepages_trans_blocks contains the following code:
> 
>         if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
>             (max_blocks > EXT4_MAX_TRANS_DATA))
>                 max_blocks = EXT4_MAX_TRANS_DATA;
> 
> 
> Elsewhere the constant EXT4_EXTENTS_FL is used as follows:
> 
> EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL
> 
> Should that be done in ext4_da_writepages_trans_blocks as well?
> 
> thanks,
> julia

Ouch, yes, looks like a bug.  I don't think that value would ever be set 
on the vfs inode's i_flags so we're always going down that path.

It's probably not catastrophic; if I'm reading it right we are just 
being more conservative all the time.

Want to send a patch? :)

-Eric
