From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: xfstest failure: #68, with data=journal
Date: Fri, 22 Mar 2013 22:06:28 +0800
Message-ID: <20130322140628.GA2770@gmail.com>
References: <nsxfvzov3em.fsf@closure.thunk.org>
 <20130321221218.GA3349@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:43690 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3CVNuy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2013 09:50:54 -0400
Received: by mail-da0-f44.google.com with SMTP id z20so2280517dae.17
        for <linux-ext4@vger.kernel.org>; Fri, 22 Mar 2013 06:50:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130321221218.GA3349@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 21, 2013 at 06:12:18PM -0400, Eric Whitney wrote:
[snip]
> We were giving this one some attention in late February on the mailing list,
> but I don't think a full solution was found.  Here's a pointer to Jan Kara's
> analysis:
> 
> http://www.spinics.net/lists/linux-ext4/msg36858.html
> 
> Back then, it typically took a number of runs to see this problem.

What I was thinking about this problem is that ext4_file_dio_write() is
missing protection.  Look at this link, please [1].  But, after fixing
it, I still can hit a bug.  So I believe that more than one bug are
here.

1. http://www.spinics.net/lists/linux-ext4/msg37267.html

Regards,
                                                - Zheng
