From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Maybe removal of data=journal
Date: Mon, 5 May 2014 16:21:52 -0700
Message-ID: <20140505232152.GM8434@birch.djwong.org>
References: <0279006b-b361-48a6-8777-e7a1cf565c92@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "R. Felber" <robert.felber@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33132 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbaEEXV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 19:21:58 -0400
Content-Disposition: inline
In-Reply-To: <0279006b-b361-48a6-8777-e7a1cf565c92@email.android.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 08:46:57PM +0200, R. Felber wrote:
> Please don't remove this.
> 
> There are situations where I don't want to use directio but want to be sure that I can recover from journal.
> 
> I use sync,data=journal for guaranteed transactions.
> 
> Correct me, if this is pointless.

I'm not sure if this was a reaction to the ext5 patches I was proposing, but if
it was, I left all the journal mount options enabled (I think).

Either way, thank you for stepping up for data=journal, it'll help us to
better understand which mount options are getting used and why. :)

--D
> 
> -- 
>    Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
