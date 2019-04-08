Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A5C10F13
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5C320863
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 11:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="kg2uYfcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfDHLOx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:14:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41020 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHLOx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 07:14:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id r4so15857754wrq.8
        for <linux-ext4@vger.kernel.org>; Mon, 08 Apr 2019 04:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=CbyJPvhn+rM4XFjJsBw6dpHXIScUz8tfnRZrbPPktCM=;
        b=kg2uYfcnHjd8nx8ZapVPtxpMJ7SzrY89s7q12sHIM1vsHs1EPEv1FSPaikbSelFOF7
         UBbTGY5mVKTvFPLj+lDFAgSE9dUmGoYHlcBwXAQdJo023E2EK1sI3vMeThSwLR4Uvqmb
         L/UItws2SsgGTYK84iVGEuP7c1IfykGDf8kx0hdX5G/MaDrZn/QPZMmhxEHyrAtSsXG7
         t+BkWznYtuDAZGFIaCy6Ud2g0WupmC0rLl1kAEXtqhWiS+ILn4pB2bSv1fVmYo07WH5a
         VXckasac+DUbs09lqaQkpgbK7mDFYDdo+9pj3EBud9aKN6AubiBaVUgay2LFMOZNApsp
         rnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=CbyJPvhn+rM4XFjJsBw6dpHXIScUz8tfnRZrbPPktCM=;
        b=PyDfHnvnLkFfJSvbrV+FswCyBP1pgvZ9IiUjw9IlMy2gB3xA63BV1scNWfuNDCsj7s
         TIk/KLGuuA2Ef0sueJLMzRG5F6RGKZ7MkqI5o6HJJVLabJCp/XaUy7y8LuPwA/TUZgu6
         f7sgvJloWzFvaXn0Xk0vIwprY2Xoxbn2yloxFaiQDF7M5we8L2iDV4LxGXlxA+EdtdlJ
         jKT/Lw+EGBVRoasyWqq3MKu1pKC+wycGaqTHjQhKr1dx/MlLOs7CN4sJ2qPZd5OXEz0A
         p1flU9IRZUXe6xo0XcJ+jAonMV6andfmhJDtd2fEyJn84CffNG1dGhS9wpxaE64d+GZQ
         USPw==
X-Gm-Message-State: APjAAAVYnmJmFKAoEHOKpREyyO2wdn19YjLaRvZiOmmB9+ZHcZLI/GKJ
        j4N161XkuskbyUJEWNd+aYQWj5YzsR4=
X-Google-Smtp-Source: APXvYqxrES0+QjZFOHq5fj7o5XvEsOykiv7lUlG+4B43pk5hCcE1ltyV28FwsjUyAIuTeS1/vDpnBA==
X-Received: by 2002:adf:e84b:: with SMTP id d11mr17387906wrn.289.1554722091523;
        Mon, 08 Apr 2019 04:14:51 -0700 (PDT)
Received: from konferenz-8d46b9eb.on.site.uni-stuttgart.net (konferenz-8d46b9eb.on.site.uni-stuttgart.net. [141.70.185.235])
        by smtp.gmail.com with ESMTPSA id y9sm50630932wrn.18.2019.04.08.04.14.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 04:14:50 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <A80B5976-DFD8-44A6-B726-C2C689F6185A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_37A56758-635C-4CDC-ABE6-E4A681E30D8B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] mke2fs: allow 64bit feature without extents
Date:   Mon, 8 Apr 2019 05:15:10 -0600
In-Reply-To: <20190406215210.GC18897@mit.edu>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
References: <1553246667-53793-1-git-send-email-adilger@dilger.ca>
 <20190406215210.GC18897@mit.edu>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_37A56758-635C-4CDC-ABE6-E4A681E30D8B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Apr 6, 2019, at 3:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Fri, Mar 22, 2019 at 03:24:27AM -0600, Andreas Dilger wrote:
