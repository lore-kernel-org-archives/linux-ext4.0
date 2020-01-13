Return-Path: <SRS0=Aflh=3C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB0DC33CA9
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 23:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15B620678
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAMXdc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Jan 2020 18:33:32 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40300 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728802AbgAMXdc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2020 18:33:32 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DNXPX2021946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 18:33:26 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 685044207DF; Mon, 13 Jan 2020 18:33:25 -0500 (EST)
Date:   Mon, 13 Jan 2020 18:33:25 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Martijn Coenen <maco@android.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, maco@google.com, sspatil@google.com,
        drosen@google.com
Subject: Re: [PATCH] ext4: Add EXT4_IOC_FSGETXATTR/EXT4_IOC_FSSETXATTR to
 compat_ioctl.
Message-ID: <20200113233325.GM76141@mit.edu>
References: <20191227134639.35869-1-maco@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227134639.35869-1-maco@android.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Dec 27, 2019 at 02:46:39PM +0100, Martijn Coenen wrote:
> These are backed by 'struct fsxattr' which has the same size on all
> architectures.
> 
> Signed-off-by: Martijn Coenen <maco@android.com>

Thanks, applied.

						- Ted
