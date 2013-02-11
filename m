From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Sun, 10 Feb 2013 22:24:51 -0500
Message-ID: <20130211032451.GA14298@thunk.org>
References: <20130207220536.GA16092@wallace>
 <20130208035547.GA19703@gmail.com>
 <20130211013523.GD10801@thunk.org>
 <20130211020836.GC13161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47826 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3BKDY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2013 22:24:57 -0500
Content-Disposition: inline
In-Reply-To: <20130211020836.GC13161@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 10, 2013 at 09:08:36PM -0500, Theodore Ts'o wrote:
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Sun Feb 10 16:29:53 EST 2013
> Failures: 255

Whoops, I spoke too soon.  This looks like a regression, which needs
investigation...

					- Ted
