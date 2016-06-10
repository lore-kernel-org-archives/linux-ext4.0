From: pavi1729 <pavitra1729@gmail.com>
Subject: K3.18-lts : ext4/namei.c: hash used un-initialized
Date: Fri, 10 Jun 2016 12:06:04 +0530
Message-ID: <CAMf7+LitG79FTMdsyAO_xLMGpaZgM02LkEaRJ1EZpu-W+SbU2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34804 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbcFJGgH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2016 02:36:07 -0400
Received: by mail-vk0-f42.google.com with SMTP id e4so85528167vkb.1
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jun 2016 23:36:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

LINK: http://lxr.free-electrons.com/source/fs/ext4/namei.c?v=3.18#L664

static struct dx_frame *
664 dx_probe(const struct qstr *d_name, struct inode *dir,
665          struct dx_hash_info *hinfo, struct dx_frame *frame_in)
666 {
...
...
690         if (d_name)
691                 ext4fs_dirhash(d_name->name, d_name->len, hinfo);
692         hash = hinfo->hash;

Wont 'hash' abve be un-initialized if 'd_name' is NULL OR is 'd_name'
guaranteed to be not NULL
in this call.

Thanks,
Pavi
