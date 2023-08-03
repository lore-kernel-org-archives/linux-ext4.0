Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C87EB64DD
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Aug 2023 14:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbjHCOTq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbjHCOTp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Aug 2023 10:19:45 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF756DA
        for <linux-ext4@vger.kernel.org>; Thu,  3 Aug 2023 07:19:43 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 373EJZiX032677
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Aug 2023 10:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691072378; bh=u4qHYJE09OQX4SslI8PJB7iPS5V/V9gm5lYUAJt9N6k=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=OXFtXbrHOTCjpsVqNAYiU9LyaKF4ubW5qdOU7GRoW1XJVquHUB1bKIsxg+ev5q2Ou
         rAik2WQdcYVV6Kn7orlC4J9zlaVvHoe/yBDf2h77+WIpjE8+GKrrJ3lSUrxjLyfkUP
         oR9HAUL65ah6/LLTloEU+446u5hc3SHAwxiKGX+PTbhmQcijFCizj+gFk7fkFHybB2
         W8GYQIhH1p465sJdule/PJpNSBVwTYSE0/NcR1MeeIMBjwIkHkjDr6CNK0SmHnJyPI
         ZYbOhKWfgUzNJGe205v6vdDZUhIIUrCexIbpPyri+kVBr+vh4VLu3/PBjkMX/Hgm5I
         +ehBz1L7G5RWQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A4F6815C04F1; Thu,  3 Aug 2023 10:19:35 -0400 (EDT)
Date:   Thu, 3 Aug 2023 10:19:35 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v6 6/7] ext4: switch to multigrain timestamps
Message-ID: <20230803141935.GA1054657@mit.edu>
References: <20230725-mgctime-v6-0-a794c2b7abca@kernel.org>
 <20230725-mgctime-v6-6-a794c2b7abca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725-mgctime-v6-6-a794c2b7abca@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jul 25, 2023 at 10:58:19AM -0400, Jeff Layton wrote:
> Enable multigrain timestamps, which should ensure that there is an
> apparent change to the timestamp whenever it has been written after
> being actively observed via getattr.
> 
> For ext4, we only need to enable the FS_MGTIME flag.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>
