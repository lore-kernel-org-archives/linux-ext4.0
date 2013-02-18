From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 8/9] ext4: adjust some functions for reclaiming extents
 from extent status tree
Date: Mon, 18 Feb 2013 11:54:53 +0800
Message-ID: <20130218035453.GA7344@gmail.com>
References: <1361118474-18310-1-git-send-email-wenqing.lz@taobao.com>
 <1361118474-18310-9-git-send-email-wenqing.lz@taobao.com>
 <20130217163323.GA18354@gmail.com>
 <51218D8B.9020704@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39358 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3BRDkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 22:40:12 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so2553480pad.20
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 19:40:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <51218D8B.9020704@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 10:10:19AM +0800, Tao Ma wrote:
> Hi Zheng,
> On 02/18/2013 12:33 AM, Zheng Liu wrote:
> > On Mon, Feb 18, 2013 at 12:27:53AM +0800, Zheng Liu wrote:
> >> From: Zheng Liu <wenqing.lz@taobao.com>
> >>
> >> This commit changes some interfaces in extent status tree because we
> >> need to use inode to count the cached objects in a extent status tree.
> >>
> >> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> >> Cc: "Theodore Ts'o" <tytso@mit.edu>
> >> Cc: Jan kara <jack@suse.cz>
> > 
> > Oops, I forgot to add 'v6' in subject.  The patch itself is right.
> You can use git format-patch --subject-prefix="PATCH V6" to create this
> series of subjects automatically.

Thanks for teaching me.

Regards,
                                                - Zheng
