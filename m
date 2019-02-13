Return-Path: <SRS0=kW/n=QU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DBCC282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 17:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA1D20838
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 17:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=utexas-edu.20150623.gappssmtp.com header.i=@utexas-edu.20150623.gappssmtp.com header.b="RTGcBOt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbfBMRaj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Feb 2019 12:30:39 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:41104 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388566AbfBMRai (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2019 12:30:38 -0500
Received: by mail-ot1-f54.google.com with SMTP id u16so5610027otk.8
        for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2019 09:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9xa3XIz51oFyKfss955DSgJCAqBn+cdpKHROU8nAMUg=;
        b=RTGcBOt8R/1gnqDkqPrT6p+HSTIjc3Yqvb5kcIdl3gJHoAA76SwH7U/+W5aHAxATi+
         +r64fP/0Qflt0PW1JmPdm1Yiw9BZNXCTYmiLQZ3d00N8TqLA8knze9EzbmD5/IJ5igLt
         IBnqXvuaMCtJvDXSETQAUfbY0UOBZpi5aXB6SvxFWPJVv7KJdcoyDTthBv221Y0zsX//
         wPRhQb3Xg7R2bCCF33+bezOZeKhrZEHe2KhfYnFZls1KPbDgRd4h/nzDzccFGfXyinjP
         s5XKFcHFGNy5JoA7Nx+9QMC88fCElLhIF71+E942KZAwzJPiL2vWCScfa9rWkosN2XZ5
         sNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xa3XIz51oFyKfss955DSgJCAqBn+cdpKHROU8nAMUg=;
        b=QshsSqW50GnS7IZydWRMSh3qAUOPTtyWW7sIIIR85bzbvxPzSW715m533pRI3+8sIj
         hwK8YL3oHpSwTxfxZmIDKA7Es7bpTGxhJIKDMF51mFYumY39bvVh+uWhZLwoePorCX3j
         72Ko1tahIPz8/LSlyLjhrfaFM3AbKmYcKjUtYo3A8+F/t8JK0cQaywwR8iq+s7/hEp4y
         u7DoLZKQRmi5aOD4FKbFL/CohLHpYNlpSj5hVtKG/jiuvb6JxcnO6Fp7+KpxTCnML8Oz
         D/AEQUIa4K91jbWnjcY7SchYggB8KzO0sbkKt4hLKdIE2lAzoCuDE61fMzKuNSbg2A3p
         BUxQ==
X-Gm-Message-State: AHQUAuZ8XowxKE4EOUYe9Ch5igg8Wb8BiZrK+f716adV8UyhZmqAdBk6
        31QsYlCvlDCfUTTFMSlfLLVJhcyX8tG61988N82unmGvHms=
X-Google-Smtp-Source: AHgI3IZ8/u11iFZ9OUj9ZZnC5VtOORLOXxUmLdmQWPe7iB+eEbfw1LaXKGRxHhlX1Bnkq3dhl7eg0emjHHHqUxa57LE=
X-Received: by 2002:a05:6808:6ca:: with SMTP id m10mr661636oih.7.1550075457770;
 Wed, 13 Feb 2019 08:30:57 -0800 (PST)
MIME-Version: 1.0
References: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
 <12FEF208-5FAE-4EE7-93D1-34359A0CBE4F@dilger.ca>
In-Reply-To: <12FEF208-5FAE-4EE7-93D1-34359A0CBE4F@dilger.ca>
From:   Vijay Chidambaram <vijayc@utexas.edu>
Date:   Wed, 13 Feb 2019 10:30:47 -0600
Message-ID: <CAHWVdUXwzLoeqGjanWYcwQvUqZKJnQnuiSKx=_PjDOz4t1Ox7g@mail.gmail.com>
Subject: Re: Selective Data Journaling in ext4
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, jesus.palos@utexas.edu,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 11, 2019 at 7:25 PM Andreas Dilger <adilger@dilger.ca> wrote:
>
> On Feb 11, 2019, at 5:14 PM, Vijay Chidambaram <vijayc@utexas.edu> wrote:
> >
> > Hi all,
> >
> > We would like to present an idea to improve the performance of data
> > journaling in ext4. Data journaling is expensive because data is
> > written twice: once to the journal and once to the actual file system.
> > Passing data through the journal provides consistency guarantees that
> > ordered journaling mode cannot provide (for example, data journaling
> > prevents a data block from being partially written).
> >
> > The idea behind Selective Data Journaling is simple: create a new
> > journaling mode by modifying ordered journaling mode to journal data
> > blocks which are already part of a file. Data blocks which are newly
> > allocated are not part of the journal, and are written out before the
> > journal blocks in accordance with ordered mode's ordering guarantees.
> > If there is a crash before transaction commit, the only side effect is
> > un-allocated data blocks getting written with new data.
> >
> > Selective Data Journaling provides a lot of the benefits of data
> > journaling, at significantly lower cost. For workloads which mostly
> > deal with new data blocks (any applications which update files via
> > atomic rename), Selective Data Journaling can increase performance
> > significantly.
>
> One major caveat here is that files are *very rarely* overwritten in
> place.  This is mostly useful for database-type workloads, and most
> databases already have their own transaction journal independent of
> the filesystem journal, so AFAIK this would not be a very widely-used
> feature.

Agreed, but another way to view this feature is that it is dynamic
switching between ordered mode and data journaling mode. We switch to
data journaling mode exactly when it is required, so you are right
that most applications would never see a difference. But when it is
required, this scheme would ensure stronger semantics are provided.
Overall, it provides data-journaling guarantees all the time, and I
was thinking some applications would like that peace of mind.

> That said, a related, but IMHO much more useful form of selective data
> journaling would be for "random IOPS" workloads, where there may be
> many small writes either to a single file or to many small files, and
> this IO could be aggregated and optimized with fast linear writes to
> the journal, possibly on a separate flash device.  That avoids a lot
> of seeks for the main filesystem device for small IO (which would
> otherwise be IOPS limited and not bandwidth limited, so the double data
> writes are not a limiting factor), while allowing large writes to go
> directly to the filesystem device and avoid the double writes (which
> would otherwise reduce IO bandwidth by half).
>
> Since we already have delalloc to pre-stage the dirty pages before the
> write, we can make a good decision about whether the file data should
> be written to the journal or directly to the filesystem.
>
> This could likely leverage the work that was already done for SMR journal
> mode (Ted has patches, and I think they are available online as well),
> and hopefully integrate both those patches and this new work into mainline
> ext4.
>
> I'm happy to discuss this further if you are interested.

We like this idea as well, and would be happy to work on it! To make
sure we are on the same page, the proposal is to:
- identify whether writes are sequential or random (1)
- Send random writes to the journal if Selective Data Journaling is enabled (2)

How should we do (1)? Also, would it make sense to do this per-file
instead of as a mode for the entire file system? I am thinking of
opening a file with O_SDJ which will convert random writes to
sequential and increase performance.
