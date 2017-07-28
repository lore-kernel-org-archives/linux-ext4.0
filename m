From: Sahitya Tummala <stummala@codeaurora.org>
Subject: e2fsck on encrypted directories
Date: Fri, 28 Jul 2017 15:32:24 +0530
Message-ID: <23b72f10-bbe6-1e7d-89b6-7b8bebab8d13@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdG1KC2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jul 2017 06:02:28 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I got a question on usage of e2fsck with -D option on EXT4 FS, where
file based encryption is enabled. Is this option supposed to work on
encrypted directories?

I have encountered a case where e2fsck gets stuck
in duplicate_search_and_fix() due to strncmp checks done in this function
on encrypted file names, which may contain NUL characters.

Also, even without -D option passed, there can be a case of duplicate 
entries (i.e.,
ctx->dirs_to_hash is not NULL). In this case too we may see the same issue
in duplicate_search_and_fix() if the directory is encrypted.
Is my understanding correct? Please share your comments.

Thanks,
Sahitya.

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
