From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Mon, 19 Apr 2010 14:02:48 +0100
Message-ID: <1271682168.14748.718.camel@macbook.infradead.org>
References: <1271372682-21225-5-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
	 <20100419124025.GG10776@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Valerie Aurora <vaurora@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab0DSNC4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 09:02:56 -0400
In-Reply-To: <20100419124025.GG10776@bolzano.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-04-19 at 14:40 +0200, Jan Blunck wrote:
> On Thu, Apr 15, Valerie Aurora wrote:
> 
> > Add support for fallthru directory entries to ext2.
> > 
> > XXX - Makes up inode number for fallthru entry
> > XXX - Might be better implemented as special symlinks
> 
> Better not. David Woodhouse actually convinced me of moving away from the
> special symlink approach. The whiteouts have been implemented as special
> symlinks before.

I certainly asked whether you really need a real 'struct inode' for
whiteouts, and suggested that they should be represented _purely_ as a
dentry with type DT_WHT.

I don't much like the manifestation of that in this patch though,
especially with the made-up inode number. (ISTR I had other
jffs2-specific objections too, which I'll dig out and forward).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

