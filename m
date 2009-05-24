From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Sun, 24 May 2009 19:39:33 +0200
Message-ID: <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:48065 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbZEXRjd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 May 2009 13:39:33 -0400
Content-Disposition: inline
In-Reply-To: <20090524101551.57b706e9@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

> > tunable feature that zeroes our free data

> wouldn't it be better if the VM's would just support the TRIM command?

the resources available to me indicate that the TRIM command is a not
yet standarized command targeted at SSD disks to indicate free disk
space. Does ext3/4 trigger a block device layer call that could result
in a TRIM command?

        Thomas
