From: "Mike Snitzer" <snitzer@gmail.com>
Subject: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 18:29:10 -0400
Message-ID: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Steven Rostedt" <rostedt@goodmis.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:23835 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJ0W3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 18:29:13 -0400
Received: by ey-out-2122.google.com with SMTP id 6so919605eyi.37
        for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 15:29:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please see: e6022603b9aa7d61d20b392e69edcdbbc1789969

Having a look at the LKML archives this was raised back in 2006:
http://lkml.org/lkml/2006/6/23/337

I'm not interested in whether unlikely() actually helps here.

I'm still missing _why_ rsv is mostly NULL at this callsite, as Andrew
asserted here:
http://lkml.org/lkml/2006/6/23/400

And then Steve here: http://lkml.org/lkml/2006/6/24/76
Where he said:
"The problem is that in these cases the pointer is NULL several thousands
of times for every time it is not NULL (if ever).  The non-NULL case is
where an error occurred or something very special.  So I don't see how
the if here is a problem?"

I'm missing which error or what "something very special" is the
unlikely() reason for having rsv be NULL.

Looking at the code; ext3_clear_inode() is _the_ place where the
i_block_alloc_info is cleaned up.  In my testing the rsv is _never_
NULL if the file was open for writing.  Are we saying that reads are
much more common than writes?  May be a reasonable assumption but
saying as much is very different than what Steve seemed to be eluding
to...

Anyway, I'd appreciate some clarification here.

thanks,
Mike
