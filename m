From: Kirk True <kirk@mustardgrain.com>
Subject: Re: Failures in e2fsprogs-1.39-tyt3 'make check'
Date: Mon, 4 Jun 2007 08:38:51 -0700 (PDT)
Message-ID: <114319.28763.qm@web611.biz.mail.mud.yahoo.com>
References: <20070604125109.GA20342@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web611.biz.mail.mud.yahoo.com ([209.191.88.224]:27316 "HELO
	web611.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758361AbXFDPiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2007 11:38:52 -0400
In-Reply-To: <20070604125109.GA20342@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Theodore,

> > Sorry if this is a documented, known issue. I'm just being paranoid
> and
> > don't want to do a 'make install' if it will hose up the box.
> 
> Yes, it's known.  Note that e2fsprogs 1.39-tyt3 is really only meant
> for ext4 developers.  If you're not trying to use ext4 (and it's
> really not meant for production use yet), you should be using
> e2fsprogs.1.39 or e2fsprogs WIP-20070407.

Thanks for the quick reply.

Yes - I'm trying to get into ext4 development, so I'll assume these
aren't fatal and proceed.

Thanks!
Kirk
