From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: ext4: Onchange?
Date: Mon, 1 May 2017 15:16:49 -0500
Message-ID: <43a16920-d966-7eba-1404-92a4c63c68a4@redhat.com>
References: <188768648.246792.1493668310841@mail.vodafone.de>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Dietrich Hoppe <dietrich.hoppe@arcor.de>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750802AbdEAURa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 May 2017 16:17:30 -0400
In-Reply-To: <188768648.246792.1493668310841@mail.vodafone.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/1/17 2:51 PM, Dietrich Hoppe wrote:
> Hi,
> 
> is there any way to register an OnChange-function, that is called by
> the ext4 file system whenever a change occurs (i.e. create, delete,
> rename, move a file).
> 
> Regards Dietrich Hoppe
> 

Take a look at inotify in the linux kernel

https://lwn.net/Articles/604686/
https://en.wikipedia.org/wiki/Inotify
http://www.lanedo.com/filesystem-monitoring-linux-kernel/

etc

-Eric
