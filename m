Return-Path: <SRS0=OKzU=N3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:50450 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbeKQB5T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Nov 2018 20:57:19 -0500
Date: Fri, 16 Nov 2018 07:44:24 -0800
From: Andi Kleen <andi@firstfloor.org>
To: Eiichi Tsukata <devel@etsukata.com>
Cc: andi@firstfloor.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] fs: fix race between llseek SEEK_END and write
Message-ID: <20181116154424.da6uz56vatmvz7bo@two.firstfloor.org>
References: <20181116083737.10596-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116083737.10596-1-devel@etsukata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I would like to ask you the following questions;
> 
> Q1. Do you consider this behavior as a bug in kernel?
>     or userspace applications are responseible for it?

Yes I would consider it a bug.

> 
> Q2. If it is a bug, how should we fix it?
> 
> Currently I'm planning to re-introduce generic_file_llseek_unlocked()
> and inode lock in generic_file_llseek() for SEEK_END. Then replace
> generic_file_llseek() with generic_file_llseek_unlocked() if it called
> with inode lock in individual file systems. Please let me know if the
> way is not appropreate or any other better way to fix it.

Sounds reasonable.

-Andi
