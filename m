From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: simple_strtol returns signed.
Date: Sat, 18 Oct 2008 10:36:10 -0400
Message-ID: <20081018143610.GA8383@mit.edu>
References: <48FA4558.2020603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43014 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750994AbYJROgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 10:36:12 -0400
Content-Disposition: inline
In-Reply-To: <48FA4558.2020603@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 18, 2008 at 04:21:44PM -0400, roel kluin wrote:
> simple_strtol returns signed.

Actually the better fix is probably to change the use of
simple_strtol() to simple_strtoul().

						- Ted
