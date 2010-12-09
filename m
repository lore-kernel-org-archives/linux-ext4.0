From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 15:13:59 -0500
Message-ID: <20101209201359.GG2921@thunk.org>
References: <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think>
 <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com>
 <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org>
 <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun@gmail.com,
	linux-ext4@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59255 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab0LIUOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Dec 2010 15:14:19 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 09, 2010 at 12:10:58PM -0600, Jon Nelson wrote:
> 
> You should be OK, there. Are you using encryption or no?
> I had difficulty replicating the issue without encryption.

Yes, I'm using encryption.  LUKS with aes-xts-plain-sha256, and then
LVM on top of LUKS.

> > If you can point out how to query pgsql_tmp (I'm using a completely
> > default postgres install), that would be helpful, but I don't think it
> > would be going anywhere else.
> 
> Normally it's /var/lib/pgsql/data/pgsql_tmp (or
> /var/lib/postgres/data/pgsql_tmp in your case). By placing
> /var/lib/{postgresql,pgsql}/data on the LUKS + ext4 volume, on both
> openSUSE 11.3 and Kubuntu, I was able to replicate the problem easily,
> in VirtualBox. I can give qemu a try. In both cases I was using a
> 2.6.37x kernel.

Ah, I'm not using virtualization.  I'm running on a X410 laptop, on
raw hardware.  Perhaps virtualization slows things down enough that it
triggers?  Or maybe you're running with a more constrained memory than
I?  How much memory do you have configured in your VM?

    	     	       	   		      - Ted
