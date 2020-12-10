Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A96EC4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20A4123D9A
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404229AbgLJUjV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404526AbgLJUjG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2020 15:39:06 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB54C0613D6
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2020 12:38:26 -0800 (PST)
Received: from localhost (unknown [IPv6:2804:14c:132:242d::1000])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id A4C361F45C51;
        Thu, 10 Dec 2020 20:38:23 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Arnaud Ferraris <arnaud.ferraris@collabora.com>
Cc:     linux-ext4@vger.kernel.org, drosen@google.com, ebiggers@kernel.org,
        tytso@mit.edu
Subject: Re: [PATCH RESEND v2 05/12] e2fsck: add new problem for casefolded
 name check
Organization: Collabora
References: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
        <20201210150353.91843-6-arnaud.ferraris@collabora.com>
Date:   Thu, 10 Dec 2020 17:38:18 -0300
In-Reply-To: <20201210150353.91843-6-arnaud.ferraris@collabora.com> (Arnaud
        Ferraris's message of "Thu, 10 Dec 2020 16:03:46 +0100")
Message-ID: <87eejx2y85.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Arnaud Ferraris <arnaud.ferraris@collabora.com> writes:

> ---
> Changes in v2:
>   - added in this version
>
>  e2fsck/problem.c | 5 +++++
>  e2fsck/problem.h | 3 +++
>  2 files changed, 8 insertions(+)
>
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index e79c853b..2b596303 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1805,6 +1805,11 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("Encrypted @E references @i %Di, which has a different encryption policy.\n"),
>  	  PROMPT_CLEAR, 0, 0, 0, 0 },
>  
> +	/* Casefolded directory entry has illegal characters in its name */
> +	{ PR_2_BAD_CASEFOLDED_NAME,
> +	  N_("@E has illegal UTF-8 characters in its name.\n"),
> +	  PROMPT_FIX, 0, 0, 0, 0 },
> +
>  	/* Pass 3 errors */
>  
>  	/* Pass 3: Checking directory connectivity */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 4185e517..a8806fd4 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -1028,6 +1028,9 @@ struct problem_context {
>  /* Encrypted directory contains file with different encryption policy */
>  #define PR_2_INCONSISTENT_ENCRYPTION_POLICY	0x020052
>  
> +/* Casefolded directory entry has illegal characters in its name */
> +#define PR_2_BAD_CASEFOLDED_NAME		0x0200053

Also, PR_2_BAD_ENCODED_NAME makes more sense than CASEFOLDED.  The
name is encoded in utf-8 but not casefolded on-disk.

> +
>  /*
>   * Pass 3 errors
>   */

-- 
Gabriel Krisman Bertazi
