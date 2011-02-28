From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: nblocks arg to ext4_truncate_restart_trans() is
 ignored
Date: Sun, 27 Feb 2011 23:41:39 -0500
Message-ID: <20110228044139.GP2924@thunk.org>
References: <AANLkTikjhsA0ooZAkS4zhaMrFidOgpjuk54cTxu30Xb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49782 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab1B1QFc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 11:05:32 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikjhsA0ooZAkS4zhaMrFidOgpjuk54cTxu30Xb5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 27, 2011 at 11:54:28AM +0200, Amir Goldstein wrote:
> nblocks is passed into ext4_truncate_restart_trans() from
> ext4_ext_truncate_extend_restart() with a value different from the default
> blocks_for_truncate(), but is being ignored.
> 
> The two other calls to ext4_truncate_restart_trans() already pass the
> default value, which is then being recalculated inside the function.
> 
> Fix the problem by using the passed argument.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

Thanks, added to the ext4 patch queue.

							- Ted
