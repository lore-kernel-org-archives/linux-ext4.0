From: Jesper Jensen <linux-ext4_mailinglist@elector.dk>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 06 Nov 2009 12:49:52 +0100
Message-ID: <4AF40D60.1080503@elector.dk>
References: <4AF3F82D.50105@elector.dk> <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sonosmtp2.cybercity.dk ([212.242.41.42]:49489 "EHLO
	sonosmtp2.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbZKFLtr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 06:49:47 -0500
Received: from [192.168.100.10] (unknown [85.82.22.90])
	by sonosmtp2.cybercity.dk (Postfix) with ESMTP id 6FB7EB86E
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2009 12:50:55 +0100 (CET)
In-Reply-To: <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well, I did a mkfs, so as far as I haven't erased the entire content of 
the disk.

Maybe I should mention that the ext4 partition in question is running on 
inside a ESXi with the physical disk formattet to VMFS and mounted in my 
virtual machine (Ubuntu).

It was the physical disk that got formatted by ESXi and I then recreated 
the virtual disk and made a new ext4 filesystem on top of that.

A bit complicated yea, hence why I accidentally used the wrong disk. :-(


Regards
Jesper

Alexey Salmin wrote:
> Have you only repartitioned your disk or also formatted it?
