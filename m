From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Do we really need parallel resizer?
Date: Sat, 25 Jun 2011 10:42:48 -0600
Message-ID: <606DB4F9-C7D5-4853-B1FB-CF15E96AC037@gmail.com>
References: <BANLkTimYZR2tMABSjAO-pXtatgsz5x0zqQ@mail.gmail.com> <BANLkTinKUgQtLuAybEG6-AKH87jZ4L34kQ@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "adilger@dilger.ca" <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:36671 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1FYQme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jun 2011 12:42:34 -0400
Received: by pzk26 with SMTP id 26so2398428pzk.10
        for <linux-ext4@vger.kernel.org>; Sat, 25 Jun 2011 09:42:33 -0700 (PDT)
In-Reply-To: <BANLkTinKUgQtLuAybEG6-AKH87jZ4L34kQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I don't care particularly about parallel resize being a common usage. My only concern is to prevent filesystem corruption in case it happens by accident.

I'm not sure why you think it is better to have a flag to indicate resize in progress instead of just having a lock.

If you could please explain the benefit of this then it is possible to make a decision on why this code should be changed. 

Cheers, Andreas

On 2011-06-24, at 8:17 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> On Fri, Jun 24, 2011 at 4:41 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> Hi Andreas,
>> 
>> I noticed that resize is protected by resize_lock.  Then parallel
>> resizer works.  However, I think there is no need to make parallel
>> resizer work.
>> 
>> I think we can use an atomic integer 'resize_flag' instead of
>> resize_lock,  resize_flag is set to 1 before the kernel does resizing
>> work,  while resize_flag is set to 0 after the kernel finishes
>> resizing work.  Resizing is allowed only if resize_flag is 0.  If
>> resize_flag is 1, kernel returns -EBUSY to userspace.
> Sorry, I made an error.  we should use an integer protected by resize_lock.
> 
> Yongqiang.
>> 
>> What about your opinion?
>> 
>> Yongqiang.
>> 
>> --
>> Best Wishes
>> Yongqiang Yang
>> 
> 
> 
> 
> -- 
> Best Wishes
> Yongqiang Yang
