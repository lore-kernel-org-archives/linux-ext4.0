From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Sun, 19 Jul 2009 23:27:14 +0200
Message-ID: <20090719212714.GA6886@nb.net.home>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com> <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest> <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest> <20090719115617.GF2416@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org,
	util-linux-ng@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44770 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZGSV1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 17:27:21 -0400
Content-Disposition: inline
In-Reply-To: <20090719115617.GF2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


 Hi Ted,

On Sun, Jul 19, 2009 at 07:56:17AM -0400, Theodore Tso wrote:
> Also, apparently no once noticed until now, but there's a bug in the
> util-linux-ng's uuid.sym file.  The uuid_pack and uuid_unpack symbols
> are missing, because someone forgot to include them in the uuid.sym
> file.

 is it really bug? Why do you want to export symbols that are not part
 of the library API? 
 
 I don't see uuid_pack and uuid_unpack in uuid.h. I guess nobody use
 these symbols ;-)

> BTW, **why** is util-linux-ng gratuitously introducing backwards
> incompatibility such that packages built with util-linux-ng won't work
> with the older shared libraries?   There's no reason to do this.

 Good point. I agree that (at first glance) there's no reason for this
 change. But...

     "If possible, projects implementing generally usable DSOs
     should use symbol versioning from day one."
              -- How To Write Shared Libraries, Ulrich Drepper

 I agree with Ulrich, symbol versioning is really really good thing.

 Unfortunately, it's not possible to combine versioned symbols with
 anonymous (without version) symbols. It means after first change to
 the library ABI we will need to introduce UUID_1.0 for old symbols.

 The move from e2fsprogs to util-linux-ng is excellent opportunity 
 to introduce ABI versioning to libuuid. I don't think this change has
 negative impact to our distributions in practice.

 How often people need to mix old libuuid (from e2fsprogs) with
 applications compiled against new libuuid (from util-linux-ng)? I
 guess almost never...

> Argh, util-linux-ng 2.16 has already been released; is it too late to
> undo this change?

 I think yes, it's too late.

 A new version (2.16.1) without UUID_1.0 will require mass rebuild in
 all distributions/systems where are libuuid applications with ABI
 versioning. IMHO this is much more painful that impossibility to
 downgrade to the old libuuid (from e2fsprogs).

 Maybe we can add --disable-{libuuid,libblkid}-versioning for people
 who need to bypass the default behaviour.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
