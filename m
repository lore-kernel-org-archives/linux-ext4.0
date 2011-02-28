From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 13:49:29 -0500
Message-ID: <20110228184929.GD28617@thunk.org>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
 <20110228101454.GE4834@bitwizard.nl>
 <20110228182201.GE20805@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35956 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1B1Ste (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:49:34 -0500
Content-Disposition: inline
In-Reply-To: <20110228182201.GE20805@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 07:22:01PM +0100, Jan Kara wrote:
>   As Amir said, the patch is trivial and a clear improvement. So it goes
> in.

You might want to look at the improvements I made to the ext4 version
of the patch, in terms of a slightly better error message and commit
description, and make similar changes to the ext3 version of the
patch.

See: http://article.gmane.org/gmane.comp.file-systems.ext4/23620

						- Ted
