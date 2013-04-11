From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: something's using space, can't figure out what - how to debug?
Date: Thu, 11 Apr 2013 11:31:21 +0900
Message-ID: <20130411113121.3851279e@wpkg.org>
References: <20130410195606.22a9eff3@wpkg.org>
	<20130411002643.GA10594@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:38980 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762074Ab3DKCbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 22:31:35 -0400
In-Reply-To: <20130411002643.GA10594@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Apr 2013 20:26:43 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> On Wed, Apr 10, 2013 at 07:56:06PM +0900, Tomasz Chmielewski wrote:
> > # lsof -n|grep /srv
> > # 
> > 
> > 
> > So df says 134 GB is used, while du says 60 GB is used.
> > No removed but used files, according to lsof.
> > 
> > How do I best debug what happened to ~70 GB?
> 
> Well, nothing is using /srv, so why don't you unmount it and run
> "e2fsck -f /dev/xvdf", and see e2fsck reports in terms of the number
> of blocks in use, i.e:
> 
> /dev/lambda/backup: 581320/4915200 files (0.1% non-contiguous),
> 6837767/19660800 blocks

If it was only so easy!

# lsof -n|grep /srv

# fuser /srv

# ls /sys/block/xvdf/holders/

# umount /srv
umount: /srv: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

Yet after reboot, back to normal:

root@ec2:~# df -h /srv
Filesystem            Size  Used Avail Use% Mounted on
/dev/xvdf             194G   62G  123G  34% /srv


-- 
Tomasz Chmielewski
http://www.ptraveler.com
