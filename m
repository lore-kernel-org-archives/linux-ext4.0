From: Jan Kara <jack@suse.cz>
Subject: Re: recursive mtime patches
Date: Tue, 12 Apr 2011 17:48:30 +0200
Message-ID: <20110412154830.GF5246@quack.suse.cz>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49023 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1DLPsb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2011 11:48:31 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 11-04-11 16:37:57, Amir Goldstein wrote:
> Do you have an uptodate version of your recursive mtime patches?
> The only version I can find online is the original series from 2007.
  I've put latest version (against 2.6.37) to
http://beta.suse.com/private/jack/recursive_mtime/

> I am interested in the patches for indexdb-like application,
> so persistence after crash is also important for my use case.
> Your patches would require the application to perform a full
> directory scan after crash, right?
  OK, it depends. Currently, even mtime updates are not reliable (data can
be written to a file while mtime update is not yet committed).  Recursive
modification stamps have possibly larger race windows but I haven't really
tried how much (I just know that even mtime races are not that hard to
trigger if you try). So it really depends on how big reliability do you
expect and I personally don't find much value in just rescanning and
checking for mtime after a crash. Reading all the data and doing checksum
certainly has more value but at a high cost.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
