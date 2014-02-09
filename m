From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: =?utf-8?b?aW5saW5lX2RhdGE=?= feature
Date: Sun, 9 Feb 2014 14:39:42 +0000 (UTC)
Message-ID: <loom.20140209T153529-464@post.gmane.org>
References: <loom.20140122T171340-153@post.gmane.org> <loom.20140125T212226-499@post.gmane.org> <20140126032909.GA24834@thunk.org> <20140128122011.GA8083@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58021 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaBIOkI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Feb 2014 09:40:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1WCVYE-0007Tn-RG
	for linux-ext4@vger.kernel.org; Sun, 09 Feb 2014 15:40:06 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 15:40:06 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 15:40:06 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng Liu <gnehzuil.liu <at> gmail.com> writes:

> 
> On Sat, Jan 25, 2014 at 10:29:09PM -0500, Theodore Ts'o wrote:
> > On Sat, Jan 25, 2014 at 08:22:56PM +0000, Ian Nartowicz wrote:
> > > Ian Nartowicz <claws <at> nartowicz.co.uk> writes:
> > > 
> > > > 
> > > > I have been trying to test the inline_data feature of EXT4.
> > 
> > Could you try running e2fsck under valgrind?  And could you also
> > confirm the git commit ID of the e2fsprogs pu branch that you used to
> > compile it?
> > 
> 
> Ian,
> Thanks for reporting the problem.  That would be great if you can run
> e2fsck under valgrind as Ted suggested because it would help us to find
> the root cause.
> 
> Further, Here is the latest patch set for making e2fsprogs support
> inline_data feature [1], which isn't applied into e2fsprogs/pu branch.
> This patch set is against e2fsprogs/next branch.

> Regards,
>                                                 - Zheng
> --


I was using the pu commit ID 11266daa7cc2af6601929f041684f1e2a2c4f773 from
October 14th.  I'll try the latest patches against next.  Are those patches
available as a tarball?

I ran valgrind and got a lot of output.  Mostly uninitialised stuff, moves
and one or two others.  Do you want that or just wait and see how the new
build goes?

--ian

