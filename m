From: Ian Nartowicz <claws@nartowicz.co.uk>
Subject: Re: =?utf-8?b?aW5saW5lX2RhdGE=?= feature
Date: Fri, 24 Jan 2014 16:05:48 +0000 (UTC)
Message-ID: <loom.20140124T170451-340@post.gmane.org>
References: <loom.20140122T171340-153@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54329 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaAXQGR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jan 2014 11:06:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1W6jGp-0003qo-Hb
	for linux-ext4@vger.kernel.org; Fri, 24 Jan 2014 17:06:15 +0100
Received: from cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com ([81.103.170.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 17:06:15 +0100
Received: from claws by cpc65391-bagu13-2-0-cust595.1-3.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 17:06:15 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ian Nartowicz <claws <at> nartowicz.co.uk> writes:

> 
> I have been trying to test the inline_data feature of EXT4.  I am using
> kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> set the feature and apparently to use the filesystem, but I get a lot of
> warnings from the kernel and fsck reports several errors and then crashes.
> 



Seems like fsck is the culprit.  No errors until I try to check the filesystem.

