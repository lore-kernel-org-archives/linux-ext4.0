From: jon ernst <jonernst07@gmail.com>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Thu, 10 Apr 2014 23:10:47 -0400
Message-ID: <CAGW2f1HpTEihjEaSk+bTxDBFhSuxxUpLq2wdzoo59xQHOPC+3A@mail.gmail.com>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
	<20140409220320.GC15303@thunk.org>
	<CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
	<20140410135637.GC15925@thunk.org>
	<20140410184215.GA9171@birch.djwong.org>
	<20140411030739.GD23620@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42807 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaDKDKs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2014 23:10:48 -0400
Received: by mail-qc0-f173.google.com with SMTP id r5so5373947qcx.18
        for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2014 20:10:47 -0700 (PDT)
In-Reply-To: <20140411030739.GD23620@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 11:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Apr 10, 2014 at 11:42:15AM -0700, Darrick J. Wong wrote:
>>
>> From a quick visual inspection and a sparse bitwise check, e4defrag looks 64bit
>> clean.
>
> Thanks for checking!  I've applied Jon's patch.
>
>                                          - Ted
Thanks Ted, I have also checked e4defrag.c with eyeballs. All physical
blocks are represented by 64bit.
