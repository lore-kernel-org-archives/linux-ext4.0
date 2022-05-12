Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD5FC433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 12 May 2022 14:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355621AbiELOwl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 12 May 2022 10:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355614AbiELOwk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2022 10:52:40 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708052532F1
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2022 07:52:39 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24CEqYAX030648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 10:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652367155; bh=sfGRZEPiH7aQiTvEgnoKkzq5KE51aZY8nSQD6Y5Ilxs=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=j20gLp0HYq1cqc3oApXMS8IIb/LLn09QyV8Zi3LhvbVi4mlcoFnvo2TeDD2f8QdP4
         /S+BeaU5o6OQqaIZngdjoi9cvJsJ5tdDbJ8Yzdbd0h8YFtMd3Fg8dFP2momel9uecH
         Ue4VUt/jQWGNvZzhw9zGlFZ6NTPuZAu0LtSBlQWeqmNhSWosF0YQN8fbd3YoxHRQ9c
         BvwF8MLaip5Eg7uABOACO5xegkO+A7pvSyqOn0nUZxYvkQLfUccDl1A+7ui3omwY+I
         1FKQVDxJQm0a/wA5id6ya8ZgGOkR2dt9qwVr54hnDllHll8+CJEIH82npi9zrR1LcJ
         +X7Retd1OUw6A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6537415C3F2A; Thu, 12 May 2022 10:52:34 -0400 (EDT)
Date:   Thu, 12 May 2022 10:52:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Vincent Lefevre <vincent@vinc17.net>, linux-ext4@vger.kernel.org
Subject: Re: ext4: unexpected delayed file creation with a 5.17 kernel
Message-ID: <Yn0fMj0jXPrMIZd9@mit.edu>
References: <20220511135917.GA3381602@zira.vinc17.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511135917.GA3381602@zira.vinc17.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, May 11, 2022 at 03:59:17PM +0200, Vincent Lefevre wrote:
> Hi,
> 
> On a Linux machine (12-core x86_64 Debian/unstable, 5.17 kernel)
> with an ext4 filesystem, I got a file born 30 seconds after its
> actual creation by a script. This is completely unreproducible.

completely *reproducible* or *unreproducible*?

If it is completely reproducible, can you try to reduce your shell
script to a minimal reproducer?

					- Ted
