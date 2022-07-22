Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C70CCA489
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Jul 2022 13:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiGVN7P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Jul 2022 09:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiGVN6v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2022 09:58:51 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC4792869;
        Fri, 22 Jul 2022 06:58:43 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26MDwR84016700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 09:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658498309; bh=7n681hZd+dwrHFbW5+woRzLcfpQI3pxHEssya9/He1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AKyxFvEBnZqeN4JyETkpWdhOS3+uv/c2N2pWZBXPKYloPTW2sQbn8iJUNZeLN0r1E
         1MDb5trwcLkiB80P+6dsI/skKLyNuwMHARZFr/ouTOh+P8cmSwNRJwxH1US0C2R86d
         TCgbWI72sjO3HdJeWKmC4pGYkfrHX8BRR+gKRJSq+AsGUKu9gyOmksJfkY/wdAbd1T
         RZ1NZrP/Awdgvmy+EgnhkBFPZr6tJkkONtrnAJGCghKjglhQmD3yVT2m0nPwPUTwMR
         c4zD7iJOUVShbRhH/bIpe8/uApMiqLlQzFPkRaKEns+4PppuYhdMXYqM8A4djTM183
         usFxghWp9mTLA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6B2BB15C3F00; Fri, 22 Jul 2022 09:58:27 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Date:   Fri, 22 Jul 2022 09:58:14 -0400
Message-Id: <165849767595.303416.835565204310722952.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220712105436.32204-1-jack@suse.cz>
References: <20220712104519.29887-1-jack@suse.cz> <20220712105436.32204-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 12 Jul 2022 12:54:20 +0200, Jan Kara wrote:
> Do not reclaim entries that are currently used by somebody from a
> shrinker. Firstly, these entries are likely useful. Secondly, we will
> need to keep such entries to protect pending increment of xattr block
> refcount.
> 

Applied, thanks!  (Some slight adjustments were needed to resolve a
merge conflict.)

[01/10] mbcache: Don't reclaim used entries
        commit: ee595bcf21a86af4cff673000e2728d61c7c0e7b
[02/10] mbcache: Add functions to delete entry if unused
        commit: ad3923aa44185f5f65e17764fe5c30501c6dfd22
[03/10] ext4: Remove EA inode entry from mbcache on inode eviction
        commit: 428dc374a6cb6c0cbbf6fe8984b667ef78dc7d75
[04/10] ext4: Unindent codeblock in ext4_xattr_block_set()
        commit: d52086dcf26a6284b08b5544210a7475b4837d52
[05/10] ext4: Fix race when reusing xattr blocks
        commit: 132991ed28822cfb4be41ac72195f00fc0baf3c8
[06/10] ext2: Factor our freeing of xattr block reference
        commit: c30e78a5f165244985aa346bdd460d459094470e
[07/10] ext2: Unindent codeblock in ext2_xattr_set()
        commit: 0e85fb030d13e427deca44a95aabb2475614f8d2
[08/10] ext2: Avoid deleting xattr block that is being reused
        commit: 44ce98e77ab4583b17ff4f501c2076eec3b759d7
[09/10] mbcache: Remove mb_cache_entry_delete()
        commit: c3671ffa0919f2d433576c99c4e211cd367afda0
[10/10] mbcache: Automatically delete entries from cache on freeing
        commit: b51539a7d04fb7d05b28ab9387364ccde88b6b6d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
