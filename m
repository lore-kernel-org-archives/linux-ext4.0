Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D9CC433DB
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Feb 2021 04:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D56364E55
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Feb 2021 04:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBLEOf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Feb 2021 23:14:35 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36703 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229493AbhBLEOe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2021 23:14:34 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 11C4DV9E031362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 23:13:33 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4A65115C3601; Thu, 11 Feb 2021 23:13:31 -0500 (EST)
Date:   Thu, 11 Feb 2021 23:13:31 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Iurii Zaikin <yzaikin@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] ext: EXT4_KUNIT_TESTS should depend on EXT4_FS
 instead of selecting it
Message-ID: <YCYAa8ZJHn5uJMj/@mit.edu>
References: <20210122110234.2825685-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122110234.2825685-1-geert@linux-m68k.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 22, 2021 at 12:02:34PM +0100, Geert Uytterhoeven wrote:
> EXT4_KUNIT_TESTS selects EXT4_FS, thus enabling an optional feature the
> user may not want to enable.  Fix this by making the test depend on
> EXT4_FS instead.
> 
> Fixes: 1cbeab1b242d16fd ("ext4: add kunit test for decoding extended timestamps")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.

					- Ted
