From: Marcos Mello <marcosfrm@gmail.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Wed, 20 Jun 2012 12:18:44 +0000 (UTC)
Message-ID: <loom.20120620T141614-743@post.gmane.org>
References: <4FDEC3C2.4060909@secunet.com> <x49fw9smohy.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58239 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2FTMUH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 08:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1ShJtD-00053d-Py
	for linux-ext4@vger.kernel.org; Wed, 20 Jun 2012 14:20:04 +0200
Received: from bd3f8ea4.virtua.com.br ([bd3f8ea4.virtua.com.br])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2012 14:20:03 +0200
Received: from marcosfrm by bd3f8ea4.virtua.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2012 14:20:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Moyer <jmoyer <at> redhat.com> writes:

<snip>
> 
> I am unable to reproduce this behaviour.  Can you give more information
> about your storage configuration?  What is the partition layout, which
> partition are you trying to mount, and are you using the standard mount
> command to try to mount it?  Is there anything else you can provide that
> would help me reproduce the problem?
> 

Probably the same problem:
http://www.sysresccd.org/forums/viewtopic.php?f=13&t=4511

