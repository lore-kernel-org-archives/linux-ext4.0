From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: very slow SSD with fsync
Date: Fri, 13 Mar 2015 11:25:59 -0400
Message-ID: <20150313152559.GB21922@thunk.org>
References: <5502F8A3.4020608@smop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Adrian Bridgett <adrian@smop.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38191 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbbCMP0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 11:26:02 -0400
Content-Disposition: inline
In-Reply-To: <5502F8A3.4020608@smop.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 13, 2015 at 02:48:03PM +0000, Adrian Bridgett wrote:
> Slow as in sync(1) taking 6 seconds on an idle system, dd-ing from the raw
> disk drops from 600MB/s to less than 1MB/s.   iotop shows jbd2 often waiting
> a long time, but _very_ low throughput (KB/s it that).  I've spent a day or
> so trying everything I can find to identify the cause but I'm completely
> stuck (even with help from a btrfs guru - he eventually suggested asking
> here).

The obvious thing to do is to try using blktrace to see which I/O
operations are triggering the problem.  It may just be that the hard
drive's internal FTL metadata is very badly fragmented.

If so, it could be that that the only thing that will fix things is to
reset the entire FTL is to do a full backup, do a discard or a secure
erase on the entire SSD, and then reformat and do a restore from
backups.

You might also try looking at the SSD model and try to find some
reviews on Tom's Hardware or Anand Tech to see how the SSD fares when
stressed on various SSD torture tests.  What model SSD is it, by the
way?

					- Ted
