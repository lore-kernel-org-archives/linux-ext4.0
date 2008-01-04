From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Date: Fri, 4 Jan 2008 23:01:25 +0300
Message-ID: <20080104200125.GA21486@cvg>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de> <20080104190137.GJ17436@mit.edu> <20080104194129.GA16962@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:35974 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYADUBo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 15:01:44 -0500
Received: by fk-out-0910.google.com with SMTP id z23so7355795fkz.5
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2008 12:01:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20080104194129.GA16962@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Andi Kleen - Fri, Jan 04, 2008 at 08:41:29PM +0100]
[...snip...] 
| My hope here is of course that these trivial changes are primarily
| used as a way to get "the feet wet" to understand the procedures
| for contribuing larger not quite as trivial changes
| 
| -Andi
| 
| P.S.: Mathieu, this is not against you personally; you just happened
| to be a convenient example of a larger problem in this case. Sorry.
| 

Oh, Andi, you're so right! I don't like to admit that, but you're
right (in my case at least). I counted four clean-up patches I sent
since last 'really bug fix' I made patch. Actually I thought that
really helps the kernel but it seems it doesn't and causes more
problem with patch applience (unfortunately).

		- Cyrill -
