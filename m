From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Tue, 26 May 2009 06:45:59 +0200
Message-ID: <20090526044559.GB10980@cip.informatik.uni-erlangen.de>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <4A1B0B4A.8050706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:58666 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbZEZEp6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2009 00:45:58 -0400
Content-Disposition: inline
In-Reply-To: <4A1B0B4A.8050706@tmr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill,
I think you didn't read what I write so here is it again: My
applications are VMs. Every disk that you give to a VM is zeroed out, one
way ot the other: One way is to use dd or something that has the same
effect the other is using a sparse file. That is guranteed. Now as soon
as you start working in this VM it is not guranteed because on real live
applications it makes limited sense to zero out freed blocks (expect
maybe you have a SAN LUN exported from a storage device that supports
data deduplication or if you want that deleted files disappear from you
block device). Todays datadeduplication and backupsolutions for VM
depend on the property that unused data blocks are zeroed out. And
actually I can't think of an easier interface. As I proposed earlier, if
you don't like it for performance reasons, that's fine, but if you have
to backup 5.6 Terabyte instead of 17 Terabyte than this is a huge space
safer even with the performance overhead involved.

        Thomas
