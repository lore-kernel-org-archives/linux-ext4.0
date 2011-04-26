From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 16:56:58 +0800
Message-ID: <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42747 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1DZI47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 04:56:59 -0400
Received: by pvg12 with SMTP id 12so296437pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 01:56:58 -0700 (PDT)
In-Reply-To: <4DB68257.4070407@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

AFAIK, it can accelerate the recovering process.  If a block is in the
revoke table of a transaction t1 and t1 is committed, then the there
is no need to recover the block in transactions which is earlier than
t1.

On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
<kulkarniniraj14@gmail.com> wrote:
> Hi all,
> =A0 =A0 =A0I am new to fs development. I am trying to modify the jour=
nal structure
> of JBD. While analyzing the code, I could understand most of the thin=
gs, but
> I am not able to understand the need of revoke mechanism. Can anybody
> enlighten me on this issue?
>
> Regards
> Niraj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
