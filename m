From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][RESEND]tracepoint: add
 drop_transaction/update_superblock_end to jbd2
Date: Mon, 6 Feb 2012 18:27:27 -0500
Message-ID: <20120206232727.GA22324@thunk.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C58316AF9@USINDEVS01.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"dle-develop@lists.sourceforge.net"
	<dle-develop@lists.sourceforge.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Satoru Moriya <satoru.moriya@hds.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34090 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2BFX1n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 18:27:43 -0500
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C58316AF9@USINDEVS01.corp.hds.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 11, 2012 at 07:10:40PM -0500, Seiji Aguchi wrote:

> This patch adds trace_jbd2_drop_transaction and
> trace_jbd2_update_superblock_end because there are similar
> tracepoints in jbd and they are needed in jbd2 as well.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>  Reviewed-by: Lukas Czerner <lczerner@redhat.com>

I've applied this patch to my ext4 tree.  Apologies for the delay in
getting back to you.

						- Ted
