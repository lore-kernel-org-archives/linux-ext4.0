From: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: linux-next: Tree for Aug 30 (jbd2 + bug.h)
Date: Thu, 1 Sep 2011 16:30:47 -0400
Message-ID: <CACqU3MXZ52fM_xFFxmPm3wby8bD9isAsomxbvh_Dj+bBb9uFdg@mail.gmail.com>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
	<20110831131429.0513af51.rdunlap@xenotime.net>
	<201109011343.22014.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-ext4@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201109011343.22014.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Thu, Sep 1, 2011 at 7:43 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 31 August 2011, Randy Dunlap wrote:
>> On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
>>
>> > Hi all,
>>
>> [Sorry about the delay. =A0My build machine is being slow.
>> If this is alread fixed, sorry about the noise.]
>>
>>
>> When CONFIG_BUG is not enabled (I see this on x86_64):
>>
>> fs/jbd2/transaction.c: In function 'jbd2_journal_dirty_metadata':
>> fs/jbd2/transaction.c:1176: error: implicit declaration of function =
'__WARN'
>>
>>
>> asm-generic/bug.h does not provide a version of __WARN() when
>> CONFIG_BUG is not enabled...
>>
>
> Hmm, my feeling is that we shouldn't do that either, and that jbd2 sh=
ould
> be changed. If we want a function that does what __WARN() does today,=
 we
> should probably make a conscious decision about what we want it to be=
 called
> and not have it start with "__".
>
Why is WARN_ON() not used here ?

 - Arnaud

> =A0 =A0 =A0 =A0Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
