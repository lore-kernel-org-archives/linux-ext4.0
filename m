Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbfABO1g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Jan 2019 09:27:36 -0500
Date: Wed, 02 Jan 2019 14:27:34 +0000
From: Sasha Levin <sashal@kernel.org>
To: Sasha Levin <sashal@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, <stable@vger.kernel.org>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ext4: avoid kernel warning when writing the superblock to a dead device
In-Reply-To: <20181231194836.3761-1-tytso@mit.edu>
References: <20181231194836.3761-1-tytso@mit.edu>
Message-Id: <20190102142735.954A1218DE@mail.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v4.20.0, v4.19.13, v4.14.91, v4.9.148, v4.4.169, v3.18.131, 

v4.20.0: Build OK!
v4.19.13: Build OK!
v4.14.91: Build OK!
v4.9.148: Build OK!
v4.4.169: Failed to apply! Possible dependencies:
    1566a48aaa10 ("ext4: don't lock buffer in ext4_commit_super if holding spinlock")
    4743f8399061 ("ext4: Fix WARN_ON_ONCE in ext4_commit_super()")

v3.18.131: Failed to apply! Possible dependencies:
    1566a48aaa10 ("ext4: don't lock buffer in ext4_commit_super if holding spinlock")
    4743f8399061 ("ext4: Fix WARN_ON_ONCE in ext4_commit_super()")
    564bc402526e ("ext4, jbd2: add REQ_FUA flag when recording an error in the superblock")


How should we proceed with this patch?

--
Thanks,
Sasha
