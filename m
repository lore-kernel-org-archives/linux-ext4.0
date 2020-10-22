Return-Path: <SRS0=W+FO=D5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C6DC388F2
	for <linux-ext4@archiver.kernel.org>; Thu, 22 Oct 2020 03:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3654821534
	for <linux-ext4@archiver.kernel.org>; Thu, 22 Oct 2020 03:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="k5s1Iwi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895404AbgJVD3W (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 21 Oct 2020 23:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895402AbgJVD3V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2020 23:29:21 -0400
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75858C0613CE
        for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2020 20:29:21 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id A1EFA2E0A46;
        Thu, 22 Oct 2020 06:29:19 +0300 (MSK)
Received: from sas1-b105e6591dac.qloud-c.yandex.net (sas1-b105e6591dac.qloud-c.yandex.net [2a02:6b8:c08:4790:0:640:b105:e659])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id zjk7nxOrct-TJw8mgub;
        Thu, 22 Oct 2020 06:29:19 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603337359; bh=V1asGq+k+cRKoVzrKZklU8SufB/FgtkUXvusVmCBErU=;
        h=Message-ID:In-Reply-To:Subject:To:From:References:Date:cc;
        b=k5s1Iwi22AvAGHGQFiNuXwLiXGe37xcX/y9oY9Erhsduu1FLrKJIvStoPX26lCNwm
         xorZDjoxJfsm2DsWafJCz4xfhQEx6zqfzVCUDf8Lt6zGMtcBYq53XOYf4Gd1ABYbK/
         3FH9klytCXJG0o7JRzqyjXkucrC/HxH0VjnJk3PE=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:416::1:0])
        by sas1-b105e6591dac.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id y3pQzjI6Af-TImelraD;
        Thu, 22 Oct 2020 06:29:19 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 22 Oct 2020 06:29:18 +0300 (MSK)
From:   Roman Anufriev <dotdot@yandex-team.ru>
X-X-Sender: dotdot@dotdot-osx
To:     Jan Kara <jack@suse.cz>
cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        dmtrmonakhov@yandex-team.ru
Subject: Re: [PATCH v2 2/2] ext4: print quota journalling mode on
 (re-)mount
In-Reply-To: <20201019095259.GD30825@quack2.suse.cz>
Message-ID: <alpine.OSX.2.23.453.2010220623440.1375@dotdot-osx>
References: <1602986547-15886-1-git-send-email-dotdot@yandex-team.ru> <1602986547-15886-2-git-send-email-dotdot@yandex-team.ru> <20201019095259.GD30825@quack2.suse.cz>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, 19 Oct 2020, Jan Kara wrote:

> On Sun 18-10-20 05:02:27, Roman Anufriev wrote:
>> Right now, it is hard to understand what quota journalling type is enabled:
>> you need to be quite familiar with kernel code and trace it or really
>> understand what different combinations of fs flags/mount options lead to.
>>
>> This patch adds printing of current quota jounalling mode on each
>> mount/remount, thus making it easier to check it at a glance/in autotests.
>> The semantics is similar to ext4 data journalling modes:
>>
>> * journalled - quota accounting and journaling are enabled
>> * writeback  - quota accounting is enabled, but journalling is disabled
>
> The above two descriptions are still somewhat misleading - in fact we don't
> know whether accounting is enabled or not. Just *if* it is enabled, quota
> will be journalled / non-journalled. So I'd probably describe it like:
> * journalled - quota configured, journalling will be enabled
> * writeback - quota configured, journalling will be disabled

Yeah, you are right, I'll fix this in v4.

> We've talked with Ted on last ext4 conf call and we agreed that it's
> probably time to deprecate old style quotas in external quota files and
> transition everybody to using quotas with quota feature. That way things
> will get simpler again. But before we can disable that functionality, it
> will take a few years of deprecation warnings etc. so that's not directly
> related to your patch here. JFYI.

It will be great!

 								Roman
