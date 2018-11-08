Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.thelounge.net ([91.118.73.15]:54927 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbeKIE1c (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2018 23:27:32 -0500
Subject: Re: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
To: Elana Hashman <Elana.Hashman@twosigma.com>,
        "'tytso@mit.edu'" <tytso@mit.edu>
Cc: "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
From: Reindl Harald <h.reindl@thelounge.net>
Message-ID: <8ac9d2e2-f462-2b8d-d10e-93f065528009@thelounge.net>
Date: Thu, 8 Nov 2018 19:13:36 +0100
MIME-Version: 1.0
In-Reply-To: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Am 08.11.18 um 18:59 schrieb Elana Hashman:
> After a reboot, `df` reflects real utilization:
> 
> $ df -h /
> Filesystem                                              Size  Used Avail Use% Mounted on
> /dev/disk/by-uuid/<some-uuid>   50G   16G   31G  34% /
> 
> We are using overlay2fs for Docker, as well as rbd mounts; I'm not sure how they might interact.

and what says "df -hi"?
maybe you are running simply out of inodes
