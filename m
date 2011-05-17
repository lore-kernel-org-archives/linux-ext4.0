From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xfstests: device busy when umount
Date: Tue, 17 May 2011 18:01:14 +0300
Message-ID: <BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
	<4DD286E5.8090105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34190 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1EQPBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 11:01:16 -0400
Received: by eyx24 with SMTP id 24so165222eyx.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 08:01:15 -0700 (PDT)
In-Reply-To: <4DD286E5.8090105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 5:32 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 5/17/11 4:03 AM, Yongqiang Yang wrote:
>> Hi,
>>
>> I noticed that all tests which contain 'device busy' errors have
>> falloc operations. =A0Does the error have something to do with fallo=
c?
>>
>
> cc'ing xfs list since xfs devs maintain xfstests.
>
> What tests have "device busy" errors? =A0What do the usual investigat=
ive
> steps such as "lsof" and "fuser" tell you when this happens?

I tried running lsof | grep $TEST_DIR before umount
and I tried sleep 1 before umount and it didn't yield anything.

>
> Are there loop devices that didn't get cleaned up, or processes that
> have not terminated?
>
> What tests have these problems?

for me 124 always fails to umount, and 198 and 213 sometimes fails to u=
mount.

>
> -Eric
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
