Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82CDC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 14:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9365720872
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 14:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfCROfj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:35:39 -0400
Received: from mail.worldserver.net ([217.13.200.37]:52961 "EHLO
        mail.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbfCROfj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 10:35:39 -0400
Received: from mail.nebelschwaden.de (port-92-193-52-77.dynamic.qsc.de [92.193.52.77])
        (Authenticated sender: postmaster@nebelschwaden.de)
        by mail.worldserver.net (Postfix) with ESMTPSA id 7B88D300525
        for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2019 15:35:36 +0100 (CET)
Received: from [172.16.37.5] (kaperfahrt.nebelschwaden.de [172.16.37.5])
        by mail.nebelschwaden.de (Postfix) with ESMTP id C655B506D4B
        for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2019 15:35:37 +0100 (CET)
Reply-To: listac@nebelschwaden.de
Subject: Re: e2fsck fails on non journalled partition
From:   Ede Wolf <listac@nebelschwaden.de>
To:     linux-ext4@vger.kernel.org
References: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
 <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
 <c2be64f5-d0fc-f66b-36ab-ab601301cbed@nebelschwaden.de>
 <20190317215315.GD23356@mit.edu>
 <4868703d-f937-5e3d-3336-1e6247001435@nebelschwaden.de>
Message-ID: <aa54941f-05d3-45f5-b805-bad895e91e7d@nebelschwaden.de>
Date:   Mon, 18 Mar 2019 15:35:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <4868703d-f937-5e3d-3336-1e6247001435@nebelschwaden.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> Further, currently after each mount tune2fs reports a "not clean" 
> Filesystem state. 
My bad, this is of course just the indicator wether the drive has been 
unmouted cleanly or not. I've messed this up with the other message 
saying something like "48 error have occured since last check"

