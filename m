From: Jan Kara <jack@suse.cz>
Subject: Re: ext5
Date: Thu, 11 Feb 2010 18:55:58 +0100
Message-ID: <20100211175557.GA27418@atrey.karlin.mff.cuni.cz>
References: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at> <20100210215028.GD739@thunk.org> <ea11fea31002101938y7bd5d6f4u5f7cdda972ea72e2@mail.gmail.com> <20100211043029.GE739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>,
	"Anonymous Remailer (austria)" <mixmaster@remailer.privacy.at>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60372 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab0BKRz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 12:55:59 -0500
Content-Disposition: inline
In-Reply-To: <20100211043029.GE739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Feb 11, 2010 at 09:08:36AM +0530, Manish Katiyar wrote:
> > 
> > Is this design somewhere on net so that we can read/lookup it up ?
> 
> Not yet, but the basic idea is to do the compression in userspace,
> using libz with regular resync points every 64k or 128k of
> uncompressed data.  An array, indexed by each fixed-block of
> uncompressed data, is located at the beginning of the file indicating
> where each compressed block begins.  The file is stored on-disk
> written by the installer in a compressed format, and then the
> installer flips an attribute bit which marks the file as containing
> compressed data, and which also makes the file immutable.  (Any
> attempt to open the file read/write will result in an error.)
  From the first reading, this sounds like what zisofs is doing.
The reading part is already implemented in kernel in fs/isofs/compress.c
so that might be lifted to a generic level and used for ext4 as well..

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
