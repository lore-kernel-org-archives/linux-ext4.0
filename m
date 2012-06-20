From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 slow on links
Date: Tue, 19 Jun 2012 22:15:00 -0500
Message-ID: <4FE14034.6070800@redhat.com>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2FTDPK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 23:15:10 -0400
In-Reply-To: <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/19/12 7:20 PM, Norbert Preining wrote:
> Dear all
> 
> (please Cc)
> 
> I recently had to track down a big delay in one of my Debian packages,
> and it turned out that it seems to be due to ext4 being *horribly*
> slow on dealing with symlinks.
> 
> On my system, if I create a directory with 8000 symlinks (that is
> a real case of a font package shipping special encoded files) and
> the symlink targets are "far away" (long names), then, after 
> a reboot a simply
> 	ls -l
> in this directory took 1m20sec. While on second run it is down to 2secs
> (nice caching).

As Ted said, the targets might be far-flung.  If you do /bin/ls -l instead
of maybe an aliased ls which stats everything to make pretty colors,
is that faster?

-Eric
