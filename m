Return-Path: <SRS0=QBe5=5L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5DBC43331
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Mar 2020 17:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB2B20737
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Mar 2020 17:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgCZRZ4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Mar 2020 13:25:56 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51182 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgCZRZz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Mar 2020 13:25:55 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 9435F297962
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 11/11] tests: f_bad_fname: Validate fix of invalid  filenames and duplicates
Organization: Collabora
References: <20200325211812.2971787-1-krisman@collabora.com>
        <20200325211812.2971787-13-krisman@collabora.com>
Date:   Thu, 26 Mar 2020 13:25:51 -0400
In-Reply-To: <20200325211812.2971787-13-krisman@collabora.com> (Gabriel
        Krisman Bertazi's message of "Wed, 25 Mar 2020 17:18:12 -0400")
Message-ID: <85lfnnm3j4.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> writes:

> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Hm, this was a left over in my patches/ directory.  Please ignore this
duplicated patch in this series.

-- 
Gabriel Krisman Bertazi
