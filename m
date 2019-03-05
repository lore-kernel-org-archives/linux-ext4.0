Return-Path: <SRS0=D5Fw=RI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7B6C43381
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 00:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE54F20675
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 00:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="KDggpZWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfCEAxX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 19:53:23 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45798 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCEAxX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 19:53:23 -0500
Received: by mail-pf1-f195.google.com with SMTP id v21so4266848pfm.12
        for <linux-ext4@vger.kernel.org>; Mon, 04 Mar 2019 16:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=FE0CZ1ICDjqjqclfhnQH70XfBH/JmOJiZPDrlXY5WJw=;
        b=KDggpZWqvPpuMJ0LO1Y02qxKtvt3QBhY8XnS91vSWgiZ5rOXA+SlyAzMGRX2IGfrYi
         viiGQIFx3oGYDiWc38ceZ22XlQrbq3fPWXPqXzGEIGHpfDhPQkzqys2GTMZcb+djvboR
         zqXdT/snqD2HdgS3l9H/4mRBgRwnlJxeJHa7orBKozzAcqyPVrxt0FsNBuEH9x+qGiXm
         Y8PoPNPCN4OwJavdx+v2Aiat/1abrT2gD6spe43APaMAgnYb63d3seO9hoMPmqNKvPLY
         IPUeie1fUhPEwoQRbp1x7noJa0HRkUzUS1hHgGXrQPDWa/b+DegLcPd0ahNLqOPj90j/
         VkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=FE0CZ1ICDjqjqclfhnQH70XfBH/JmOJiZPDrlXY5WJw=;
        b=Bdg9fqz/8ZP/qUnsV92iCrzE2DuPV+mCHE9ibhi5kYdw1DrO5S6IK/a0cPCayyDFML
         g2ss+cza7UOvt0bQOvIkIswUKzP3VEzzw9nJJ5eXhq3UFDfhexvERmqy6IB/lvDXvLzQ
         f+QByrfus+eUsthFcNvkATiG8aFLRxAMzm1F3pmdY9SwdKxSzauTCC2fUH3PXdcZDOn2
         g67hyiYtFT38b4UJ/gwL3xCSn+2Dt/WAkbCaRhSMvU4hR+IZiDwKpAIr/5gcTTQ5McjO
         9DcS/LFmzSuapvvJUdlvIHcmGcHRm4M9Jg5MtcfgAdqeu7Yy4IaC09USD8Yn8izD5j5N
         DrEg==
X-Gm-Message-State: APjAAAXPDo0x1Y9TjnzkMu+fOs6+L+TC/vajEwSKgiG9j2pa3P07zzgL
        wn53DAe9s3aRFSskdJ+5OSnA09Zrd0k=
X-Google-Smtp-Source: APXvYqzAbITvFkfWnFaQMlTZeRCj2uB3zlGxp2FPUebzQ6GJNEPms8u9t+NYjVPUwTfbhJoXDIRUfQ==
X-Received: by 2002:a17:902:bd02:: with SMTP id p2mr23079937pls.260.1551747201767;
        Mon, 04 Mar 2019 16:53:21 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:231a:60f1:8e22:bbf8:10ab? ([2605:8d80:4a0:231a:60f1:8e22:bbf8:10ab])
        by smtp.gmail.com with ESMTPSA id v6sm10135975pgb.2.2019.03.04.16.53.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 16:53:20 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Andreas Dilger <adilger@dilger.ca>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ext4: remove useless ext4_pin_inode()
Date:   Mon, 4 Mar 2019 17:41:22 -0700
Message-Id: <50BB10C6-BE07-4BF7-9399-BD7A32EB3A54@dilger.ca>
References: <20190227022048.22887-1-yanaijie@huawei.com> <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
In-Reply-To: <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
X-Mailer: iPhone Mail (16D57)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This was originally added during early ext4 development to pin open director=
ies, but it was never really used. I don't mind to remove it.=20

Cheers, Andreas

> On Mar 3, 2019, at 18:31, Jason Yan <yanaijie@huawei.com> wrote:
>=20
> Friendly ping...
>=20
> Anyone can help to review this patch?
>=20
>> On 2019/2/27 10:20, Jason Yan wrote:
>> This function is never used from the beginning. Let's remove it.
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>  fs/ext4/inode.c | 30 ------------------------------
>>  1 file changed, 30 deletions(-)
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 34d7e0703cc6..0060d08edd92 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -6089,36 +6089,6 @@ void ext4_dirty_inode(struct inode *inode, int fla=
gs)
>>      return;
>>  }
>>  -#if 0
>> -/*
>> - * Bind an inode's backing buffer_head into this transaction, to prevent=

>> - * it from being flushed to disk early.  Unlike
>> - * ext4_reserve_inode_write, this leaves behind no bh reference and
>> - * returns no iloc structure, so the caller needs to repeat the iloc
>> - * lookup to mark the inode dirty later.
>> - */
>> -static int ext4_pin_inode(handle_t *handle, struct inode *inode)
>> -{
>> -    struct ext4_iloc iloc;
>> -
>> -    int err =3D 0;
>> -    if (handle) {
>> -        err =3D ext4_get_inode_loc(inode, &iloc);
>> -        if (!err) {
>> -            BUFFER_TRACE(iloc.bh, "get_write_access");
>> -            err =3D jbd2_journal_get_write_access(handle, iloc.bh);
>> -            if (!err)
>> -                err =3D ext4_handle_dirty_metadata(handle,
>> -                                 NULL,
>> -                                 iloc.bh);
>> -            brelse(iloc.bh);
>> -        }
>> -    }
>> -    ext4_std_error(inode->i_sb, err);
>> -    return err;
>> -}
>> -#endif
>> -
>>  int ext4_change_inode_journal_flag(struct inode *inode, int val)
>>  {
>>      journal_t *journal;
>=20
