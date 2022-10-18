Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756EFC4332F
	for <linux-ext4@archiver.kernel.org>; Tue, 18 Oct 2022 21:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiJRVDG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJRVDE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Oct 2022 17:03:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8621AC5103
        for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2022 14:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373D1616EA
        for <linux-ext4@vger.kernel.org>; Tue, 18 Oct 2022 21:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9ACC433C1;
        Tue, 18 Oct 2022 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666126957;
        bh=JDhxV9cE13wlutpbfNljUnqD44+JRDKvWdOIX7KOd/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=idDLL4RT67Sjajpxw+ttUmOc9YmTfDmZqrqlHXN51XeJ41bzqMmUjKERDU7gPUAYt
         tfRRHEUZ/U+aUqw7/ED82CckMzY5/bN7ukjeWfrynZKOQ5rUavxXyZkdpEQt/s16N/
         GY7U3DckdJVdwsEbUbxKvBTYdDCRJh7IwBbH9L6w=
Date:   Tue, 18 Oct 2022 14:02:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kernel test robot <lkp@intel.com>
Cc:     ntfs3@lists.linux.dev, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: [linux-next:master] BUILD REGRESSION
 4ca786ae6681b90b0ec3f4c55c89d12f835f8944
Message-Id: <20221018140236.f55b76d77f5b872edf9bfdce@linux-foundation.org>
In-Reply-To: <634eca23.ML3KLI/hjp2jt28w%lkp@intel.com>
References: <634eca23.ML3KLI/hjp2jt28w%lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 18 Oct 2022 23:45:39 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 4ca786ae6681b90b0ec3f4c55c89d12f835f8944  Add linux-next specific files for 20221018
> 
> ...
>
> mm/mmap.c:802 __vma_adjust() error: uninitialized symbol 'next_next'.
> 

The code's OK but I guess we should make this warning go away.

--- a/mm/mmap.c~a
+++ a/mm/mmap.c
@@ -618,7 +618,8 @@ int __vma_adjust(struct vm_area_struct *
 	struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next_next, *next = find_vma(mm, vma->vm_end);
+	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
+	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
 	struct vm_area_struct *orig_vma = vma;
 	struct address_space *mapping = NULL;
 	struct rb_root_cached *root = NULL;
_


