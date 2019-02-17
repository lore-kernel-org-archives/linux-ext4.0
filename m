Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D18C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E941D217FA
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaPgVAVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfBQU3T (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:29:19 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33373 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfBQU3T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2019 15:29:19 -0500
Received: by mail-qk1-f193.google.com with SMTP id x9so8911615qkf.0;
        Sun, 17 Feb 2019 12:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=aXPCBc7JQbV80aT2PtPXPjyvlIynzn619F7DfgeqJH4=;
        b=jaPgVAVLbMJ0AKPP81s99XN+AidrxZH0Iqnh7LWPKqSgLxp1mZ0qC1HT/JylV6Sus8
         LNtjPmWTzIQd15TXj+YsyiBRWi8KQd7Bir5uLb0qkKPjzMbfp3ywmqGLT6Qr84W5Q+cW
         5Hm+hvtUuFevOMIy+vu4R4YGGXDsttxqUPt/OIN7V5BSjyguGGiKEVIz/aXJy8AQF3I3
         8QygHkoCTdjjt1xWCXuWUkINxs7xpsH3kwRrd7jwU2OteiAJo8w66peBqD/xprGO4ewS
         H99fL4DO41LsEej/poBEpzb3p9QmKhv/SN1eKAz8LlcUSS1aRGOcCeaIxRpNATIIHSsF
         yySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aXPCBc7JQbV80aT2PtPXPjyvlIynzn619F7DfgeqJH4=;
        b=RS2b/1CDaPUTEqPveJGX/+fxPZt9uTd0cUPh42PQujXg/1h0lAeJekVIMnSUVsmv8L
         bEWJGk92+PmkFSuEfkcnCrc/c/3KOLCgxIiByeNDA23SqcqOa5u+v6IJORRXH3ICSzvU
         cN2LAprrHLjUGfwrkYb8uJJv2zFUzQ5uwTZrEDO6DDBH/7ZwjQpGT09YfPS1T+i0oPA+
         6UgM0BF1lWQzBzJviPgwHH/vifkAxoAxb07/j8wILpxSF84f/SPRVZMABBjnMb9kVA2E
         m0tqvRcn9bfIqxhPoEOGZyGx9NQumN/kx2uSuVwM2xe7qucnpJgz5pYkj0QzhRs0MmV6
         RwfA==
X-Gm-Message-State: AHQUAuZCdfhS9UuoOzfuzd+7emuXaDjLG1MvwVu0dJ/aBjMs6OI2zAMS
        bFLJanYuPMyxEBK5NvlroqHHhcoj
X-Google-Smtp-Source: AHgI3IZyGptNBxL9wNnSruTuTdnuD+ZVO15dEegf2rTIbp+dKPFr/S44lR6kkuc92iunryCQn+JBWQ==
X-Received: by 2002:ae9:d8c2:: with SMTP id u185mr13743768qkf.107.1550435356819;
        Sun, 17 Feb 2019 12:29:16 -0800 (PST)
Received: from [192.168.1.204] (pool-108-7-72-149.bstnma.fios.verizon.net. [108.7.72.149])
        by smtp.gmail.com with ESMTPSA id g49sm8305772qtg.24.2019.02.17.12.29.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 12:29:15 -0800 (PST)
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
To:     Dan Williams <dan.j.williams@intel.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
From:   Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
Date:   Sun, 17 Feb 2019 15:29:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/6/19 4:12 PM, Dan Williams wrote:
> Before people get too excited this isn't a proposal to kill DAX. The
> topic proposal is a discussion to resolve lingering open questions
> that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
> current DAX facilities are enabled. The are 2 primary concerns to
> resolve. Enumerate the remaining features/fixes, and identify a path
> to implement it all without regressing any existing application use
> cases.
>
> An enumeration of remaining projects follows, please expand this list
> if I missed something:
>
> * "DAX" has no specific meaning by itself, users have 2 use cases for
> "DAX" capabilities: userspace cache management via MAP_SYNC, and page
> cache avoidance where the latter aspect of DAX has no current api to
> discover / use it. The project is to supplement MAP_SYNC with a
> MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
> dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
> application hint to avoid / minimiize page cache usage, but no strict
> guarantee like what MAP_SYNC provides.


Sounds like a great topic to me. Having just gone through a new round of USENIX 
paper reviews, it is interesting to see how many academic systems are being 
pitched in this space (and most of them don't mention the kernel based xfs/ext4 
with dax).

Regards,

Ric


>
> * Resolve all "if (dax) goto fail;" patterns in the kernel. Outside of
> longterm-GUP (a topic in its own right) the projects here are
> XFS-reflink and XFS-realtime-device support. DAX+reflink effectively
> requires a given physical page to be mapped into two different inodes
> at different (page->index) offsets. The challenge is to support
> DAX-reflink without violating any existing application visible
> semantics, the operating assumption / strawman to debate is that
> experimental status is not blanket permission to go change existing
> semantics in backwards incompatible ways.
>
> * Deprecate, but not remove, the DAX mount option. Too many flows
> depend on the option so it will never go away, but the facility is too
> coarse. Provide an option to enable MAP_SYNC and
> more-likely-to-do-something-useful-MAP_DIRECT on a per-directory
> basis. The current proposal is to allow this property to only be
> toggled while the directory is empty to avoid the complications of
> racing page invalidation with new DAX mappings.
>
>
> Secondary projects, i.e. important but I would submit are not in the
> critical path to removing the "experimental" designation:
> * Filesystem-integrated badblock management. Hook up the media error
> notifications from libnvdimm to the filesystem to allow for operations
> like "list files with media errors" and "enumerate bad file offsets on
> a granulatiy smaller than a page". Another consideration along these
> lines is to integrate machine-check-handling and dynamic error
> notification into a filesystem interface. I've heard complaints that
> the sigaction() based mechanism to receive BUS_MCEERR_* information,
> while sufficient for the "System RAM" use case, is not precise enough
> for the "Persistent Memory / DAX" use case where errors are repairable
> and sub-page error information is useful.
>
> * Userfaultfd for file-backed mappings and DAX
>
>
> Ideally all the usual DAX, persistent memory, and GUP suspects could
> be in the room to discuss this:
> * Jan Kara
> * Dave Chinner
> * Christoph Hellwig
> * Jeff Moyer
> * Johannes Thumshirn
> * Matthew Wilcox
> * John Hubbard
> * Jérôme Glisse
> * MM folks for the reflink vs 'struct page' vs Xarray considerations


