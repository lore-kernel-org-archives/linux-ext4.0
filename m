Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BEAC4361B
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Dec 2020 17:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838D2225AB
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Dec 2020 17:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgLORRg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:17:36 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55068 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbgLORRa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2020 12:17:30 -0500
Received: from [IPv6:2a01:e35:2fb5:1510:37ed:2c43:5fa2:bd48] (unknown [IPv6:2a01:e35:2fb5:1510:37ed:2c43:5fa2:bd48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aferraris)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 51DB61F454A0;
        Tue, 15 Dec 2020 17:16:48 +0000 (GMT)
Subject: Re: [PATCH RESEND v2 06/12] e2fsck: Fix entries with invalid encoded
 characters
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org, drosen@google.com, ebiggers@kernel.org,
        tytso@mit.edu
References: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
 <20201210150353.91843-7-arnaud.ferraris@collabora.com>
 <87360d2xm9.fsf@collabora.com>
From:   Arnaud Ferraris <arnaud.ferraris@collabora.com>
Message-ID: <e991ad61-684b-8d40-8af6-ddf341ba44c2@collabora.com>
Date:   Tue, 15 Dec 2020 18:16:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <87360d2xm9.fsf@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Gabriel,

Le 10/12/2020 à 21:51, Gabriel Krisman Bertazi a écrit :
> Arnaud Ferraris <arnaud.ferraris@collabora.com> writes:
> 
>> From: Gabriel Krisman Bertazi <krisman@collabora.com>
>>
>> @@ -1483,11 +1520,7 @@ skip_checksum:
>>  		if (check_filetype(ctx, dirent, ino, &cd->pctx))
>>  			dir_modified++;
>>  
>> -		if (dir_encpolicy_id == NO_ENCRYPTION_POLICY) {
>> -			/* Unencrypted directory */
>> -			if (check_name(ctx, dirent, &cd->pctx))
>> -				dir_modified++;
>> -		} else {
>> +		if (dir_encpolicy_id != NO_ENCRYPTION_POLICY) {
>>  			/* Encrypted directory */
>>  			if (dot_state > 1 &&
>>  			    check_encrypted_dirent(ctx, dirent,
>> @@ -1497,6 +1530,14 @@ skip_checksum:
>>  				dir_modified++;
>>  				goto next;
>>  			}
>> +		} else if (cf_dir) {
>> +			/* Casefolded directory */
>> +			if (encoded_check_name(ctx, dirent, &cd->pctx))
>> +				dir_modified++;
>> +		} else {
>> +			/* Unencrypted and uncasefolded directory */
>> +			if (check_name(ctx, dirent, &cd->pctx))
>> +				dir_modified++;
>>  		}
> 
> This won't do for encrypted+casefolded directories, right?

Indeed, as encrypted+casefolded isn't supported right now, it's just a
re-arrangement to ease future support, as suggested by Eric.

Arnaud

> 
>>  
>>  		if (dx_db) {
> 
