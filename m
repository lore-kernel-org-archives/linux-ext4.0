From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Tue, 15 Apr 2014 11:15:41 -0500
Message-ID: <534D5B2D.70408@redhat.com>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu> <20140413220016.GD8122@thunk.org> <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaDOQPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 12:15:45 -0400
In-Reply-To: <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/15/14, 11:02 AM, Luk=E1=9A Czerner wrote:
> On Sun, 13 Apr 2014, Theodore Ts'o wrote:
>=20
>> Date: Sun, 13 Apr 2014 18:00:16 -0400
>> From: Theodore Ts'o <tytso@mit.edu>
>> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
>> Cc: Namjae Jeon <linkinjeon@gmail.com>
>> Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging=
 purposes
>>
>> On Sun, Apr 13, 2014 at 04:21:58PM -0400, Theodore Ts'o wrote:
>>> If a particular fallocate mode is causing test failures, give the
>>> tester the ability to block a particular fallocate mode so that the
>>> use of a particular fallocate mode will be reported as not supporte=
d.
>>>
>>> For example, if the COLLAPSE_RANGE fallocate mode is causing test
>>> failures, this allows us to suppress it so we can more easily test =
the
>>> rest of the file system code.
>>
>> Hi Namjae,
>>
>> One of the reasons this patch set is that after Lukas added
>> COLLAPSE_RANGE support into fsx, we've started seeing a number of
>> failures which seem to be directly related to COLLAPSE_RANGE.
>=20
> Ah, I did mentioned it when I added COLLAPSE_RANGE to the fsx and
> fsstress, but I forgot to cc you Namjae, sorry about that.
>=20
> But about the patch. It seems a little bit weird to change kernel
> for this. The way I am doing it is by changing ltp/fsx.c and
> ltp.fsstress.c to disable the particular mode:

I tend to agree, better to fix the kernel than to add a knob to turn it
off.  And fsx changes can happen a lot quicker than kernel changes.  [1=
]

And if it's really unsafe, and you really want to add a knob, I'd at le=
ast
default it to off until it's non-corrupting, and add a message that
this tunable will go away as soon as it's stable, so you'll have no
qualms about quickly deprecating it...

-Eric

[1] it'd be nifty to make an env. var in xfstests which can globally
disable certain fsx operations across all tests which run fsx...
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
