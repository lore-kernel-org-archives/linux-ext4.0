Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56098 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbeLFXJj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:39 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
References: <20181206220429.10722-1-krisman@collabora.com>
        <20181206225008.GB19305@dastard>
Date: Thu, 06 Dec 2018 18:09:35 -0500
In-Reply-To: <20181206225008.GB19305@dastard> (Dave Chinner's message of "Fri,
        7 Dec 2018 09:50:08 +1100")
Message-ID: <87sgzap80g.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Dec 06, 2018 at 05:04:06PM -0500, Gabriel Krisman Bertazi wrote:
>> Hi,
>> 
>> Following the e2fsprogs changes, these are the corresponding kernel-side
>> modifications to support the fname_encoding feature.
>> 
>> The patches are split in two parts. The fist 14 patches are refactoring
>> and improvements to the NLS code, including the utf8 normalization
>> support.  The final patches implement the fname_encoding feature in ext4.
>
> Please repost this all to linux-fsdevel@vger.kernel.org. You're
> changing a significant amount of non-ext4 filesystem code, as well
> as adding core filesystem infrastructure so it needs to have wider
> visibility and review than just the ext4 list.

Thanks.  I've submitted it again with a cc to linux-fsdevel. 

-- 
Gabriel Krisman Bertazi
