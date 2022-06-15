Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56F7CCA47F
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jun 2022 08:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbiFOIOT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Jun 2022 04:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343909AbiFOIOS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2022 04:14:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E140921E0B;
        Wed, 15 Jun 2022 01:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D27A61949;
        Wed, 15 Jun 2022 08:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82B7C34115;
        Wed, 15 Jun 2022 08:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655280856;
        bh=k+3SUrAPzRklM1OSV+O/gZAPfDFx88kiFdDt9TP8wi0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=t5unw6qXFjXOZXP3wCnQaVCCZRKnjr3Y7yDD2CCdvPV0FgCG0ZLsOu91d+vP0jN8z
         fmsHRt4/NdxKkEzsf/E6WIZCC7GTcM6NfrbhS9Dz053s2pzeGosoG4/R//xZBa9aDV
         eFh8WtHkVtDTZ2VE/hmqF/sZ1gr8DjkHI9ZAl5d+elWRdNudKVDbMD2ohPrjCQPuvo
         V4oVDwMuUanM4M3NjQvbKBGCN+3dpLTTVSGBr5OEIvX34y2mvIQT8c9GxIzABbihT9
         bLKhsokce4riUp5mQRw77bqwDdnJ3CEi+CEiZVVeIyEwtpdO+AUGC5cMmTspYWtUqZ
         C8r+3BE454s5A==
Message-ID: <c4db5f98-6b00-99e6-ecf2-63372f20c516@kernel.org>
Date:   Wed, 15 Jun 2022 16:14:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [f2fs-dev] [PATCH 05/10] f2fs: Convert
 f2fs_invalidate_compress_pages() to use filemap_get_folios()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org
Cc:     linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-6-willy@infradead.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220605193854.2371230-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2022/6/6 3:38, Matthew Wilcox (Oracle) wrote:
> Convert this function to use folios throughout.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,
