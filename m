From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: update flex bg counters when resizing
Date: Mon, 8 Sep 2008 10:17:36 -0400
Message-ID: <20080908141736.GG8161@mit.edu>
References: <1219934280.3591.121.camel@frecb007923.frec.bull.fr> <20080828171156.GK26987@mit.edu> <20080828173652.GL26987@mit.edu> <1220277738.3569.10.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "; linux-ext4" <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61799 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbYIHOSN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2008 10:18:13 -0400
Content-Disposition: inline
In-Reply-To: <1220277738.3569.10.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 01, 2008 at 04:02:18PM +0200, Fr=E9d=E9ric Boh=E9 wrote:
> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Update flex_bg free blocks and free inodes counters when resizing.

Thanks, I've added it to the patch queue.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
