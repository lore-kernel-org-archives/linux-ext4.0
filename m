Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A20C00140
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Aug 2022 01:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbiHMBMR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Aug 2022 21:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238008AbiHMBMQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2022 21:12:16 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BDAAA3E2
        for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2022 18:12:16 -0700 (PDT)
Received: from letrec.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 27D1CAoH017229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 21:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1660353132; bh=ku9v+EorGVFZA4ClIh/AoHXx5XUYT3Fj6A9bEo2Sp+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=OSDFjfK+yd8KNvs+PBoUI4G5+GKiZ2dgyXgXcj5unWt5kGZZygwrukqkB+HPWuQ+q
         rapRKLjnxp6QLJ5IKqItHGx/GXVssp+xaPJMWiDQTudq1jFxlBh2QWOV6EPwZX55X3
         RAQG/5cmJRv4GFfhrIcOoq6/+ckrqKVI8ZS9Dmq5E766W6BpUfYBSiXWNThtlU6QVN
         KKuxZhEOLraaqw7mPYl2EU+mseQUITx1dQCaq14YQhkN8/EgTa8ccYObjQjcZ3K6iO
         l/4JVUJGg2vkLGi9KKlmXyqFqhWk6FxHARfIRXHOgYFcOQZSm1gIkw+yqFNqT5m680
         yRhECZJ9d14QA==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 0C2CA8C2DE9; Fri, 12 Aug 2022 21:12:10 -0400 (EDT)
Date:   Fri, 12 Aug 2022 21:12:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@whamcloud.com>
Cc:     linux-ext4@vger.kernel.org, Li Dongyang <dongyangli@ddn.com>
Subject: Re: [PATCH] debugfs: allow <inode> for ncheck
Message-ID: <Yvb6anaiE6p/pzux@mit.edu>
References: <20220301041031.74615-1-adilger@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301041031.74615-1-adilger@whamcloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 28, 2022 at 09:10:31PM -0700, Andreas Dilger wrote:
> If the arg string is of the form <ino>, allow it for ncheck.
> Improve the error message, use "Invalid inode number" instead
> of "Bad inode", which implies the inode content being bad.
> 
> Signed-off-by: Li Dongyang <dongyangli@ddn.com>
> Reviewed-by: Andreas Dilger <adilger@whamcloud.com>

Applied, thanks!

					- Ted
