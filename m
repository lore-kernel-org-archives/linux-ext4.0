From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] ext4: auto batched discard support at kernel thread
Date: Fri, 2 Dec 2011 03:34:51 -0500
Message-ID: <20111202083451.GA7345@infradead.org>
References: <20111202060424.GA26155@july>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, tm@tao.ma, lczerner@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46214
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab1LBIe7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Dec 2011 03:34:59 -0500
Content-Disposition: inline
In-Reply-To: <20111202060424.GA26155@july>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 02, 2011 at 03:04:24PM +0900, Kyungmin Park wrote:
> Hi,
> 
> It's proof of concept to run kernel thread for batched discard.
> 
> Now it can run fitrim at user level. but it's not clear which deamon run this activity.

fstrim from a cron job.

> In case of android platform, the launcher is candidate 
> but user can change the default launcher then it can't use the fitrim any more.

Android beeing broken as shit is no reason to push useless code into the
kernel.

