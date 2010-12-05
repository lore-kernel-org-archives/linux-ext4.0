From: Heinz Diehl <htd@fritha.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 5 Dec 2010 11:09:54 +0100
Message-ID: <20101205100954.GA6564@fritha.org>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05.12.2010, Matt wrote: 

> I should have made it clear that the results I get are observed when
> using the kernels/checkouts *with* the dm-crypt multi-cpu patch,
> without the patch I didn't see that kind of problems (hardlocks, files
> missing, etc.)

I have to take back my other two emails, stating that no corruption
happened with the dm-crypt multi-cpu patch. Today, I encountered
filesystem corruption on one, and a complete hardlock on another machine.
No logfile entries, no m-sysrq, a complete deadlock. Filesystem was
corrupted here too, had to reboot from CD.

The machines with plain 2.6.37-rc4 are up and running...
