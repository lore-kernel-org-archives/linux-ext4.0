From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xfstests: device busy when umount
Date: Tue, 17 May 2011 14:49:56 +0300
Message-ID: <BANLkTin3O-i09hEoTHxaJEix26dJYqJTcQ@mail.gmail.com>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
	<BANLkTi=sFDKSB=fVOQs5s49E54T+V2iQJg@mail.gmail.com>
	<BANLkTi=dqUakbFw_k=FzDO99=9T33RzUsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1EQLt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 07:49:58 -0400
Received: by ewy4 with SMTP id 4so109354ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 04:49:57 -0700 (PDT)
In-Reply-To: <BANLkTi=dqUakbFw_k=FzDO99=9T33RzUsA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 2:37 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> On Tue, May 17, 2011 at 7:36 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Tue, May 17, 2011 at 12:03 PM, Yongqiang Yang <xiaoqiangnk@gmail.=
com> wrote:
>>> Hi,
>>>
>>> I noticed that all tests which contain 'device busy' errors have
>>> falloc operations. =A0Does the error have something to do with fall=
oc?
>>
>> it might. Do you also get the device is busy errors??
> Yes, =A0all of them have falloc operations.


Interesting. I wonder why other people don't get these errors (or repor=
t them)
Which distro are you using at the moment?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
