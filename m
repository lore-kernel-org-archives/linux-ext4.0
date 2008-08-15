From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 16:05:02 -0400
Message-ID: <20080815200502.GC22395@mit.edu>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815175243.GD6511@skywalker> <20080815180745.GE6511@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58218 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbYHOUFh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 16:05:37 -0400
Content-Disposition: inline
In-Reply-To: <20080815180745.GE6511@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh, thanks!  Chris Mason also pointed us at this proposed patch,
where he seems to be tracking a very similar issue for btrfs.  I don't
know if you've seen it....

http://article.gmane.org/gmane.linux.file-systems/25560

						- Ted
