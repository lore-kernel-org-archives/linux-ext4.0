From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix online resize group descriptors corruption
Date: Thu, 12 Jun 2008 15:04:27 -0400
Message-ID: <20080612190427.GD18229@mit.edu>
References: <1213263754.6549.45.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49338 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755324AbYFLTEi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 15:04:38 -0400
Content-Disposition: inline
In-Reply-To: <1213263754.6549.45.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 11:42:34AM +0200, Fr=E9d=E9ric Boh=E9 wrote:
> From: Frederic Bohe <frederic.bohe@bull.net>

=46rederic,

Many thanks!  How much testing have you done with the patch?  Does it
fix growing the filesystems from a filesystem with say, 18 block
groups to 32 block groups?  Have you tried with with different
filesystem features, including with and without flex_bg and uninit_bg?

Regards,

	   	     	       	    			- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
