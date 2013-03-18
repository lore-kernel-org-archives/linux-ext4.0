From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/jbd2: don't wait (forever) for stale tid caused by
 wraparound
Date: Mon, 18 Mar 2013 10:34:04 -0400
Message-ID: <20130318143404.GB14430@thunk.org>
References: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
 <1363412062.3937.196.camel@deadeye.wl.decadent.org.uk>
 <20130318025401.GA12611@thunk.org>
 <91B5F5AF93734BAA86939ED896DDEF63@atlassian.com>
 <1363582395.3937.319.camel@deadeye.wl.decadent.org.uk>
 <20130318143156.GA14430@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Barnett <gbarnett@atlassian.com>,
	linux-ext4@vger.kernel.org,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54108 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3CROeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 10:34:09 -0400
Content-Disposition: inline
In-Reply-To: <20130318143156.GA14430@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One other observeration; problems relating to tid wrap have been
around for a very long time.  It's an issue for both ext3 and ext4, so
Red Hat and SuSE have been shipping QA'ed enterprise kernels with this
issue for over a decade.  This is one of the reasons why I don't think
it's a good idea to rush a fix into mainline, the stable 3.2.x
kernels, or the Debian kernel, until we really make sure we have any
proposed bug fixes fully tested and verified.

						- Ted
