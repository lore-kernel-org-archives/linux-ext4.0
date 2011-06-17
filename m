From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in start_this_handle()
 to control allocation flags.
Date: Thu, 16 Jun 2011 23:32:12 -0700
Message-ID: <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com> <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org> <20110602095424.GA5718@quack.suse.cz>
 <20110606032113.GC7180@thunk.org> <20110608141006.GG30037@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40724 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1FQGcc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 02:32:32 -0400
Received: by qyg14 with SMTP id 14so1162001qyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2011 23:32:32 -0700 (PDT)
In-Reply-To: <20110608141006.GG30037@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 7:10 AM, Ted Ts'o <tytso@mit.edu> wrote:
> Ping?

Hi Jan,

Is there anything required from my side on this patch ? From your
other post it seems that holding i_mutex isn't a problem. Please
advise.

-- 
Thanks -
Manish
