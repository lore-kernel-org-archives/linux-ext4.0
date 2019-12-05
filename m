Return-Path: <SRS0=pvBj=Z3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE7AC43603
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Dec 2019 15:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C1E206DB
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Dec 2019 15:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfLEPsf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 5 Dec 2019 10:48:35 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33486 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726028AbfLEPsf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Dec 2019 10:48:35 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xB5FmRqt012370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Dec 2019 10:48:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 530F2421A48; Thu,  5 Dec 2019 10:48:27 -0500 (EST)
Date:   Thu, 5 Dec 2019 10:48:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Viliam Lejcik <Viliam.Lejcik@kistler.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: e2fsprogs: setting UUID with tune2fs corrupts an ext4 fs image
Message-ID: <20191205154827.GA35599@mit.edu>
References: <5fd4546cdc7f43f282716afb1e1a18cb@kistler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd4546cdc7f43f282716afb1e1a18cb@kistler.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Dec 05, 2019 at 12:36:35PM +0000, Viliam Lejcik wrote:
> 
> This behavior can be reproduced on an ext4 fs image, so there's no need to run it on the device.

Where can we download or otherwise obtain the image where you are
seeing the problem?

Thanks,

					- Ted
