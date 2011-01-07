From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Fri, 7 Jan 2011 17:45:37 +0100
Message-ID: <AANLkTinmHhF=p2vFTS4AxKoMpWN6BZsWyDbB+jBa=jN9@mail.gmail.com>
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
	<20110106155641.GA12443@fancy-poultry.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>,
	linux-kernel@vger.kernel.org
To: Heinz Diehl <htd@fancy-poultry.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110106155641.GA12443@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 6, 2011 at 4:56 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 05.12.2010, Milan Broz wrote:
>
>> It still seems to like dmcrypt with its parallel processing is just
>> trigger to another bug in 37-rc.
>
> To come back to this: my 3 systems (XFS filesystem) running the latest
> dm-crypt-scale-to-multiple-cpus patch from Andi Kleen/Milan Broz have
> not showed a single problem since 2.6.37-rc6 and above. No corruption any
> longer, no freezes, nothing. The patch applies cleanly to 2.6.37, too,
> and runs just fine.
>
> I blindly guess that my data corruption problem was related to something else in the
> 2.6.37-rc series up to -rc4/5.
>
> Since this patch is a significant improvement: any chance that it finally gets
> merged into mainline/stable?
>
>

Hi Heinz,

I've been using this patch since 2.6.37-rc6+ with ext4 and xfs
filesystems and haven't seen any corruptions since then
(ext4 got "fixed" since 2.6.37-rc6, xfs showed no problems from the start)

http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1449032be17abb69116dbc393f67ceb8bd034f92
(is the actual temporary fix for ext4)

Regards

Matt
