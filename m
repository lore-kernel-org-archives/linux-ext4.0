From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Do we really need parallel resizer?
Date: Sat, 25 Jun 2011 10:17:49 +0800
Message-ID: <BANLkTinKUgQtLuAybEG6-AKH87jZ4L34kQ@mail.gmail.com>
References: <BANLkTimYZR2tMABSjAO-pXtatgsz5x0zqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46997 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1FYCRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jun 2011 22:17:50 -0400
Received: by pvg12 with SMTP id 12so2016727pvg.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jun 2011 19:17:49 -0700 (PDT)
In-Reply-To: <BANLkTimYZR2tMABSjAO-pXtatgsz5x0zqQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 24, 2011 at 4:41 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi Andreas,
>
> I noticed that resize is protected by resize_lock. =A0Then parallel
> resizer works. =A0However, I think there is no need to make parallel
> resizer work.
>
> I think we can use an atomic integer 'resize_flag' instead of
> resize_lock, =A0resize_flag is set to 1 before the kernel does resizi=
ng
> work, =A0while resize_flag is set to 0 after the kernel finishes
> resizing work. =A0Resizing is allowed only if resize_flag is 0. =A0If
> resize_flag is 1, kernel returns -EBUSY to userspace.
Sorry, I made an error.  we should use an integer protected by resize_l=
ock.

Yongqiang.
>
> What about your opinion?
>
> Yongqiang.
>
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
