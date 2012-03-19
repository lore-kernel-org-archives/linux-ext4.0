From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 14:14:02 -0400 (EDT)
Message-ID: <20120319.141402.934377752041508724.davem@davemloft.net>
References: <20120319153133.GA2502@thunk.org>
	<CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	<20120319161425.GB2502@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: anca.emanuel@gmail.com, joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:36975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030916Ab2CSSOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 14:14:12 -0400
In-Reply-To: <20120319161425.GB2502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 12:14:25 -0400

> It's about the same utility as fixing "colour" to be "color" because
> people think standardized spelling is somehow critically important.
> Guess what?

Not the same, since moving to pr_*() allows us to standardize on
kernel log output formatting, amongst other things, so it has a real
practical impact unlike the spelling fix.

Ted, just fold the tent and raise the white flag, you're wrong on this
one.