>> From: Andreas Dilger <adilger@whamcloud.com>
>> 
>> The 64bit feature should be allowed without extents to for 32-bit
>> metadata_csum checksums to be stored in the group descriptor.
>> Change the extents check to check for more than 2^32 blocks instead
>> of the 64bit feature flag.  This also avoids warnings later if the
>> metadata_csum feature is enabled on a filesystem without 64bit.
> 
> So what worries me about this change is if extents aren't enabled, and
> we do an online (or off-line) resize such that we now have > 2^32
> blocks, things are going to get problematic.  Even if the resize
> operation sets the extent feature (which I don't think it will), the
> problem is if you have an existing file which is using indirect
> blocks, and you try to extend the file and there is simply no blocks
> under the 2^32 cutoff, what then?  Some files might get ENOSPC errors
> while others will work just fine.
> 
> With current versions of e2fsprogs we enable the 64-bit (and
> metadata_csum) feature by default, which should avoid all of these
> problems.  Sure, that's not going to help older file systems --- but
> this patch to mke2fs isn't going to help them, either.
> 
> It simplifies our test matrix to simply require the extents feature if
> the 64-bit feature is desired.  I'm not sure I see the value in
> relaxing this requirement.  Is there a reason why you specifically
> want 64bit && !extents && metadata_csum?

Mostly we want to enable metadata_csum on Lustre metadata targets, which
are typically always under 16TB in size, and since the MDT doesn't store
much file data, it is more efficient to use block-mapped directories
rather than extent-mapped, since directory blocks are typically allocated
randomly, so extents are not really useful or needed.

Currently the "64bit" feature is needed to get large group_descriptor
entries to store the 32-bit metadata_csum fields to enable metadata_csum,
which is the reason for this patch.  If it were possible to enable 64-byte
struct ext4_group_desc without the 64bit feature so that metadata_csum
could store 32-bit checksums, that would be another solution instead of
requiring 64bit to be enabled without extents.

Cheers, Andreas






--Apple-Mail=_37A56758-635C-4CDC-ABE6-E4A681E30D8B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyrLT4ACgkQcqXauRfM
H+Bxhg//daikdoU11ZGk2W7rJwKRYJbp4rPAH/6ZjFxjRkaefRlQv7AG68O42Lwv
KyexT8Fy6QvXbs+RjfKG4udsqAAYGaEAKu+hDHb8YT67q+8DEc6QGgGLzZRutG1+
l8MRTUumSV3Zd6srPueyam/qch4zcHmZc1isfI2QtoNv0faztMnwX40o/A9loRid
O1LZCW1BCw1PpTYRwRKd7Wu57R2UkKNG3L1GTd3BXuH3fu+HfbVJ+ALzEDppcW63
Pq1L4c/R3Vb+pWmei/oK+ht3KK3xQ7l5aECdpDnVC281V6GDTAdJlHrkeOqa+pM6
WVc+dEULrx1heFPEAVIyaQgsJIIYn4tT+Fv/nBp/QsxODpjy1pyFcZv/XcfWpGN9
uUtDRObY7ScFwOUyVBuZchPJEaUmdTv4uraiVmrWOEmrn654pflY1YhAkeekx05A
hHAKxyoyrNlc2VpAGaaa0nj3/+CY5k+0VjPWGsyRRhIGldzhKuHQ4bSIqRBIJXz3
qRXKoGAmbu3WUZwAdlLF27xbIr0B/D8LZl9azcetJemMRd7p+IZpMz6icqxIj/4L
6KbxsGZxYVXmns9s/3v909xyina3qyAPAT1gdCTLZdfO/HDR2CwtJhkYOO6gkN3j
tJUUhXEHEtM4l2gvJwwJIA0QcU1qbt4b5fzcM/1IebFAlVhdn9g=
=bUU1
-----END PGP SIGNATURE-----

--Apple-Mail=_37A56758-635C-4CDC-ABE6-E4A681E30D8B--
