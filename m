From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
Date: Thu, 28 Apr 2011 09:45:34 -0400
Message-ID: <1303998300-sup-4941@think>
References: <1303920553.2583.7.camel@mulgrave.site> <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site> <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site> <1303925374-sup-7968@think> <1303926637.2583.17.camel@mulgrave.site> <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo> <1303993705-sup-5213@think> <1303998140.2081.11.camel@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: James Bottomley <james.bottomley@suse.de>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Colin Ian King <colin.king@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:47327 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab1D1Np5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2011 09:45:57 -0400
In-reply-to: <1303998140.2081.11.camel@lenovo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Colin Ian King's message of 2011-04-28 09:42:20 -0400:
> 
> On Thu, 2011-04-28 at 08:29 -0400, Chris Mason wrote:
> > Excerpts from Colin Ian King's message of 2011-04-28 07:36:30 -0400:
> > > One more data point to add, I've been looking at an identical issue when
> > > copying large amounts of data.  I bisected this - and the lockups occur
> > > with commit 
> > > 3e7d344970673c5334cf7b5bb27c8c0942b06126 - before that I don't see the
> > > issue. With this commit, my file copy test locks up after ~8-10
> > > iterations, before this commit I can copy > 100 times and don't see the
> > > lockup.
> > 
> > Well, that's really interesting.  I tried with compaction on here and
> > couldn't trigger it, but this (very very lightly) tested patch might
> > help.
> > 
> Thanks Chris,
> 
> I've given this a soak test but I still see the same lockup.

Could you post the soft lockups you're seeing?

-chris
