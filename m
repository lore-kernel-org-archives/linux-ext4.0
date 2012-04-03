From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext4 online resize and robustness to interruption
Date: Tue, 3 Apr 2012 18:58:29 +0800
Message-ID: <CAGBYx2ZjrAXEvfEBSLz7CRsMDB3RSKWg1-8Y7yiJLaRSHSyixA@mail.gmail.com>
References: <CAMLZHHSJG8a9Yco7c=Hzd_-HWdSXcHOqMqB5Tvh-U35DDGwMQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48532 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2DCK6a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2012 06:58:30 -0400
Received: by obbtb18 with SMTP id tb18so3404364obb.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Apr 2012 03:58:29 -0700 (PDT)
In-Reply-To: <CAMLZHHSJG8a9Yco7c=Hzd_-HWdSXcHOqMqB5Tvh-U35DDGwMQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 2, 2012 at 11:17 PM, Daniel Drake <dsd@laptop.org> wrote:
> Hi,
>
> I think this question has been asked before, but I'd like to revisit
> it given the recent rework of ext4 online resizing:
>
> How robust is ext4 online resize in the face of unexpected
> interruption (i.e. sudden loss of power)?
Yep!  It is only robust when journal is used.  In no journal mode, it is not.

Yongqiang.
>
> The context here is that OLPC will now performing an online resize
> upon first boot of the system. Our laptops are frequently used in very
> remote places with unreliable power, and given that we work in large
> numbers, we're going to see some cases where the system lost power
> during the resize operation. What is the expected effect here - will
> the system boot up again just fine (perhaps with the original
> partition size), and is then repeating the resize operation expected
> to be safe and reliable?
>
> Thanks,
> Daniel



-- 
Best Wishes
Yongqiang Yang
