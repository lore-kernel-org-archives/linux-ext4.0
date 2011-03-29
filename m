From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xfstests: failure to umount ext4
Date: Tue, 29 Mar 2011 11:01:01 +0200
Message-ID: <AANLkTik9irNe5QnNdKAsU88KyJ1bNHTNZBV4iYdzxUun@mail.gmail.com>
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
	<4D8A0A70.9030201@redhat.com>
	<AANLkTi=JvL6LoL=VOrHoiQKheqzDrVwOQtWAkumzaBk5@mail.gmail.com>
	<4D8A1594.5060505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: XFS <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35866 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1C2JBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 05:01:02 -0400
Received: by qwk3 with SMTP id 3so2475870qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2011 02:01:01 -0700 (PDT)
In-Reply-To: <4D8A1594.5060505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 5:45 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 3/23/11 10:33 AM, Amir Goldstein wrote:
>> On Wed, Mar 23, 2011 at 4:57 PM, Eric Sandeen <sandeen@redhat.com> w=
rote:
>>> On 3/23/11 9:36 AM, Amir Goldstein wrote:
>>>> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.co=
m> wrote:
>>>>>
>>>>> I've been running xfstests on ext4 and I always get annoying fail=
ures to umount:
>>>>>
>>>>> 213 8s ... 31s
>>>>> umount: /mnt/test/ext4: device is busy.
>>>>> =A0 =A0 =A0 =A0(In some cases useful info about processes that us=
e
>>>>> =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>>>>>
>>>>> post 198 mostly fails to umount as well.
>>>>> and post 124 always fails to umount.

USE_REMOUNT=3D1 fixes (bypasses) the problem for non scratch tests, so
I'm good with it for now :-)

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
