Return-Path: <SRS0=XCVG=P4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE41C61CE4
	for <linux-ext4@archiver.kernel.org>; Sun, 20 Jan 2019 11:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3FA2084C
	for <linux-ext4@archiver.kernel.org>; Sun, 20 Jan 2019 11:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbfATLfx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:35:53 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:32026 "EHLO smtp6-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbfATLfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 20 Jan 2019 06:35:53 -0500
Received: from localhost.localdomain (unknown [88.185.151.243])
        by smtp6-g21.free.fr (Postfix) with ESMTPS id D66DB780346
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jan 2019 12:35:51 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D0A3B4003B; Sun, 20 Jan 2019 12:35:50 +0100 (CET)
Date:   Sun, 20 Jan 2019 12:35:50 +0100
From:   Etienne Buira <etienne.buira@free.fr>
To:     linux-ext4@vger.kernel.org
Subject: Re: ext4fs block role, debugfs testb and icheck mismatch
Message-ID: <20190120113550.GB20263@Z926fQmE5jqhFMgp6>
References: <20190116213423.GA20263@Z926fQmE5jqhFMgp6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116213423.GA20263@Z926fQmE5jqhFMgp6>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 16, 2019 at 10:34:23PM +0100, Etienne Buira wrote:
> For the background: i've hit defect sectors (on part of md array), and i
> want to rewrite those sectors to force hdd reallocation, so i need to
> figure out what they are used for.

Hi,

I could resolve my issue, i was wrong on block number.

What's left is the weird behaviour of debugfs, which reports a given
block as "in use", and not linked to any inode (although it is in data
part):

> Unrolling the layers under fs, i'm interested in a 4K blocks range that
> starts at 2035, here starts the trouble:
> debugfs 1.43.9 (8-Feb-2018)
> debugfs:  testb 2035
> Block 2035 marked in use
> debugfs:  icheck 2035
> Block   Inode number
> 2035    <block not found>
> 
> From this result, i tried to figure out if this block were used for fs
> internal structures.
> Using dumpe2fs, i see that this block belongs to group 0, and falls
> beyond fs structures (last block for inode table is reported as 1568).
> Block 2035 is not reported as free blocks.

The debugfs queries have been done multiple times, so it is quite
unprobable fs allocated this block everytime before i issued testb,
and released it by the time i issued icheck.

Regards.

