From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 online resize and robustness to interruption
Date: Mon, 2 Apr 2012 09:23:04 -0600
Message-ID: <CA09C6D2-8159-4F35-9C2C-06A1C0CD0887@dilger.ca>
References: <CAMLZHHSJG8a9Yco7c=Hzd_-HWdSXcHOqMqB5Tvh-U35DDGwMQw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61687 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2DBPUx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 11:20:53 -0400
In-Reply-To: <CAMLZHHSJG8a9Yco7c=Hzd_-HWdSXcHOqMqB5Tvh-U35DDGwMQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-02, at 9:17 AM, Daniel Drake wrote:
> I think this question has been asked before, but I'd like to revisit
> it given the recent rework of ext4 online resizing:
> 
> How robust is ext4 online resize in the face of unexpected
> interruption (i.e. sudden loss of power)?

It used to be the case that resize was totally robust against failure,
when resize was done on a group-by-group basis.  I can't comment on
the behaviour in this respect with the new code, but there is some
concern in my mind because the new code has removed the transaction
commits in the middle of the resize for performance reasons.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





