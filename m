From: Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Thu, 6 Jan 2011 16:56:41 +0100
Message-ID: <20110106155641.GA12443@fancy-poultry.org>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz Diehl <htd@fritha.org>, Matt <jackdachef@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1AFP5B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jan 2011 10:57:01 -0500
Content-Disposition: inline
In-Reply-To: <4CFB679D.5030900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05.12.2010, Milan Broz wrote: 

> It still seems to like dmcrypt with its parallel processing is just
> trigger to another bug in 37-rc.

To come back to this: my 3 systems (XFS filesystem) running the latest 
dm-crypt-scale-to-multiple-cpus patch from Andi Kleen/Milan Broz have 
not showed a single problem since 2.6.37-rc6 and above. No corruption any 
longer, no freezes, nothing. The patch applies cleanly to 2.6.37, too, 
and runs just fine.

I blindly guess that my data corruption problem was related to something else in the
2.6.37-rc series up to -rc4/5.

Since this patch is a significant improvement: any chance that it finally gets 
merged into mainline/stable?

