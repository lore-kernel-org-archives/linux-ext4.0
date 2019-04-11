Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BA8C10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 10:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2967217D4
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 10:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfDKKAN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:00:13 -0400
Received: from mail.thelounge.net ([91.118.73.15]:15383 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfDKKAN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 06:00:13 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2019 06:00:12 EDT
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 44fx0K5XYXzXMn;
        Thu, 11 Apr 2019 11:42:57 +0200 (CEST)
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. Seeking
 professional help or programming hints for the recovery.
To:     Andrea Lo Pumo <alopumo@movia.biz>, linux-ext4@vger.kernel.org
References: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
 <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <093e8c89-79f7-e207-6cb5-d66dadab60c2@thelounge.net>
Date:   Thu, 11 Apr 2019 11:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



Am 11.04.19 um 11:37 schrieb Andrea Lo Pumo:
> Sorry for writing on this development mailing list, we are seeking an
> expert in ext4, we are also willing to offer a professional contract
> to solve this issue.
> 
> On /dev/sda1(*) there was an ext4 file system with a lot of large
> files. Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The
> result is that now /dev/sda1 is "empty": mounting it shows no files.
> 
> Note *: actually, it is /dev/mapper/secure_storage, an encrypted
> volume opened with LUKS: cryptsetup luksOpen /dev/sda1 secure_storage
> 
> This is my current understanding:
> 
> - Originally, /dev/sda1 was created with "mkfs.ext4 /dev/sda1"
> - Now, the second "mkfs.ext4 /dev/sda1" has overwritten the
> superblock, and all backups of the superblock (because it has created
> the backups of the NEW superblock at the exact same locations of the
> previous superblock backups)

no

you said you had a LUKS volume on /dev/sda1 which means by directly
create a fs on /dev/sda1 you have overwritten parts of the encryption
layer *and* at the same time the filesystem *on top* of it

in other words: you are done, can stop seek solutions and start restore
your backups

