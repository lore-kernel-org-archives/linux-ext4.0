Return-Path: <SRS0=lOxl=45=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345FAC4CECE
	for <linux-ext4@archiver.kernel.org>; Thu, 12 Mar 2020 22:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C2FA206CD
	for <linux-ext4@archiver.kernel.org>; Thu, 12 Mar 2020 22:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lLp+JNv1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCLWLb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:11:31 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39128 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgCLWLb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2020 18:11:31 -0400
Received: by mail-lf1-f66.google.com with SMTP id j15so6229592lfk.6
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2020 15:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+nbJgOAkU3OKGNy5HAiFcAe6BZ2/dfnnfHDkezdsLM=;
        b=lLp+JNv1GIglmiE7sOrC1qiIR92TS5cKLDQInmmSnSrfr1qRJIqEePz4qZzmCMaXQg
         WfjeGL9/4gKBTTDka+GpLlLtpbiD1yloqRAJ0j1uaN1RPyfrSudbA4agtp71u5vQLvVh
         kbfpE2jpEmTv+gLLK2bdDBoWn9tFPGdA8uR+LZOOg0cNSMA//V8Yzq7FYJEWfGS9egxp
         ssrmkKAtsOcFrY+F+ktTdm/G2ys1pRbkX5kFFOvXt+HDZmd1myZbaTJUa01dn3e+L37B
         lhEYR0ODVOxYIzPOrxSPTQoqyVKo30x+HMDzyYjtalF/Xk6Pf7WKXUgxp0pP1/UDQYLp
         ZXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+nbJgOAkU3OKGNy5HAiFcAe6BZ2/dfnnfHDkezdsLM=;
        b=tdCde8YFVU9LFF6XgX3tzUYXpYt9HC6mMEEljFcmTv4eTThk0cjEO8P9yS79ZcyDnj
         DPJ8rya6w8helBJNrhoOVr2ECJP/EC3uwXOeXM7SxFhoMiwNqk9Xho6W61g4Y3l+hptx
         dnaVGbEbhVk4UbQ4NoepFWXQVYUQWFlQfY6MedjDvdB74g73M5MNh+rZCTarL7cdsTtY
         KzIka5RmcxYA8k8bz1dYwCNbRWAOmonGP8JhunijRHTQjnpHnfIyuItG12lBPqzdrQ5+
         pPnkxwiU++n+GOKbSZYu562u6pxFB70NKz/hB2PBNk4XLQ+blevr1AvLO/GT7PuabCXh
         vPdQ==
X-Gm-Message-State: ANhLgQ1FnrBtzpT6jgUF+IOFEaTJWFiX6c9uczFAQmFeLU33QQDpp3j4
        HvCL7QdHCjXmMnEGHv0K4a8Pdo9iTbMyO5Ez8h9YgQ==
X-Google-Smtp-Source: ADFU+vuw+qDSh0ZHQbXiX986v1sXjlwq0l/RRl8ekqAVAeCDt4hyCXShVedgqdcfYfGOHvVzkalKAjAB5l3YONcMxRA=
X-Received: by 2002:a19:4354:: with SMTP id m20mr2516445lfj.166.1584051087657;
 Thu, 12 Mar 2020 15:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200307023611.204708-1-drosen@google.com> <20200307023611.204708-3-drosen@google.com>
 <20200307034850.GH23230@ZenIV.linux.org.uk>
In-Reply-To: <20200307034850.GH23230@ZenIV.linux.org.uk>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Thu, 12 Mar 2020 15:11:16 -0700
Message-ID: <CA+PiJmR=zp9P_Mam2EuVgy-vZftDTGQWuFmuO6asPeU_jEy8OQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/8] fs: Add standard casefolding support
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 6, 2020 at 7:48 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Mar 06, 2020 at 06:36:05PM -0800, Daniel Rosenberg wrote:
>
>         Have you even tested that?  Could you tell me where does the calculated
> hash go?  And just what is it doing trying to check if the name we are about to
> look up in directory specified by 'dentry' might be pointing to dentry->d_iname?

Turns out I tested exactly not that :/ Ran tests on the wrong kernel.
I've fixed my setup so that shouldn't happen again. The calculated
hash there goes exactly nowhere because I failed to copy it back into
the original qstr.
I'm trying to see if the name is a small name, which, if my
understanding is correct, is the only time a name might change from
underneath you in an RCU context. This assumes that the name either
comes from the dentry, or is otherwise not subject to changes. It's
based around the check that take_dentry_name_snapshot does. It does
feel a bit sketchy to assume that, so I'm very open to other
suggestions there.

I'm going through that hassle because the various utf8 functions do a
lot of dereferencing the string and manipulating pointers by those
values, expecting them to be consistent. It might be enough to just go
through that code and add a bunch of checks to make sure we can't
accidentally walk off of either end.
