From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Tue, 09 Jul 2013 09:14:29 -0500
Message-ID: <51DC1AC5.8010809@redhat.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab3GIOOb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 10:14:31 -0400
In-Reply-To: <1369829133-4307-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/29/13 7:05 AM, Jan Kara wrote:
>   Hello,
> 
>   while working on my patchset, I stumbled over an overflow bug which
> made me do a quick audit of shifts in ext4 code. I've found a couple of
> places which use << and which can overflow (usually on 32-bit
> architecture only but at least SEEK_HOLE / SEEK_DATA bugs are real even
> for 64-bit architectures). Patches in this series fix the issues I've
> found. Likely this is also stable material so Ted, you might want to add
> stable@vger.kernel.org to CC when merging the patches.
> 
> 								Honza

I don't think these did get cc'd to stable.  Was there a reason for that,
or was it an oversight?

-Eric
