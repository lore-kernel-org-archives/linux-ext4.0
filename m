From: tytso@mit.edu
Subject: Re: ext5
Date: Thu, 11 Feb 2010 14:31:32 -0500
Message-ID: <20100211193132.GK739@thunk.org>
References: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at>
 <20100210215028.GD739@thunk.org>
 <ea11fea31002101938y7bd5d6f4u5f7cdda972ea72e2@mail.gmail.com>
 <20100211043029.GE739@thunk.org>
 <20100211175557.GA27418@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>,
	"Anonymous Remailer (austria)" <mixmaster@remailer.privacy.at>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49361 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0BKTbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2010 14:31:45 -0500
Content-Disposition: inline
In-Reply-To: <20100211175557.GA27418@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2010 at 06:55:58PM +0100, Jan Kara wrote:
>   From the first reading, this sounds like what zisofs is doing.
> The reading part is already implemented in kernel in fs/isofs/compress.c
> so that might be lifted to a generic level and used for ext4 as well..

I didn't know about zisofs; thanks for pointing that out!  I'll
mention it to the student I'm helping out....

						- Ted
