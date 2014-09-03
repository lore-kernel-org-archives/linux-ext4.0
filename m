From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: don't call get_bh() before calling
 __jbd2_journal_remove_checkpoint()
Date: Wed, 3 Sep 2014 13:30:00 -0400
Message-ID: <20140903173000.GH2504@thunk.org>
References: <20140902215930.GJ6232@thunk.org>
 <1409698000-18126-1-git-send-email-tytso@mit.edu>
 <CAGZGoEfjAZuOAbp-AqA-kiL2aTwiRXDO_Di=LPDovRBDNSn5dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yuanhan Liu <yliu.null@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35524 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbaICRaF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 13:30:05 -0400
Content-Disposition: inline
In-Reply-To: <CAGZGoEfjAZuOAbp-AqA-kiL2aTwiRXDO_Di=LPDovRBDNSn5dw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 03, 2014 at 03:48:56PM +0800, Yuanhan Liu wrote:
> >                  * Get our reference so that bh cannot be freed before
> >                  * we unlock it
> >                  */
> 
> I guess you need remove those comments as well.

Good catch, thanks.

					- Ted
