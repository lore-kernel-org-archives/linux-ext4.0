Return-Path: <SRS0=nvKl=4I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A76C11D0C
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 18:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B86A0208E4
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 18:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBTSWi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:22:38 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35025 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726959AbgBTSWi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Feb 2020 13:22:38 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01KIMVEF003070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 13:22:33 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 60F254211EF; Thu, 20 Feb 2020 13:22:31 -0500 (EST)
Date:   Thu, 20 Feb 2020 13:22:31 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Subject: Re: [PATCH] ext4: fix handling mount -o remount,nolazytime
Message-ID: <20200220182231.GA602834@mit.edu>
References: <158210399258.5335.3994877510070204710.stgit@buzz>
 <20200219162242.GI330201@mit.edu>
 <2326451b-faf2-72a5-cb55-89cb6d8ce9ed@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2326451b-faf2-72a5-cb55-89cb6d8ce9ed@yandex-team.ru>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 20, 2020 at 06:11:04PM +0300, Konstantin Khlebnikov wrote:
> Usually all these options are saved in /etc/fstab and
> mount -o remount,... includes them into line passed into syscall.
> In this case remounting any other option will not disable lazytime.

This assumes that there *is* an /etc/fstab entry.  Sometimes system
administrators will perform ad hoc mounts of devices that aren't
mentioned in /etc/fstab.

For example, consider how xfstests works; it will run mounts commands
mentioning the test and scratch devices which are not mentioned on
/etc/fstab.


						- Ted
