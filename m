From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/15] ext4: add new online resize interface
Date: Sun, 20 Nov 2011 10:15:12 -0700
Message-ID: <906726DA-EC86-40CB-AB3E-7F3871609BF3@dilger.ca>
References: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com> <E4904E52-7428-478D-AE2E-B29EA825CDB1@gmail.com> <CAGBYx2a0T7sK9REJ8tb_FrVrPDBMfhHZj-mjS1ueSbznQy9JPg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@dilger.ca" <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:26616 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1KTRPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 12:15:15 -0500
In-Reply-To: <CAGBYx2a0T7sK9REJ8tb_FrVrPDBMfhHZj-mjS1ueSbznQy9JPg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-19, at 20:14, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> On Sun, Nov 20, 2011 at 2:13 AM, Andreas Dilger <aedilger@gmail.com> wrote:
>> On 2011-11-19, at 2:57, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>>> 
>>>   Below are benchmarks I made on my personal computer, fses with
>>>   flex_bg size = 16 were resized to 230GB evry time. The first
>>>   row shows the size of a fs from which the fs was resized to 230GB.
>>>   The datas were collected by 'time resize2fs'.
>>> 
>>>                      new resize
>>>                20GB          50GB      100GB
>>>      real    0m3.558s     0m2.891s    0m0.394s
>>>      user    0m0.004s     0m0.000s    0m0.394s
>>>      sys     0m0.048s     0m0.048s    0m0.028s
>>> 
>>>                      current resize
>>>                20GB          50GB      100GB
>>>      real    5m2.770s     4m43.757s  3m14.840s
>>>      user    0m0.040s     0m0.032s   0m0.024s
>>>      sys     0m0.464s     0m0.432s   0m0.324s
>> 
>> These stats must be backward, because resizing 20GB takes more time than resizing 100GB.
> 
> Every time, the filesystem was resized from 20/50/100GB to 230GB, so
> resizing 20GB should takes more time than resizing 100GB.   I am not
> sure what you meant.

Sorry, I didn't read closely enough. I thought it was resizing by the given amount. 

Cheers, Andreas