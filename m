From: Andreas Schlick <schlick@lavabit.com>
Subject: Re: [PATCH 1/1] dir shrink
Date: Sun, 30 Aug 2009 21:15:32 +0200
Message-ID: <200908302115.32536.schlick@lavabit.com>
References: <1242338523.6933.664.camel@timo-desktop> <200908290018.18084.schlick@lavabit.com> <20090828231115.GV4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:34351 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZH3TPd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 15:15:33 -0400
In-Reply-To: <20090828231115.GV4197@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Saturday 29 August 2009, Andreas Dilger wrote:
> > As I understand it, Ted's idea was to avoid problems with the
> > transactions by doing it after the main work of
> > unlink()/rmdir()/rename(). I don't know what the better approach is and
> > don't mind changing it.
> This seems reasonable, though in that case it seems it would be much
> more efficient to just put the directory inode onto an in-memory list
> of directories that have recently emptied a block, and then have a
> separate helper thread (or kernel task or whatever) that checks this
> list periodically and does freeing of all blocks at the end of the
> file that are empty.

But is deleting a huge number of files common enough that the increase in code 
complexity pays off? I'd expect that it doesn't happen often enough to gain 
much. And if it gets more complex, I'd like to have the base functionality 
tested first, so would the patch be acceptable as it is?

Andreas Schlick

