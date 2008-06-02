From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 02 Jun 2008 16:03:20 +0100
Message-ID: <1212419000.7337.36.camel@localhost>
References: <1212171647.7508.46.camel@localhost>
 <20080602074102.GA3242@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@Sun.COM>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:58138 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYFBPDb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 11:03:31 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m52F3TXR021808
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 15:03:29 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1U00A01B9J5900@fe-emea-10.sun.com>
 (original mail from Ricardo.M.Correia@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 02 Jun 2008 16:03:29 +0100 (BST)
In-reply-to: <20080602074102.GA3242@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Karel,

On Seg, 2008-06-02 at 09:41 +0200, Karel Zak wrote: 
> It'd be nice to add ZFS detection to libvolume_id from udev package.

Interesting, I didn't know libvolume_id existed.
Is there a reason why there should be 2 different libraries doing what
appears to be essentially the same thing?

> > +	/* read nvpair data for pool name, pool GUID (complex) */
> > +	//blkid_set_tag(probe->dev, "LABEL", pool_name, sizeof(pool_name));
> > +	//set_uuid(probe->dev, pool_guid, 0);
> 
>  C++ ?

Actually, those are valid C99 tokens for comments. I don't see any style
guide in the source of e2fsprogs, and they do appear to be used in some
places (like lib/uuid/uuid_gen_nt.c), but if necessary that can be
easily changed.

> > -		if (memcmp(id->bim_magic, buf + (id->bim_sboff&0x3ff),
> > +		if (memcmp(id->bim_magic, buf + (id->bim_sboff & 0x3ff),
> 
>  ???

That's unrelated to the purpose of this patch, it seems to be just a
style fix (inherited from Andreas' patch) :-)

Thanks,
Ricardo

--

Ricardo Manuel Correia
Lustre Engineering

Sun Microsystems, Inc.
Portugal
Phone +351.214134023 / x58723
Mobile +351.912590825
Email Ricardo.M.Correia@Sun.COM

