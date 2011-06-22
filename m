From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Help required for Debugging JBD
Date: Wed, 22 Jun 2011 09:43:52 +0300
Message-ID: <BANLkTimhig+_Lb52KMcRyk5S4YQcdYozVg@mail.gmail.com>
References: <4E00CC36.80707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50663 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1FVGny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 02:43:54 -0400
Received: by wyb38 with SMTP id 38so327448wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:43:53 -0700 (PDT)
In-Reply-To: <4E00CC36.80707@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 21, 2011 at 7:52 PM, Niraj Kulkarni
<kulkarniniraj14@gmail.com> wrote:
> Hi all,
> =A0 =A0 =A0 =A0I have modified my JBD (no change to Ext3) to support
> Transactional-Flash. For that I require only to collect metadata and =
data
> blocks and send them simultaneously (no transaction record, revoke re=
cord
> etc).

It's hard to help without knowing what your patches do in more details.
Could you post the patches or give a more detailed description of how t=
hey
work?
=46or example, how do you collect data blocks without them being alread=
y
written? or is this not a requirement for your use case?

> =A0 =A0 =A0 The problem is, though it works well for small number of =
operations,
> the kernel completely hangs when I run any benchmark (like blogbench =
or
> postmark) over them. The bad thing is that there is no trace left
> afterwards, ie logs don't contain any message since the operation was
> started, kernel OOPS are not shown, no faults are shown, no panic is =
shown
> even though I have enabled panic on hard/soft lockup. I have to hard =
reboot
> machine each time.

Did you try alt+sysrq+w to dump waiting tasks?

> =A0 =A0 =A0 =A0So essentially, I am totally clueless about the point =
=A0at which it is
> crashing or reason behind it. There is a small possibility that bug m=
ay be
> in modified MTD layer (which I've written myself), but since I have r=
un
> unmodified Ext3 on that MTD layer without any bug, the chance of bugg=
y MTD
> layer appears very slim.
>
> Any help in greatly appreciated.
>
> Niraj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
