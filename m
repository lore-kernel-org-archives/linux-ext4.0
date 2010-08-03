From: Ted Ts'o <tytso@mit.edu>
Subject: Re: persistent preallocation
Date: Tue, 3 Aug 2010 14:06:31 -0400
Message-ID: <20100803180631.GA9453@thunk.org>
References: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Bo =?iso-8859-1?Q?Brant=E9n?= <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab0HCSgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 14:36:18 -0400
Content-Disposition: inline
In-Reply-To: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 12:58:21PM +0200, Bo Brant=E9n wrote:
>=20
> I have a question on the implementation of persistent preallocation,
> the reason to not return the disk block is because it can contain
> old data but I wonder if an implementation has to return zeros
> instead or if it could return any garbage as long as it is not
> _that_ garbage?

What would be the point?  If we know that we can't return the on-disk
block contents, returning all zero's is much nicer for the application
since it also then looks like and works just like a sparse file.

      	      	   	      	  	- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
