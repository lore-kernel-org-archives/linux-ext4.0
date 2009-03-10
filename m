From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090310: ext4 hangs
Date: Tue, 10 Mar 2009 15:54:30 +0300
Message-ID: <a4423d670903100554w32fa7ad0n771b4351b2434382@mail.gmail.com>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vg
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090310124658.GE8840@mit.edu>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/3/10 Theodore Tso <tytso@mit.edu>:
> On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> It is similar to http://lkml.org/lkml/2009/2/6/304,
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D12579
>>
>> I run dbench on ext4 on loop on ext3 on sparc.
>> The kernel is 2.6.29-rc7-next-20090310
>> e2fsprogs -1.41.4
>
> Thanks for reporting this; does it show up on stock 2.6.29-rc7? =C2=A0=
And
> any chance you can enable LOCKDEP? =C2=A0Finally, how many CPU's do y=
ou
> have on your machine?

I will try it with current -git.
LOCkDEP is enabled already.
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_DEBUG_LOCKDEP=3Dy

It is UP system.
