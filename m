From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4_da_block_invalidatepages() question
Date: Wed, 27 Jan 2010 20:34:24 +0800
Message-ID: <20100127123424.GA5062@localhost>
References: <20100126133608.GC25407@localhost> <20100126153222.GI3187@quack.suse.cz> <20100127015339.GA8132@localhost> <20100127122528.GB3149@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0A0Mee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jan 2010 07:34:34 -0500
Content-Disposition: inline
In-Reply-To: <20100127122528.GB3149@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 27, 2010 at 04:25:28AM -0800, Jan Kara wrote:
> On Wed 27-01-10 09:53:39, Wu Fengguang wrote:

> > The patch includes a cleanup and a bug fix, both looks OK to me.
> > But if we can split it, the bug fix would be good candidate for
> > the stable kernel?
>   I don't think we want to push this to -stable kernel. As I wrote, this
> code is called only in case user is going to loose written data which is a
> bug on it's own so loosing a few page references is nothing compared to
> that.

Ah OK. Thanks for the patch.

Cheers,
Fengguang
