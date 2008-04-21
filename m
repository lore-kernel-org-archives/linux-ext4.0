From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 01:02:09 +0200
Message-ID: <480D1CF1.7010300@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <20080421.133940.52972455.davem@davemloft.net> <480D04A2.5000006@gmail.com> <480D0E14.1040306@gmail.com> <480D147C.90602@gmail.com> <20080421225452.GF9153@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: paulmck@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:48970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYDUXCZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 19:02:25 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1933366fgb.17
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 16:02:21 -0700 (PDT)
In-Reply-To: <20080421225452.GF9153@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/22/2008 12:54 AM, Paul E. McKenney wrote:
> On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
>>> Having slub_debug enabled, tomorrow will be results, I guess...
>> Sorry, one more entry:
>>
>> 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)

Zdenek's is at offset 184.

>> 00f0000000000000 dentry.d_hash.next (me, offset 24)
>> ffff81f02003f16c dentry.d_name.name (me, offset 56)
>>         memory ORed by 000000f000000000
>> fffff0002004c1b0 file.f_mapping (me, offset 176)
>>         memory hole, it was something like
>>         (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
>> ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
>>         -1, ~0ULL
>=20
> Are these running with CONFIG_PREEMPT_RCU?  Grasping at straws, but
> there are a couple of patches that need to move from -rt to mainline,
> but mostly related to SELinux.  So if both PREEMPT_RCU and SELinux
> were in use, we might be missing "rcu-various-fixups.patch" from:

$ grep RCU .config
CONFIG_CLASSIC_RCU=3Dy
# CONFIG_RCU_TORTURE_TEST is not set
$ grep SECU .config
# CONFIG_EXT4DEV_FS_SECURITY is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set

I guess not.

BTW the corruption I mentioned earlier was char '=F0' and it's ('p' | 0=
xf0) in=20
latin2. I think it was set_=F0ending_irq IIRC. Whatever, it won't help =
us.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
