From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: check new sysfs interface to determine if we
 are on battery
Date: Mon, 20 Feb 2012 20:24:23 -0500
Message-ID: <20120221012423.GA25249@thunk.org>
References: <1329783103-4017-1-git-send-email-tytso@mit.edu>
 <4F42E2A2.1020703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42786 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2BUBY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 20:24:28 -0500
Content-Disposition: inline
In-Reply-To: <4F42E2A2.1020703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2012 at 06:17:38PM -0600, Eric Sandeen wrote:
> > You need to enumerate through all power supply devices with the
> > "type" = "Mains" attribute, and check if any of them have the
> > "online" attribute as "1".  If so you have AC power. If don't find
> > any power supply of "type" = "Mains" then you are on AC power
> > too. Only if you have one or more power supplies of "type" =
> > "Mains" and all of them have "online" = "0" then you are on
> > battery.

*Ugh*.  Why is it that the new interfaces are always more complicated.  :-(

> If your patch fixes the general case, I say go for it! :)

All's the world a Thinkpad, right?  :-)

							- Ted
