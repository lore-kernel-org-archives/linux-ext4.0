From: Heinz Diehl <htd@fritha.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sat, 4 Dec 2010 21:51:20 +0100
Message-ID: <20101204205120.GA17542@fritha.org>
References: <4CE05A9E.9090204@redhat.com>
 <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
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
In-Reply-To: <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04.12.2010, Matt wrote: 

> I'm not sure if it's even a problem with ext4 - I haven't had the time
> to test with XFS yet

I can and have run both -rc3 and -rc4 with Milans patch v6, without any problems at
all, under heavy load and disk I/O. I'm using XFS exclusively. The system
is a testing server and contains 3 harddisks, 2 SATA disks and one SSD.
The whole system runs flawlessly, without any corruption...
