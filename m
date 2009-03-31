From: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Tue, 31 Mar 2009 14:50:49 +0200
Message-ID: <b637ec0b0903310550x52a22e22hb034ee7aaa0c3844@mail.gmail.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	 <20090211075914.GC20842@skywalker>
	 <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	 <20090212211935.GE6922@mini-me.lan>
	 <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
	 <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
	 <20090331123320.GC13356@mit.edu>
	 <b637ec0b0903310540s10ddfdb3vcf8e419ebffa09f9@mail.gmail.com>
	 <20090331124716.GG13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZCaMuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 08:50:52 -0400
In-Reply-To: <20090331124716.GG13356@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted.

On Tue, Mar 31, 2009 at 2:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Mar 31, 2009 at 02:40:22PM +0200, Fabio Comolli wrote:
>> OK. Now I have on my box the 2.6.27.19 kernel. Do you mean that I ha=
ve
>> to apply 19->20, 20->21 and then this patch?
>
> There are ext4-related fixes in the 19->20 patches. =C2=A0There are n=
o ext4
> related patches in 20->21, so whether or not you do this is optional
> (from the perspective of applying this patch).
>

OK

>> Then mount the fs as ext4dev?
>
> Yes, same as before. =C2=A0I will note that there were some enhanceme=
nts
> and some lower-priority bug fixes that don't get backported to 2.6.27
> series, since sometimes it is extremely difficult to backport things
> as far as 2.6.27. =C2=A0So if your goal is to use this in production,
> 2.6.29 will almost certainly be a better bet. =C2=A0The number of peo=
ple
> who test the 2.6.27 backports of ext4 are also much smaller. =C2=A0We
> provide it as a service those who for whatever reason refuse to updat=
e
> to newer kernels, but it's hard for me to offer guarantees.
>

Many thanks. I normally use 2.6.29 with ext4 but I just discovered a
bug that prevents me to use video acceleration. It seems that this was
introduced in the 2.6.28 series and 2.6.27.X don't have it.

> Best regards,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>

Regards,
=46abio
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
