Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA18BC10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7635F2084D
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 09:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=movia-biz.20150623.gappssmtp.com header.i=@movia-biz.20150623.gappssmtp.com header.b="O5OShimT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfDKJp7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:45:59 -0400
Received: from mail-it1-f178.google.com ([209.85.166.178]:54984 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfDKJp7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 05:45:59 -0400
Received: by mail-it1-f178.google.com with SMTP id a190so131906ite.4
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 02:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=movia-biz.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=9CgAdBGCiUj9qRYFRV5WGEzz1/lmF23qR6ThoHCP7lc=;
        b=O5OShimTYrePk11HV3jXTbKSj1W0vCZtZMZ8wTZuQptz0qCK6X4AEKpOIwkOkHShfe
         ESujivo+uqSFXstwWIH5jDXwV/Oxq8qjTyE/PssWygrMzJUqHs7F7FsjuScTaqzY+cxC
         ADGwbJIZ2AfGZECmttFuizl4r/geYFwWw08CXDTuHVQavMpQHKM54Qc/y6jjefHJZpA4
         gr8p2gs3sT9kYz2bLjcFwk32wgIhLzui0GclVr9ZteGPmsIvfBxgk4SwMUu4gaMr4Nik
         4REJtmHb3JDjFmOirciNjZpYOz9ntYR/WsxRmpqgrK++74ONqmxbWxoRzR47ogLFK/59
         M4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=9CgAdBGCiUj9qRYFRV5WGEzz1/lmF23qR6ThoHCP7lc=;
        b=bZAefp0fVsKkG5o+I+VszQ5tKm43AFtaJQ17VPrpMrMksylaj0zE8owX1qxQYt0zFk
         Iu62UO2PSRifo6yavbj58Txk11zULh81YGchgyY/2XdJlpda/XvR27C9gOrTBaDhORst
         kUy65QGhNb/qZ4wR7YrG7KvMWkG941zKkrvu4XVg33HgDkxg0fcOQdqnf0s3RRVdpdf6
         aVMmFmmTybRK/ygZfF6u1f8jG/6Vn9/9dOvAJGH/N8JGxsasVMN7riZm7uDvjjx68sy4
         hSxLQXTDjYlVCcaEscQ+YtcrwlDOSmI9dZGhhzTGyFBIffmsW9Qr/QTn9zmnFXHrSYZU
         0Ktg==
X-Gm-Message-State: APjAAAXMTZ7MamDbVngI708cDK4Kg6vmHPdP2Mux+xD7wuhGszqRDXf1
        91NVeP5Ej2FoswlT08gs4hU185OFVYIc9sBOum3UBfISmcI=
X-Google-Smtp-Source: APXvYqz8di0ulRsbo4x997bsjYFVH1lcHrb7jYZuhyguPcgj4twXvuwWxtfaugRNoDPqH+/B3DIu3fvRE8zj6RGP6vg=
X-Received: by 2002:a24:4109:: with SMTP id x9mr7514879ita.111.1554975958118;
 Thu, 11 Apr 2019 02:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
 <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com> <093e8c89-79f7-e207-6cb5-d66dadab60c2@thelounge.net>
In-Reply-To: <093e8c89-79f7-e207-6cb5-d66dadab60c2@thelounge.net>
From:   Andrea Lo Pumo <alopumo@movia.biz>
Date:   Thu, 11 Apr 2019 11:45:46 +0200
Message-ID: <CABxFBzGK9qSny7PdFOxpjK2evr8xZ5xCECRkcKCou1R-uyVu+g@mail.gmail.com>
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. Seeking
 professional help or programming hints for the recovery.
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Il giorno gio 11 apr 2019 alle ore 11:42 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
>
> Am 11.04.19 um 11:37 schrieb Andrea Lo Pumo:
> > On /dev/sda1(*) there was an ext4 file system with a lot of large
> > files. Now, by mistake, mkfs.ext4 has been run on /dev/sda1. The
> > result is that now /dev/sda1 is "empty": mounting it shows no files.
> >
> > Note *: actually, it is /dev/mapper/secure_storage, an encrypted
> > volume opened with LUKS: cryptsetup luksOpen /dev/sda1 secure_storage
>
> no
>
> you said you had a LUKS volume on /dev/sda1 which means by directly
> create a fs on /dev/sda1 you have overwritten parts of the encryption
> layer *and* at the same time the filesystem *on top* of it

Sorry, I explained it badly. The commands were:

  cryptsetup luksOpen /dev/sda1 secure_storage
  mkfs.ext4 /dev/mapper/secure_storage
