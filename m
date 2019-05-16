Return-Path: <SRS0=9AJ9=TQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D84C04AB4
	for <linux-ext4@archiver.kernel.org>; Thu, 16 May 2019 08:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F6A2082E
	for <linux-ext4@archiver.kernel.org>; Thu, 16 May 2019 08:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEPIJo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 May 2019 04:09:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:54412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfEPIJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 May 2019 04:09:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CA9DABB1;
        Thu, 16 May 2019 08:09:42 +0000 (UTC)
Date:   Thu, 16 May 2019 10:09:42 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jack@suse.cz,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic, fsync fuzz tester with fsstress
Message-ID: <20190516080942.GB3922@x250.microfocus.com>
References: <20190515150221.16647-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190515150221.16647-1-fdmanana@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, May 15, 2019 at 04:02:21PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
Nit:
> This tes has found already 2 bugs in btrfs, that caused mtime and ctime of
  test? ^

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
