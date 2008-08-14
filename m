From: Christian Hesse <mail@eworm.de>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 08:13:04 +0200
Message-ID: <200808140813.07567.mail@eworm.de>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <1218672653.6456.14.camel@mingming-laptop> <216e58580808132159y53fc5403xb52839e1be2186a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Mingming Cao" <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, iranna.ankad@in.ibm.com,
	risrajak@in.ibm.com
To: "Dragon kumar" <disaster2008@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:45090 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYHNGNK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 02:13:10 -0400
In-Reply-To: <216e58580808132159y53fc5403xb52839e1be2186a6@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 14 August 2008, Dragon kumar wrote:
> This mail is from < risrajak@in.ibm.com>
> ===============================
>
> Hi Mingming,
>
> Still i am facing the same problem after applying this patch.
>
> Still the same error for me. And it is reproducible.
>
> Step to reproduce:
>    - Create lvm partition with more than 30GB
>    - Copied 6+ GB of file
>    - Tried to remiveing the directory with rm -rf "/mnt/dir_name"
>    - Got the call trace as below.
>
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/mballoc.c:3963!

Hi Dragon,

you missed Ted's first patch I think... Watch out for the first reply to my 
initial mail.
-- 
Regards,
Chris
