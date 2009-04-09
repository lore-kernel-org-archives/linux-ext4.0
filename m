From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext2: Fix data corruption for racing writes
Date: Thu, 9 Apr 2009 13:30:30 -0700
Message-ID: <20090409133030.a7ea94c7.akpm@linux-foundation.org>
References: <1238715399-22172-1-git-send-email-jack@suse.cz>
	<a4a7801d0904031738h68bf6218lfd3349ca50f46642@mail.gmail.com>
	<20090406102329.GD31189@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: yinghan@gmail.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, yinghan@google.com,
	nickpiggin@yahoo.com.au
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbZDIUep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 16:34:45 -0400
In-Reply-To: <20090406102329.GD31189@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 6 Apr 2009 12:23:29 +0200
Jan Kara <jack@suse.cz> wrote:

> > 
> > I tried this patch and seems i got deadlock on the truncate_mutex.
> > Here is the message after enabling lockdep. I pasted the same message
> > on the origianal thread.
>
> ...
>
>   I don't think this is a deadlock (or is the machine hung?). The thread
> was just waiting for a long time. I'd think that you'll occasionally get
> exactly the same message even without my patch if you stress the machine
> like you do.
>  

Well, it's easy to tell the difference

deadlock: system never recovers
long-sucky-delay: system eventually recovers.

Which was it??
