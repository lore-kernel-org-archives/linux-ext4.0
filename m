From: "Andreas Dilger" <adilger@clusterfs.com>
Subject: Re: [PATCH] FLEX_BG Kernel support.
Date: Tue, 11 Sep 2007 00:04:43 -0600
Message-ID: <2aa04ba80709102304i1b054fbbo1d0d4081a86c1580@mail.gmail.com>
References: <20070910212224.13310.54532.stgit@toolssf2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "ext4 development" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43778 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762303AbXIKGEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 02:04:45 -0400
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.186])
	by mail.clusterfs.com (Postfix) with ESMTP id D70CB4E4699
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 00:04:44 -0600 (MDT)
Received: by rv-out-0910.google.com with SMTP id k15so1166529rvb
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 23:04:44 -0700 (PDT)
In-Reply-To: <20070910212224.13310.54532.stgit@toolssf2>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/10/07, Jose R. Santos <jrs@us.ibm.com> wrote:
> @@ -1254,7 +1254,8 @@ static int ext4_check_descriptors (struct super_block * sb)
>
>         for (i = 0; i < sbi->s_groups_count; i++)
>         {
> -               if (i == sbi->s_groups_count - 1)
> +               if (i == sbi->s_groups_count - 1 || EXT4_HAS_INCOMPAT_FEATURE(sb,
> +                                       EXT4_FEATURE_INCOMPAT_FLEX_BG))
>                         last_block = ext4_blocks_count(sbi->s_es) - 1;

No need to check this featyre for every  group, once at the beginning
of the function is enough.
