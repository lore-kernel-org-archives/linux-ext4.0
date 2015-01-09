From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 06:55:46 -0800
Message-ID: <20150109145546.GA26251@infradead.org>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbbAIOzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jan 2015 09:55:49 -0500
Content-Disposition: inline
In-Reply-To: <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 09, 2015 at 12:01:59PM +0000, Stefan Hajnoczi wrote:
> Can you explain under what conditions mounting the same file system
> twice will work?
> 
> I guess the kernel is looking up the block device and then sharing the
> superblock if the file system is already mounted on this block device?

Exactly.

> 
> If I use two loop devices for the same underlying storage it does not
> work:

Because that's very much the same situation as two different systems
trying to mount it.
