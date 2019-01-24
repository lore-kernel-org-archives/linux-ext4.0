Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED99C282C0
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 01:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5B2A218A1
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 01:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+B9URZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfAXBfB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 20:35:01 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35620 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfAXBfA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 20:35:00 -0500
Received: by mail-qk1-f195.google.com with SMTP id w204so2321323qka.2
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 17:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYqaGyIfPNtwl2wr+4moV1LMEDzofMD1fcYudD4hH8M=;
        b=g+B9URZjjfZdf6rpDoQ0Bg16RdChrMB6CyhA1B4tV34U+++IwpmYl660pcZ8J8d2Le
         HlbXl3ZOVX7hsDgOhTb49E7IyUfo3WrwoZMCpi2VuSmkkvSA1LbgpdMyNvWg+WYW3utS
         z3DmivN1GyJ9nNX8woQA+fL0hhlFfnBajUp77zKfVuP9q3J9niQ7bh+DsAhfj0Wlt1P8
         gtm94Gdnuc2XpV8ii3sWkBue2JWdKNkkbq5dwaGNVHBV+k+8UP1m438vZcgecskgkK9Y
         lJQaum8DN7OdO6k45ATINxHYaWJiHBa+bG3CJ1j7ATLKw/kXGMa/4p+JW9txQwc1yzvu
         ojfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYqaGyIfPNtwl2wr+4moV1LMEDzofMD1fcYudD4hH8M=;
        b=aJfVQnjmNpso3wh5miUwXjEgzLPd2zFBV6ElywHaqy4CXmjS48sjWn+GkOJj2j0BJC
         kbA7fKlJH+1krs60Kok3DgVpOavS6lP1sn5zNp/7KZCKC1fma9wQc8Zcn6xOOtKX55kE
         v+6UmWYY4vccIIadliDKj1Q9NP/VwjFim4tfS/uN5iV33+DkStQmBF43dDaj2ts5+jhS
         qoBuO9U06W8okjK5Cb41L1Hg/JiQKAVKfwzj4IHhEPSGF2+tcBl0GJoTUbrBL9YLHI/t
         FG2I1G5EGmwrCE72muwP7CcVL00w0O9B4YC1AjQGnFEEQHCBFoxBuN4MybFLyZBcmTbN
         MJ/Q==
X-Gm-Message-State: AJcUukdTeYf8iObOKUT8fJVR+XL2NwCXblX623pLBN6TdzJ6FZxGx2dJ
        evreyLtb2s7Tt476jRvYEBcCRW8R+bw5RTyQQ4pOfBQf
X-Google-Smtp-Source: ALg8bN5rVfKRqTRah7tUjG2Qu/VtTTNMcYT+/J5BNoxEMG3UP/VMEGpv3Cv6ifUVZkQcHtXNXq/ZVo4D9IFz1dS9lFQ=
X-Received: by 2002:a37:ea0a:: with SMTP id t10mr3853256qkj.273.1548293699705;
 Wed, 23 Jan 2019 17:34:59 -0800 (PST)
MIME-Version: 1.0
References: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
 <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com> <20190123062737.GC7597@mit.edu>
In-Reply-To: <20190123062737.GC7597@mit.edu>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Wed, 23 Jan 2019 17:34:48 -0800
Message-ID: <CANQeFDCZJunbv-wmLxax9V4PvhN=u7nGc966Xzud2-P8EqBPCw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ext4: fix slow writeback under dioread_nolock and nodelalloc
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Liu Bo <bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 22, 2019 at 10:30 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Sat, Dec 15, 2018 at 01:48:40PM +0800, Xiaoguang Wang wrote:
> > With "nodelalloc", blocks are allocated at the time of writing, and with
> > "dioread_nolock", these allocated blocks are marked as unwritten as well,
> > so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.
>
> I've been looking at your patches, and it seems that a simpler way,
> perhaps more maintainable approach in the long term is to change how
> we write to newly allocated blocks.  Today, we have two ways of doing
> this:
>
> 1) In the dioread_nolock case, we allocate blocks, insert an entry in
> the extent tree with the blocks marked uninitialized, write the
> blocks, and then mark the blocks initialized.
>
> 2) In the !dioread_nolock case, we allocate blocks, insert an entry to
> the extent tree, write the blocks --- and if we start a commit, we
> write out all dirty pages associated with that inode (in the default
> data=writeback case) to avoid stale writes.
>
> So what if we change the dioread_nolock case to do write the blocks
> first, and *then* insert the entry into the extent tree?  This avoids
> stale data getting exposed, either by a direct I/O read, or after a
> crash (which means we avoid needing to do the force write-out).
>
> So what we would need to do is to pass a flag to ext4_map_blocks()
> which causes it to *not* make any on-disk changes.  Instead, it would
> track the fact that blocks have be reserved in the buddy bitmap (this
> is how we prevent blocks from being preallocated after they are
> deleted, but before the transaction has been committed), and the
> location of the assigned blocks in the extent_status tree.  Since no
> on-disk changes are being made, we wouldn't need to hold the
> transaction open.
>
> Then in the callback after the blocks are written, using the starting
> logical block number stored in the io_end structure, we either convert
> the unwritten extents or actually insert the newly allocated blocks in
> the extent tree and update the on-disk bitmap allocation bitmaps.
>
> Once we get this working, it should be easy to make dioread_nolock for
> 1k block sizes; it keeps the time that the handle open very short; and
> it completely obviates the need for data=writeback.
>
> What do folks think?
>

So that (reserve, write, insert extent records) is basically what
btrfs is doing and I feel like it will work better than the current
way.

My only concern is performance since metadata reservation for delalloc
now becomes more and needs to be carried until endio, a perf. spike
would appear if the foreground writer needs to wait for flushing dirty
pages to reclaim metadata credits.

thanks,
liubo
