Return-Path: <SRS0=pBXC=6Z=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33CAC47255
	for <linux-ext4@archiver.kernel.org>; Mon, 11 May 2020 15:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA32206DB
	for <linux-ext4@archiver.kernel.org>; Mon, 11 May 2020 15:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgEKPjw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 May 2020 11:39:52 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50835 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730084AbgEKPjv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2020 11:39:51 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04BFdPVD011857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 11:39:26 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9DD554202E4; Mon, 11 May 2020 11:39:25 -0400 (EDT)
Date:   Mon, 11 May 2020 11:39:25 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     adilger.kernel@dilger.ca, john.johansen@canonical.com,
        jmorris@namei.org, serge@hallyn.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-security-module@vger.kernel.org, elver@google.com,
        davidgow@google.com
Subject: Re: [PATCH v3 5/6] fs: ext4: default KUNIT_* fragments to
 KUNIT_ALL_TESTS
Message-ID: <20200511153925.GA1331920@mit.edu>
References: <20200511131438.29953-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511131438.29953-1-anders.roxell@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 11, 2020 at 03:14:38PM +0200, Anders Roxell wrote:
> This makes it easier to enable all KUnit fragments.
> 
> Adding 'if !KUNIT_ALL_TESTS' so individual tests can not be turned off.
> Therefore if KUNIT_ALL_TESTS is enabled that will hide the prompt in
> menuconfig.
> 
> Reviewed-by: David Gow <davidgow@google.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Acked-off-by: Theodore Ts'o <tytso@mit.edu>
