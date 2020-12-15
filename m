Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20539C4361B
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Dec 2020 17:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2EE5225AB
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Dec 2020 17:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgLORSR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:18:17 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55076 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729936AbgLORSF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2020 12:18:05 -0500
Received: from [IPv6:2a01:e35:2fb5:1510:37ed:2c43:5fa2:bd48] (unknown [IPv6:2a01:e35:2fb5:1510:37ed:2c43:5fa2:bd48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aferraris)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id E22851F454A3;
        Tue, 15 Dec 2020 17:17:21 +0000 (GMT)
Subject: Re: [PATCH RESEND v2 07/12] e2fsck: Support casefold directories when
 rehashing
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org, drosen@google.com, ebiggers@kernel.org,
        tytso@mit.edu
References: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
 <20201210150353.91843-8-arnaud.ferraris@collabora.com>
 <87y2i51ixm.fsf@collabora.com>
From:   Arnaud Ferraris <arnaud.ferraris@collabora.com>
Message-ID: <40566e74-abd8-13df-45b9-2cf26f89ad54@collabora.com>
Date:   Tue, 15 Dec 2020 18:17:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <87y2i51ixm.fsf@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



Le 10/12/2020 à 21:53, Gabriel Krisman Bertazi a écrit :
> Arnaud Ferraris <arnaud.ferraris@collabora.com> writes:
> 
>> From: Gabriel Krisman Bertazi <krisman@collabora.com>
>>
>> @@ -403,11 +451,12 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
>>  		ent = fd->harray + i;
>>  		prev = ent - 1;
>>  		if (!ent->dir->inode ||
>> -		    (ext2fs_dirent_name_len(ent->dir) !=
>> -		     ext2fs_dirent_name_len(prev->dir)) ||
>> -		    memcmp(ent->dir->name, prev->dir->name,
>> -			     ext2fs_dirent_name_len(ent->dir)))
>> +		    !same_name(cmp_ctx, ent->dir->name,
>> +			       ext2fs_dirent_name_len(ent->dir),
>> +			       prev->dir->name,
>> +			       ext2fs_dirent_name_len(prev->dir)))
>>  			continue;
>> +
> 
> noise.

Could you please be more specific?

Arnaud

> 
> Other than that, I think this is still good.
> 
>>  		pctx.dirent = ent->dir;
>>  		if ((ent->dir->inode == prev->dir->inode) &&
>>  		    fix_problem(ctx, PR_2_DUPLICATE_DIRENT, &pctx)) {
>> @@ -426,10 +475,11 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
>>  		mutate_name(new_name, &new_len);
>>  		for (j=0; j < fd->num_array; j++) {
>>  			if ((i==j) ||
>> -			    (new_len !=
>> -			     (unsigned) ext2fs_dirent_name_len(fd->harray[j].dir)) ||
>> -			    memcmp(new_name, fd->harray[j].dir->name, new_len))
>> +			    !same_name(cmp_ctx, new_name, new_len,
>> +				       fd->harray[j].dir->name,
>> +				       ext2fs_dirent_name_len(fd->harray[j].dir))) {
>>  				continue;
>> +			}
>>  			mutate_name(new_name, &new_len);
>>  
>>  			j = -1;
>> @@ -894,6 +944,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino,
>>  	struct fill_dir_struct	fd = { NULL, NULL, 0, 0, 0, NULL,
>>  				       0, 0, 0, 0, 0, 0 };
>>  	struct out_dir		outdir = { 0, 0, 0, 0 };
>> +	struct name_cmp_ctx name_cmp_ctx = {0, NULL};
>>  
>>  	e2fsck_read_inode(ctx, ino, &inode, "rehash_dir");
>>  
>> @@ -921,6 +972,11 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino,
>>  		fd.compress = 1;
>>  	fd.parent = 0;
>>  
>> +	if (fs->encoding && (inode.i_flags & EXT4_CASEFOLD_FL)) {
>> +		name_cmp_ctx.casefold = 1;
>> +		name_cmp_ctx.tbl = fs->encoding;
>> +	}
>> +
>>  retry_nohash:
>>  	/* Read in the entire directory into memory */
>>  	retval = ext2fs_block_iterate3(fs, ino, 0, 0,
>> @@ -949,16 +1005,16 @@ retry_nohash:
>>  	/* Sort the list */
>>  resort:
>>  	if (fd.compress && fd.num_array > 1)
>> -		qsort(fd.harray+2, fd.num_array-2, sizeof(struct hash_entry),
>> -		      hash_cmp);
>> +		qsort_r(fd.harray+2, fd.num_array-2, sizeof(struct hash_entry),
>> +			hash_cmp, &name_cmp_ctx);
>>  	else
>> -		qsort(fd.harray, fd.num_array, sizeof(struct hash_entry),
>> -		      hash_cmp);
>> +		qsort_r(fd.harray, fd.num_array, sizeof(struct hash_entry),
>> +			hash_cmp, &name_cmp_ctx);
>>  
>>  	/*
>>  	 * Look for duplicates
>>  	 */
>> -	if (duplicate_search_and_fix(ctx, fs, ino, &fd))
>> +	if (duplicate_search_and_fix(ctx, fs, ino, &fd, &name_cmp_ctx))
>>  		goto resort;
>>  
>>  	if (ctx->options & E2F_OPT_NO) {
> 
