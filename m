From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data buffers
Date: Wed, 4 Jun 2008 23:28:09 -0400
Message-ID: <170fa0d20806042028r738795d2h6b6452ecb3e0f4b7@mail.gmail.com>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com>
	 <20080603153050.fb99ac8a.akpm@linux-foundation.org>
	 <20080604101925.GB16572@duck.suse.cz>
	 <20080604111911.c1fe09c6.akpm@linux-foundation.org>
	 <20080604212202.GA8727@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Jan Kara" <jack@suse.cz>,
	"Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
	adilger@sun.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:55313 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYFED2K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 23:28:10 -0400
Received: by wa-out-1112.google.com with SMTP id j37so259733waf.23
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jun 2008 20:28:09 -0700 (PDT)
In-Reply-To: <20080604212202.GA8727@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 4, 2008 at 5:22 PM, Theodore Tso <tytso@mit.edu> wrote:

> That being said, ext3 can be tuned (and it is the default today,
> although I should probably change the default to be remount-ro), so
> that its behaviour on write errors is, "don't worry, be happy", and
> just leave the filesystem mounted read/write.  That's actually quite
> dangerous for a critical production server, however.....

I'm not completely sure which "it" you mean in "it is the default
today" (seems like you mean errors=continue) but isn't remount-ro
already the ext3 default?

see commit: 1eca93f9cafdec4a332ace9b0fc0d3886d430c28
