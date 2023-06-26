Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABD6EB64DA
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Jun 2023 09:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjFZJ1a (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjFZJ1J (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2023 05:27:09 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Jun 2023 02:24:00 PDT
Received: from mail.xolti.net (master.xolti.net [IPv6:2001:41d0:404:200::1c23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CD5010CB
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2023 02:23:59 -0700 (PDT)
Received: from [9.150.147.77] (unknown [129.41.47.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.xolti.net (Postfix) with ESMTPSA id 5308315DB
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2023 11:15:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.xolti.net 5308315DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=robertoragusa.it;
        s=default; t=1687770916;
        bh=hU1yskoK6zpdJ8BewYHb3rh71+PHK8DUFoTRU2g1OCE=;
        h=Date:To:From:Subject:From;
        b=o0z2sn5ep8Q8WWysRsgKHZ85qDBdg2RsalnSptCoVTim8MB+YVcV86OYTpqy2zE4s
         bkwOemtPA9YG1wwp9cLg/jB/mIu6guaztIXqwRTCuAzC5vZwI0cOyF3Sz9t6XpYCpy
         kOShgMeb5U1GtqwYdTshFGwnDjRY4FDmo45TChr8=
Message-ID: <49752bf2-71ec-7fbf-dcdf-93940cfa92c9@robertoragusa.it>
Date:   Mon, 26 Jun 2023 11:15:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From:   Roberto Ragusa <mail@robertoragusa.it>
Subject: packed_meta_blocks=1 incompatible with resize2fs?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

by using

mkfs.ext4 -E packed_meta_blocks=1

all the fs metadata is placed at the start of the disk.
Unfortunately I have not found a way to enlarge the fs
and maintain this property, new metadata is allocated from the
added space.

My attempts to work around the issue have failed:
- adding resize=4290772992 in mkfs doesn't help
- creating a bigger fs with packed_meta_blocks, then shrinking it,
then re-extending it to the original size still allocates from the
new space

Is there a way to have metadata at the beginning of the disk
and be able to enlarge the fs later?
Planning to do this on big filesystems, placing the initial part
on SSD extents; reformat+copy is not an option.

This mailing list appears the best place to ask, sorry if this is
considered off topic.
Thanks.

-- 
    Roberto Ragusa    mail at robertoragusa.it
