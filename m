From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 17:27:14 -0600
Message-ID: <537BE4D2.2010505@hp.com>
References: <1400589949-25595-1-git-send-email-jack@suse.cz> <1400589949-25595-3-git-send-email-jack@suse.cz> <537B8693.4000904@hp.com> <20140520210354.GB5686@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:17614 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETX3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2014 19:29:19 -0400
In-Reply-To: <20140520210354.GB5686@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/20/2014 03:03 PM, Jan Kara wrote:
>   No, I think we are fine in this case. I'm not sure what race you are
> exactly thinking of but unmount cannot certainly happen since we have a
> reference to active inode in the filesystem.
>  

Thanks for the reply Jan.  Yes, you are correct.  Sorry I forgot about that.

Thanks,
Mak.
 

